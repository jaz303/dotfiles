vim.pack.add({
  { src = "https://github.com/jaz303/neo-tree.nvim", version = "ea7bdfc" }
})

local mappings = {}

--
-- Key map for opening files directly into splits

local wm = require('local.wm')

local function open_in_split(n, state)
  local win = wm.GetCandidateWindows()[n]
  if not win then
    print("No window " .. n)
    return
  end

  local node = state.tree:get_node()
  if not node then return end

  local path = node:get_id()
  local new_buf = vim.fn.bufadd(path)
  vim.fn.bufload(new_buf)

  vim.api.nvim_win_set_buf(win.id, new_buf)
end

for n = 1, 8 do
  local desc = "open in window 1 (also 2..8)"
  if n > 1 then
    desc = "<hidden>"
  end
  mappings["" .. n] = {
    function(state) open_in_split(n, state) end,
    desc = desc,
  }
end

--
-- Copy path to register or clipboard
-- Adapted from https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370

local function copy_path(state, reg, desc)
  -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
  -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
  local node = state.tree:get_node()
  local filepath = node:get_id()
  local filename = node.name
  local modify = vim.fn.fnamemodify

  local results = {
    filepath,
    modify(filepath, ":."),
    modify(filepath, ":~"),
    filename,
    modify(filename, ":r"),
    modify(filename, ":e"),
  }

  vim.ui.select({
    "1. Absolute path: " .. results[1],
    "2. Path relative to CWD: " .. results[2],
    "3. Path relative to HOME: " .. results[3],
    "4. Filename: " .. results[4],
    "5. Filename without extension: " .. results[5],
    "6. Extension of the filename: " .. results[6],
  }, { prompt = "Choose to copy to " .. desc .. ":" }, function(choice)
    if choice then
      local i = tonumber(choice:sub(1, 1))
      if i then
        local result = results[i]
        vim.fn.setreg(reg, result)
      else
        vim.notify("Invalid choice")
      end
    else
      vim.notify("Cancelled")
    end
  end)
end

mappings["y"] = {
  function(state)
    copy_path(state, '"', 'register')
  end,
  desc = "Copy path to register"
}

mappings["Y"] = {
  function(state)
    copy_path(state, '+', 'clipboard')
  end,
  desc = "Copy path to clipboard"
}

require("neo-tree").setup({
  filesystem = {
    window = {
      mappings = mappings,
    },
    filtered_items = {
      always_show = {
        ".github",
      }
    }
  },
})

vim.keymap.set('n', '\\', ':Neotree show reveal<CR>', { desc = 'Reveal current file in NT' })
vim.keymap.set('n', '|', ':NTShrink<CR>', { desc = 'Shrink Neotree' })
vim.keymap.set('n', '<leader>fr', ':Neotree show reveal<CR>', { desc = 'Reveal current file in NT' })

-- TODO: trying to make a function that will close all expanded Neotree nodes,
-- then expand the path to the current file. The Neotree "z" command seems to
-- only take effect after a delay, which I think is causing a problem.
-- vim.keymap.set('n', '<leader>fR', function()
--   local win = vim.api.nvim_get_current_win()
--   vim.cmd("Neotree")
--
--   local tree_win
--   for _, w in ipairs(vim.api.nvim_list_wins()) do
--     local buf = vim.api.nvim_win_get_buf(w)
--     local ft = vim.api.nvim_buf_get_option(buf, "filetype")
--     if ft == "neo-tree" then
--       tree_win = w
--       break
--     end
--   end
--
--   if tree_win then
--     vim.api.nvim_set_current_win(tree_win)
--     vim.api.nvim_feedkeys("z", "n", false)
--     vim.api.nvim_set_current_win(win)
--   end
--
--   vim.cmd("Neotree show reveal")
-- end, { desc = 'Focus current file in NT' })
