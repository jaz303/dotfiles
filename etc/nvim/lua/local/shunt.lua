Buf = nil
Win = nil
Entries = {}
Visible = false

local renderers = {
  selection = function(entry, lines)
    for _, l in ipairs(entry.lines) do
      table.insert(lines, l)
    end
  end,
  _default = function(_, lines)
    table.insert(lines, "???")
  end
}

local function get_visual_selection()
  return vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
end

local function get_shunt_buffer()
  if not Buf then
    Buf = vim.api.nvim_create_buf(false, true)
    vim.bo[Buf].modifiable = false
    vim.bo[Buf].readonly = true
    vim.api.nvim_buf_set_name(Buf, '~shunt~')
  end
  return Buf
end

local function get_current_relative_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return "[No Name]"
  end

  local cwd = vim.fn.getcwd()
  local relpath = vim.fn.fnamemodify(name, ":." .. cwd)
  return relpath
end


local function redraw()
  local buf = get_shunt_buffer()
  local out_lines = {}

  for ix, entry in ipairs(Entries) do
    table.insert(out_lines, string.format("[%d] %s", ix, entry.file))
    local renderer = renderers[entry.type] or renderers._default
    renderer(entry, out_lines)
    table.insert(out_lines, "")
  end

  if #out_lines > 0 and out_lines[#out_lines] == "" then
    table.remove(out_lines, #out_lines)
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out_lines)
  vim.bo[buf].modifiable = false
end

-- show shunt window
local function show()
  if Visible then return end

  if #Entries == 0 then
    print("Shunt buffer empty!")
    return
  end

  local buf = get_shunt_buffer()
  local ui = vim.api.nvim_list_uis()[1]
  local win_height = ui.height
  local win_width = ui.width
  
  local height = math.min(vim.api.nvim_buf_line_count(buf), win_height)
  height = 30
  local width = 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    width = math.max(width, #line)
  end

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = 0,
    col = win_width - width,
    style = "minimal",
    border = "single", -- optional
  }

  Win = vim.api.nvim_open_win(get_shunt_buffer(), true, opts)

  Visible = true
end

-- hide shunt window
local function hide()
  if not Visible then return end

  vim.api.nvim_win_close(Win, true)
  Win = nil
  Visible = false
end

-- toggle shunt window
local function toggle()
  if Visible then
    hide()
  else
    show()
  end
end

local function extract_visual_selection()
  local buf = vim.api.nvim_get_current_buf()
  local mode = vim.fn.mode()

  local vstart = vim.fn.getpos("v") -- {bufnum, lnum, col, off}
  local vend = vim.fn.getpos(".")

  local line_start, col_start = vstart[2], vstart[3]
  local line_end, col_end = vend[2], vend[3]

  -- Adjust for reversed selections
  if (line_end < line_start) or (line_end == line_start and col_end < col_start) then
    line_start, col_start, line_end, col_end = line_end, col_end, line_start, col_start
  end

  local raw_lines = vim.api.nvim_buf_get_lines(buf, line_start - 1, line_end, false)

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
  local buf = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_win_get_cursor(0) -- {lnum, col}
  local lnum, col = cur[1], cur[2] + 1
  local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
  return {
    range = { lnum, col, lnum, col + #line },
    lines = { line },
  }
end

-- push the selected text from the active window
local function push_selection()
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

  entry.type = "selection"
  entry.file = get_current_relative_path()

  table.insert(Entries, entry)

  redraw()
  show()
end

-- push the type definition under the cursor in the active window
local function push_type_def()
  redraw()
  show()
end

-- remove the shunt buffer entry at the given index
local function remove(victim)
  local new_entries = {}
  for ix, ent in ipairs(Entries) do
    if ix ~= victim then
      table.insert(new_entries, ent)
    end
  end
  Entries = new_entries
  redraw()
end

local function clear()
  Entries = {}
  redraw()
  hide()
end

vim.api.nvim_create_user_command('ShuntShow', show, {desc = 'Show shunt window'})
vim.api.nvim_create_user_command('ShuntHide', hide, {desc = 'Hide shunt window'})
vim.api.nvim_create_user_command('ShuntToggle', toggle, {desc = 'Toggle shunt window'})

vim.api.nvim_create_user_command('ShuntPushSelection', push_selection, {desc = 'Push selected text to shunt buffer'})
vim.api.nvim_create_user_command('ShuntPushTypeDef', push_type_def, {desc = 'Push selected type to shunt buffer'})

vim.api.nvim_create_user_command(
  'ShuntRemove',
  function(opts)
    local n = tonumber(opts.args)
    if n then
      remove(n)
    else
      print("Invalid index")
    end
  end,
  {
    desc = 'Remove shunt entry',
    nargs = 1,
  }
)

vim.api.nvim_create_user_command('ShuntClear', clear, {desc = 'Clear & hide shunt window'})

return {
  show = show,
  hide = hide,
  toggle = toggle,
  push_selection = push_selection,
  push_type_def = push_type_def,
  remove = remove
}
