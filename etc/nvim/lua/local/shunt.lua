local M = {}

local Path     = require("plenary.path")
local settings = require("config.settings")

local cfg          = settings.shunt or {}
local narrow_width = cfg.narrow_width or function() return 60 end
local wide_width   = cfg.wide_width   or function() return 100 end
local get_height   = cfg.height       or function() return vim.o.lines - 2 end

-- State
local entries = {}
local buf     = nil
local win     = nil
local is_wide = false

-- ─── Helpers ─────────────────────────────────────────────────────────────────

local function get_width()
  return is_wide and wide_width() or narrow_width()
end

local function relative_path(abs)
  if not abs or abs == "" then return "[No Name]" end
  return Path:new(abs):make_relative(vim.loop.cwd())
end

-- ─── Buffer ──────────────────────────────────────────────────────────────────

local function get_buffer()
  if buf and vim.api.nvim_buf_is_valid(buf) then return buf end
  buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype   = "nofile"
  vim.bo[buf].swapfile  = false
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly  = true
  vim.bo[buf].filetype  = "shunt"
  vim.bo[buf].syntax    = "markdown"
  vim.api.nvim_buf_set_name(buf, "[Shunt]")
  vim.treesitter.start(buf, "markdown")
  return buf
end

-- ─── Window ──────────────────────────────────────────────────────────────────

local function win_config(width)
  return {
    relative = "editor",
    anchor   = "NE",
    row      = 0,
    col      = vim.o.columns,
    width    = width,
    height   = get_height(),
    style    = "minimal",
    border   = "single",
    zindex   = 50,
  }
end

local function open_window()
  if win and vim.api.nvim_win_is_valid(win) then return win end
  win = vim.api.nvim_open_win(get_buffer(), false, win_config(get_width()))
  vim.wo[win].wrap      = true
  vim.wo[win].linebreak = true
  return win
end

local function close_window()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  win = nil
end

-- ─── Rendering ───────────────────────────────────────────────────────────────

local function render()
  local b = get_buffer()
  local out = {}

  for ix, entry in ipairs(entries) do
    table.insert(out, string.format("# (%d) %s", ix, entry.source))
    table.insert(out, "")

    if entry.lang and entry.lang ~= "" then
      table.insert(out, "```" .. entry.lang)
      for _, l in ipairs(entry.lines) do table.insert(out, l) end
      table.insert(out, "```")
    else
      for _, l in ipairs(entry.lines) do table.insert(out, l) end
    end

    if ix < #entries then
      table.insert(out, "")
      table.insert(out, "---")
      table.insert(out, "")
    end
  end

  vim.bo[b].modifiable = true
  vim.bo[b].readonly   = false
  vim.api.nvim_buf_set_lines(b, 0, -1, false, out)
  vim.bo[b].readonly   = true
  vim.bo[b].modifiable = false
end

local function dedent(lines)
  local min_indent = math.huge
  for _, l in ipairs(lines) do
    if l:match("%S") then
      min_indent = math.min(min_indent, #l:match("^%s*"))
    end
  end
  if min_indent == 0 or min_indent == math.huge then return lines end
  local out = {}
  for _, l in ipairs(lines) do out[#out + 1] = l:sub(min_indent + 1) end
  return out
end

local function push(entry)
  table.insert(entries, entry)
  render()
  if not (win and vim.api.nvim_win_is_valid(win)) then
    open_window()
  end
end

-- ─── LSP helpers ─────────────────────────────────────────────────────────────

local function lsp_request(qbuf, method, params, cb)
  vim.lsp.buf_request_all(qbuf, method, params, function(results)
    for _, res in pairs(results or {}) do
      if not (res.err or res.error) then
        local r = res.result
        if r and not vim.tbl_isempty(r) then
          cb(nil, r)
          return
        end
      end
    end
    cb("No results")
  end)
end

local function trim_trailing_blank(lines)
  while #lines > 0 and lines[#lines]:match("^%s*$") do
    table.remove(lines)
  end
  return lines
end

-- Normalise the three possible hover content shapes to { lang, lines }.
local function normalize_hover(contents)
  if type(contents) == "string" then
    return nil, trim_trailing_blank(vim.split(contents, "\n", { plain = true }))
  end
  if contents.kind then
    -- MarkupContent { kind, value }
    return nil, trim_trailing_blank(vim.split(contents.value, "\n", { plain = true }))
  end
  if contents.language then
    -- Single MarkedString { language, value }
    return contents.language, trim_trailing_blank(vim.split(contents.value, "\n", { plain = true }))
  end
  -- MarkedString[] — concatenate values as plain text
  local lines = {}
  for _, ms in ipairs(contents) do
    local v = type(ms) == "string" and ms or ms.value
    vim.list_extend(lines, vim.split(v, "\n", { plain = true }))
    table.insert(lines, "")
  end
  return nil, trim_trailing_blank(lines)
end

-- ─── Selection extraction ────────────────────────────────────────────────────

local function extract_selection(b)
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" or mode == "\22" then
    local vs = vim.fn.getpos("v")
    local ve = vim.fn.getpos(".")
    local ls, cs = vs[2], vs[3]
    local le, ce = ve[2], ve[3]

    if le < ls or (le == ls and ce < cs) then
      ls, cs, le, ce = le, ce, ls, cs
    end

    local lines = vim.api.nvim_buf_get_lines(b, ls - 1, le, false)

    if mode == "v" then
      lines[1]       = string.sub(lines[1], cs)
      lines[#lines]  = string.sub(lines[#lines], 1, ce)
    elseif mode == "\22" then
      for i, l in ipairs(lines) do
        lines[i] = string.sub(l, cs, ce)
      end
    end

    return lines, true
  end

  -- Normal mode: current line
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  return vim.api.nvim_buf_get_lines(b, lnum - 1, lnum, false), false
end

-- ─── Public API ──────────────────────────────────────────────────────────────

M.toggle = function()
  if win and vim.api.nvim_win_is_valid(win) then
    close_window()
  elseif #entries == 0 then
    vim.notify("Shunt: nothing to show", vim.log.levels.INFO)
  else
    render()
    open_window()
  end
end

M.toggle_width = function()
  is_wide = not is_wide
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_set_config(win, win_config(get_width()))
  end
end

M.selection = function()
  local b = vim.api.nvim_get_current_buf()
  local lang = vim.bo[b].filetype
  local lines, was_visual = extract_selection(b)

  if was_visual then
    vim.schedule(function()
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true
      )
    end)
  end

  push({
    source = relative_path(vim.api.nvim_buf_get_name(b)),
    lang   = (lang ~= "" and lang or nil),
    lines  = dedent(lines),
  })
end

M.hover = function()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  local qbuf   = vim.api.nvim_get_current_buf()
  local source = relative_path(vim.api.nvim_buf_get_name(qbuf))

  lsp_request(qbuf, "textDocument/hover", params, function(err, result)
    if err then
      vim.notify("Shunt hover: " .. err, vim.log.levels.WARN)
      return
    end
    local lang, lines = normalize_hover(result.contents)
    push({ source = source, lang = lang, lines = lines })
  end)
end

M.type = function()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  local qbuf   = vim.api.nvim_get_current_buf()
  local ft     = vim.bo[qbuf].filetype

  lsp_request(qbuf, "textDocument/typeDefinition", params, function(err, result)
    if err then
      vim.notify("Shunt type: " .. err, vim.log.levels.WARN)
      return
    end
    local tbl_islist = vim.islist or vim.tbl_islist
    local loc = tbl_islist(result) and result[1] or result
    require("local.shunt_type").resolve(loc, ft, function(resolve_err, entry)
      if resolve_err then
        vim.notify("Shunt type: " .. resolve_err, vim.log.levels.WARN)
        return
      end
      entry.source = relative_path(entry.source)
      entry.lines  = dedent(entry.lines)
      push(entry)
    end)
  end)
end

M.yank = function()
  if #entries == 0 then
    vim.notify("Shunt: nothing to yank", vim.log.levels.INFO)
    return
  end
  local input = vim.fn.input(string.format("Yank entry # (1-%d): ", #entries))
  local n = tonumber(input)
  if not n or n < 1 or n > #entries then
    if input ~= "" then
      vim.notify("Shunt: invalid index", vim.log.levels.WARN)
    end
    return
  end
  vim.fn.setreg('"', table.concat(entries[n].lines, "\n"))
  vim.notify(string.format("Shunt: yanked entry %d", n), vim.log.levels.INFO)
end

M.clear = function()
  entries = {}
  render()
  close_window()
end

M.kill = function()
  if #entries == 0 then
    vim.notify("Shunt: nothing to kill", vim.log.levels.INFO)
    return
  end
  local input = vim.fn.input(string.format("Kill entry # (1-%d): ", #entries))
  local n = tonumber(input)
  if not n or n < 1 or n > #entries then
    if input ~= "" then
      vim.notify("Shunt: invalid index", vim.log.levels.WARN)
    end
    return
  end
  table.remove(entries, n)
  render()
  if #entries == 0 then close_window() end
end

-- ─── Autocmds ────────────────────────────────────────────────────────────────

local group = vim.api.nvim_create_augroup("shunt", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  callback = function()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_config(win, win_config(get_width()))
    end
  end,
})

vim.keymap.set("n", "q", close_window, { buffer = get_buffer(), silent = true })

return M
