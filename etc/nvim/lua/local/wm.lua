local wm = {}

local function is_valid_target(win_id)
  local buf = vim.api.nvim_win_get_buf(win_id)
  local buf_type = vim.api.nvim_buf_get_option(buf, "buftype")
  if buf_type ~= "" then
    return false
  end

  local cfg = vim.api.nvim_win_get_config(win_id)
  if cfg.relative ~= "" then
    return false
  end

  return true
end

local function set_all_widths(windows)
  for _, win in pairs(windows) do
    vim.api.nvim_win_set_width(win.id, win.width)
  end
end

local function total_width(windows)
  local out = 0
  for _, win in ipairs(windows) do
    out = out + win.width
  end
  return out
end

local function distribute_missing_widths(windows, available)
  local without_size = 0
  for _, win in ipairs(windows) do
    if win.width == nil then
      without_size = without_size + 1
    end
  end

  if without_size == 0 then
    return
  end

  local window_width = math.floor(available / without_size)
  local window_rem = available % without_size

  for _, win in ipairs(windows) do
    if win.width == nil then 
      local this_width = window_width
      if window_rem > 0 then
        this_width = this_width + 1
        window_rem = window_rem - 1
      end
      win.width = this_width
    end
  end
end

function wm.GetCandidateWindows()
  local window_ids = vim.api.nvim_list_wins()
  local targets = {}

  for _, id in ipairs(window_ids) do
    local pos = vim.api.nvim_win_get_position(id)
    local height = vim.api.nvim_win_get_height(id)
    local width = vim.api.nvim_win_get_width(id)

    if is_valid_target(id) then
      table.insert(targets, {
        id = id,
        x = pos[1],
        y = pos[2],
        width = width,
        height = height,
      })
    end
  end

  table.sort(targets, function(a, b)
    if a.y == b.y then
      return a.x < b.x
    else
      return a.y < b.y
    end
  end)

  return targets
end

function wm.EqualizeWindows()
  local windows = wm.GetCandidateWindows()
  local tot = total_width(windows)

  for _, win in ipairs(windows) do
    win.width = nil
  end

  distribute_missing_widths(windows, tot)
  set_all_widths(windows)
end

function wm.FocusActiveWindow()
  local focus_ratio = 0.75
  local windows = wm.GetCandidateWindows()
  local tot = total_width(windows)
  local focus_width = math.floor(tot * focus_ratio)
  local remain = tot - focus_width
  
  for _, win in ipairs(windows) do
    if win.id == vim.api.nvim_get_current_win() then
      win.width = focus_width
    else
      win.width = nil
    end
  end

  distribute_missing_widths(windows, remain)
  set_all_widths(windows)
end

function wm.SwitchToRelWindow(offset)
  local windows = wm.GetCandidateWindows()
  local curr = vim.api.nvim_get_current_win()
  local target = nil
  for ix, win in ipairs(windows) do
    if win.id == curr then
      target = ix + offset
      break
    end
  end
  if (not target) then
    return
  end
  if target < 1 then
    target = #windows
  elseif target > #windows then
    target = 1
  end
  vim.api.nvim_set_current_win(windows[target].id)
end

function wm.SwitchToNthWindow(n)
  local win = wm.GetCandidateWindows()[n]
  if not win then
    print("No window " .. n)
    return
  end
  vim.api.nvim_set_current_win(win.id)
end

function wm.MoveActiveBufferToNthWindow(n)
  local win = wm.GetCandidateWindows()[n]
  if not win then
    print("No window " .. n)
    return
  end

  -- get the current/alternate buffers
  local cur_buf = vim.api.nvim_get_current_buf()
  local alt_buf = vim.fn.bufnr("#")

  -- if the current buffer is active in the target window, do nothing
  if vim.api.nvim_win_get_buf(win.id) == cur_buf then
    return
  end

  vim.api.nvim_win_set_buf(win.id, cur_buf)

  -- switch the current window to the alternate buffer if valid
  -- otherwise, new empty buffer
  if alt_buf ~= -1 and vim.api.nvim_buf_is_valid(alt_buf) and alt_buf ~= cur_buf then
    vim.api.nvim_set_current_buf(alt_buf)
  else
    vim.cmd("enew")
  end
end

vim.api.nvim_create_user_command(
  'EqualizeWindows',
  wm.EqualizeWindows,
  {
    desc = 'Equalize window widths',
  }
)

vim.api.nvim_create_user_command(
  'FocusActiveWindow',
  wm.FocusActiveWindow,
  {
    desc = 'Focus active window'
  }
)

vim.api.nvim_create_user_command(
  'SwitchToNthWindow',
  function(opts)
    local n = tonumber(opts.args)
    if n then
      wm.SwitchToNthWindow(n)
    else
      print("Invalid window number")
    end
  end,
  {
    desc = 'Switch to nth window',
    nargs = 1,
  }
)

vim.api.nvim_create_user_command(
  'SwitchToRelWindow',
  function(opts)
    local n = tonumber(opts.args)
    if n then
      wm.SwitchToRelWindow(n)
    else
      print("Invalid window number")
    end
  end,
  {
    desc = 'Switch to relative window',
    nargs = 1,
  }
)

vim.api.nvim_create_user_command(
  'MoveActiveBufferToNthWindow',
  function(opts)
    local n = tonumber(opts.args)
    if n then
      wm.MoveActiveBufferToNthWindow(n)
    else
      print("Invalid window number")
    end
  end,
  {
    desc = 'Move active buffer to nth window',
    nargs = 1,
  }
)

return wm
