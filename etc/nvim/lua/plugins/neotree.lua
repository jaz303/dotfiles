vim.pack.add({
  { src = "https://github.com/jaz303/neo-tree.nvim", version = "ea7bdfc" }
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
  local desc = "open in window 1 (also 2..8)"
  if n > 1 then
    desc = "<hidden>"
  end
  mappings["" .. n] = {
    function(state) open_in_split(n, state) end,
    desc = desc,
  }
end

require("neo-tree").setup({
  filesystem = {
    window = {
      mappings = mappings,
    },
  },
})
