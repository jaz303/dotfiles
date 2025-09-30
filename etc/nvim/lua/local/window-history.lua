-- window-history.lua
-- Maintains a per-window history with fwd/back navigation
--
-- Adapted from https://github.com/wilfreddenton/history.nvim

local wm = require("local.wm")
local Path = require("plenary.path")
-- local popup = require("plenary.popup")

local Hist = {}

local function to_relative_path(path)
  return Path:new(path):make_relative(vim.loop.cwd())
end

local function error(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function warn(msg)
  vim.notify(msg, vim.log.levels.WARN)
end

local function clamp(min, max, x)
  if x < min then return min end
  if x > max then return max end
  return x
end

local function current()
  local bufnr = vim.api.nvim_get_current_buf()
  return {
    nr = bufnr,
    name = to_relative_path(vim.api.nvim_buf_get_name(bufnr))
  }
end

local function on_buf_enter()
  local winid = vim.api.nvim_get_current_win()
  if not wm.HasWindow(winid) then
    return -- ignore windows not tracked by WM
  end

  if not Hist[winid] then
    Hist[winid] = { index = 1, buffers = { current() } }
  else
    local h = Hist[winid]

    local ent = current()

    -- Firstly, if the buffer at the current history index matches the
    -- "new" buffer, just do nothing. This ensures the history list is
    -- not changed during fwd/back navigation.
    if ent.nr == h.buffers[h.index].nr then
      return
    end

    -- The history is definitely going to change now so remove any
    -- history entries after the current position
    for i = #h.buffers, h.index + 1, -1 do
      table.remove(h.buffers, i)
    end

    -- TODO: not sure if I like this behaviour?
    -- -- Check the history list for the same buffer. If it's found,
    -- -- swap it to the front
    -- for i = 1, #h.buffers - 1 do
    --   if h.buffers[i].nr == ent.nr then
    --     for j = i + 1, #h.buffers do
    --       h.buffers[j - 1] = h.buffers[j]
    --     end
    --     h.buffers[#h.buffers] = ent
    --     return
    --   end
    -- end

    -- Otherwise, insert a new history entry at the end
    table.insert(h.buffers, ent)
    h.index = #h.buffers
  end
end

local function on_buf_delete()
  -- TODO: look at the histories for all windows and remove references
  -- to the current buffer, taking care to update index appropriately.
end

local function on_win_closed(args)
  local winid = tonumber(args.match)
  if winid ~= nil then
    Hist[winid] = nil
  end
end

local function go(rel)
  local h = Hist[vim.api.nvim_get_current_win()]
  if h == nil then
    warn("No history")
    return
  end

  local new_index = clamp(1, #h.buffers, h.index + rel)
  if new_index == h.index then
    error("End")
    return
  end

  h.index = new_index
  vim.api.nvim_set_current_buf(h.buffers[h.index].nr)
end

-- clear buffer history for the current window
local function clear()
  Hist[vim.api.nvim_get_current_win()] = {
    index = 1,
    buffers = { current() },
  }
end

local group = vim.api.nvim_create_augroup("jwf_window_history", {
  clear = true
})

vim.api.nvim_create_autocmd("BufEnter", { group = group, callback = on_buf_enter })
vim.api.nvim_create_autocmd("BufDelete", { group = group, callback = on_buf_delete })
vim.api.nvim_create_autocmd("WinClosed", { group = group, callback = on_win_closed })

vim.api.nvim_create_user_command('WinHist', function(opts)
  if opts.args == "prev" then
    go(-1)
  elseif opts.args == "next" then
    go(1)
  elseif opts.args == "clear" then
    clear()
  elseif opts.args == "list" then
    -- TODO: popup list
    -- I'll implement this later...
  else
    error("Unknown window history command: " .. opts.args)
  end
end, {
  desc = "Window history",
  nargs = 1,
})
