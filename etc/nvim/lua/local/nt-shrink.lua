-- nt-shrink.lua
--
-- Registers the user command :NTShrink to automatically shrink Neotree to
-- the minimum width required to display its content, plus some padding.
--
-- The approach taken is to apply some simple heuristics to the first
-- encountered Neotree window's buffer. The first line (working dir) is ignored
-- when calculating the width because it's not useful information - I usually
-- know which directory I'm working in.
--
-- Doesn't work if Neotree is so wide that it's displaying additional columns
-- e.g. filesize. I don't care about this; if I ever have it that wide it's
-- because I want it like that.

local function split(str)
  local i, j = 0, 0
  local max, off = 0, -1
  while true do
    i, j = string.find(str, "%s+", j + 1)
    if i == nil then break end

    -- disregard leading and trailing space - these are not candidate
    -- split points.
    if i > 1 and j < #str then
      local len = (j - i) + 1
      if len > max then
        max = len
        off = i
      end
    end
  end

  -- if we haven't found a run of at least 3 spaces, do nothing
  -- caller will just use the full string.
  if max < 3 then
    return nil, nil
  end

  return string.sub(str, 1, off - 1), string.sub(str, off + max)
end

local function neotree_resize_to_content()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

    if ft == "neo-tree" then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local max_left, max_right = 0, 0
      for i, line in ipairs(lines) do
        if i > 1 then
          local left, right = split(line)
          if left then
            local l_len = vim.fn.strdisplaywidth(left)
            local r_len = vim.fn.strdisplaywidth(right)
            if l_len > max_left then max_left = l_len end
            if r_len > max_right then max_right = r_len end
          else
            -- no decorations, whole line is "left"
            local l_len = vim.fn.strdisplaywidth(vim.trim(line))
            if l_len > max_left then max_left = l_len end
          end
        end
      end

      local new_width = max_left + 2
      if max_right > 0 then
        new_width = new_width + 1 + max_right
      end

      vim.api.nvim_win_set_width(win, new_width)
      return
    end
  end

  vim.notify("No Neo-tree window found", vim.log.levels.WARN)
end

vim.api.nvim_create_user_command("NTShrink", neotree_resize_to_content, {})
