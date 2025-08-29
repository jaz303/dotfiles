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

local mappings = {}
for n = 1, 8 do
  mappings["" .. n] = {
    function(state) open_in_split(n, state) end,
    desc = "Open in window " .. n,
  }
end

require("neo-tree").setup({
  filesystem = {
    window = {
      mappings = mappings,
    },
  },
})
