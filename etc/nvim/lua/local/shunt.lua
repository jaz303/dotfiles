-- shunt.lua
--
-- TODO: tabpage support
-- TODO: remove indentation from shunted entries

local M = {}
local Entries = {}

local FILETYPE = "rtb-shunt"

--
-- Buffer

-- Buffer used to store current shunt list
local buf = nil

local function create_buffer()
  local b = vim.api.nvim_create_buf(false, true)
  vim.bo[b].buftype = "nofile"
  vim.bo[b].swapfile = false
  vim.bo[b].bufhidden = "hide"
  vim.bo[b].modifiable = false
  vim.bo[b].filetype = FILETYPE
  vim.bo[b].readonly = true
  vim.bo[b].syntax = "markdown"
  vim.api.nvim_buf_set_option(b, "wrap", true)
  vim.api.nvim_buf_set_option(b, "linebreak", true)
  vim.api.nvim_buf_set_name(b, '~shunt~')
  return b
end

local function get_buffer()
  if not buf then
    buf = create_buffer()
  end
  return buf
end

--
-- Window
--
-- This is all a bit of a mess right now because my first-pass integrated
-- tightly with my dubious home-grown window manager. I've just put the
-- minimum in here to make it work.

local WIDTH = 60

local function find_side_window()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(w)
    local ft = vim.bo[b].filetype
    if ft == FILETYPE or ft == "neo-tree" or ft == "trouble" or ft == "aerial" then
      return w
    end
  end
end

-- When this project is eventually packaged as a plugin, this function will be
-- a configuration option so users can control the window placement. For now we
-- just place it on the right with a fixed width.
local function open_window()
  local w = find_side_window()
  if w then
    vim.api.nvim_win_set_buf(w, get_buffer())
    return w
  else
    return vim.api.nvim_open_win(get_buffer(), false, {
      win = -1,
      split = 'right',
      width = WIDTH,
    })
  end
end

local function hide_window()
  vim.api.nvim_win_close(open_window(), true)
end

--
-- Rendering

local function render()
  local b = get_buffer()
  local out_lines = {}

  for ix, entry in ipairs(Entries) do
    table.insert(out_lines, string.format("# [%d] %s", ix, entry.file))
    table.insert(out_lines, "")
    for _, l in ipairs(entry.lines) do
      table.insert(out_lines, l)
    end
    table.insert(out_lines, "")
  end

  if #out_lines > 0 and out_lines[#out_lines] == "" then
    table.remove(out_lines, #out_lines)
  end

  vim.bo[b].modifiable = true
  vim.bo[b].readonly = false
  vim.api.nvim_buf_set_lines(b, 0, -1, false, out_lines)
  vim.bo[b].readonly = true
  vim.bo[b].modifiable = false
end

--
-- Helpers

-- TODO: think plenary.nvim has more robust tools for this
local function get_current_relative_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return "[No Name]"
  end

  local cwd = vim.fn.getcwd()
  local relpath = vim.fn.fnamemodify(name, ":." .. cwd)
  return relpath
end

local function extract_visual_selection()
  local b = vim.api.nvim_get_current_buf()
  local mode = vim.fn.mode()

  local vstart = vim.fn.getpos("v") -- {bufnum, lnum, col, off}
  local vend = vim.fn.getpos(".")

  local line_start, col_start = vstart[2], vstart[3]
  local line_end, col_end = vend[2], vend[3]

  -- Adjust for reversed selections
  if (line_end < line_start) or (line_end == line_start and col_end < col_start) then
    line_start, col_start, line_end, col_end = line_end, col_end, line_start, col_start
  end

  local raw_lines = vim.api.nvim_buf_get_lines(b, line_start - 1, line_end, false)

  if mode == "v" then
    -- Characterwise
    raw_lines[1] = string.sub(raw_lines[1], col_start, #raw_lines[1])
    raw_lines[#raw_lines] = string.sub(raw_lines[#raw_lines], 1, col_end)
  elseif mode == "V" then
    -- Linewise - nothing to do
  elseif mode == "\22" then
    -- Blockwise
    for i, l in ipairs(raw_lines) do
      raw_lines[i] = string.sub(l, col_start, col_end)
    end
  end

  return {
    range = { line_start, col_start, line_end, col_end },
    lines = raw_lines,
  }
end

local function extract_normal_selection()
  local b = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_win_get_cursor(0)
  local lnum, col = cur[1], cur[2] + 1
  local line = vim.api.nvim_buf_get_lines(b, lnum - 1, lnum, false)[1]
  return {
    range = { lnum, col, lnum, col + #line },
    lines = { line },
  }
end

local function lsp_query(qbuf, op, params, cb)
  vim.lsp.buf_request_all(qbuf, op, params, function(results)
    for client_id, res in pairs(results or {}) do
      local err = res.err or res.error
      if err then
        -- TODO: do we notify about this?
        -- vim.notify(("LSP %d error: %s"):format(client_id, vim.inspect(err)), vim.log.levels.WARN)
      else
        local r = res.result
        if r and not vim.tbl_isempty(r) then
          -- r may be a single Location or an array; take the first item if it's a list
          -- local loc = (vim.tbl_islist(r) and r[1]) or r
          -- schedule UI actions to be safe
          cb(nil, client_id, r)
          -- print(vim.inspect(r))
          return
        end
      end
    end
    cb("No results")
  end)
end

local function error(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

--
-- Public Interface

-- toggle visibility of the shuntlist
M.toggle    = function()
end

-- clear the shuntlist and hide the window
M.clear     = function()
  Entries = {}
  render()
  hide_window()
end

-- remove the nth item from the shuntlist
M.remove    = function()
  local victim = 1

  local new_entries = {}
  for ix, ent in ipairs(Entries) do
    if ix ~= victim then
      table.insert(new_entries, ent)
    end
  end
  Entries = new_entries

  render()
  open_window()
end

M.guess     = function()
  error("not implemented!")
end

-- push the current selection to the shunt buffer
M.selection = function()
  local mode = vim.fn.mode()

  local entry
  if mode == "v" or mode == "V" or mode == "\22" then
    entry = extract_visual_selection()
    vim.schedule(function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    end)
  else
    entry = extract_normal_selection()
  end

  entry.file = get_current_relative_path()

  table.insert(entry.lines, 1, "```" .. vim.bo.filetype)
  table.insert(entry.lines, "```")

  table.insert(Entries, entry)

  render()
  open_window()
end

-- push the LSP docs for the current item under the cursor
M.docs      = function()
  render()
  open_window()
end


-- push the LSP signature for the current item under the cursor
M.signature = function()
  render()
  open_window()
end

M.hover     = function()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  local search_buf = vim.api.nvim_get_current_buf()

  lsp_query(search_buf, "textDocument/hover", params, function(err, cli, res)
    if err then
      -- TODO: handle error
    else
      table.insert(Entries, {
        file = get_current_relative_path(),
        lines = vim.split(res.contents.value, "\n", { plain = true })
      })
      render()
      open_window()
    end
  end)
end

-- push the LSP type for the current item under the cursor
M.type      = function()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  local search_buf = vim.api.nvim_get_current_buf()

  open_window()

  vim.lsp.buf_request_all(search_buf, "textDocument/typeDefinition", params, function(results)
    -- results is a map: client_id -> { err? | error?, result? }
    for client_id, res in pairs(results or {}) do
      local err = res.err or res.error
      if err then
        vim.notify(("LSP %d error: %s"):format(client_id, vim.inspect(err)), vim.log.levels.WARN)
      else
        local r = res.result
        if r and not vim.tbl_isempty(r) then
          -- r may be a single Location or an array; take the first item if it's a list
          local loc = (vim.tbl_islist(r) and r[1]) or r
          -- schedule UI actions to be safe
          print(vim.inspect(r))
          return
        end
      end
    end
    vim.notify("No type definition found", vim.log.levels.INFO)
  end)
end

vim.api.nvim_create_user_command('Shunt', function(opts)
  local fn = M[opts.args]
  if fn ~= nil then
    fn(opts)
  else
    error("Shunt: unknown command")
  end
end, {
  desc = "Shunt",
  nargs = 1,
})

return M
