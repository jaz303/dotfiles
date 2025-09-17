local ts = require('telescope.builtin')
local gs = require('gitsigns')

local map = function(mode, l, r, opts)
  vim.keymap.set(mode, l, r, opts or {})
end

