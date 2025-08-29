vim.pack.add({
  "https://github.com/nvim-neo-tree/neo-tree.nvim"
})

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

require("neo-tree").setup({
  filesystem = {
    window = {
      mappings = {
        ["1"] = {
          function(state) open_in_split(1, state) end,
          desc = "Open in window 1",
        },
        ["2"] = {
          function(state) open_in_split(2, state) end,
          desc = "Open in window 2",
        },
        ["3"] = {
          function(state) open_in_split(3, state) end,
          desc = "Open in window 3",
        },
        ["4"] = {
          function(state) open_in_split(4, state) end,
          desc = "Open in window 4",
        },
      },
    },
  },
})

