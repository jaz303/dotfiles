-- Lazy
require("config.lazy")

-- Tabstop stuff
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- Line numbers
vim.cmd("set number relativenumber")
vim.cmd("set cursorline")

-- Theme
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Buffer navigation
vim.keymap.set('n', '<C-h>', '<C-w><left>')
vim.keymap.set('n', '<C-l>', '<C-w><right>')
vim.keymap.set('n', '<C-k>', '<C-w><up>')
vim.keymap.set('n', '<C-j>', '<C-w><down>')

-- Invert relative line number
vim.keymap.set('n', '<C-n><C-n>', function() vim.cmd("set invrelativenumber") end, { desc = 'Invert relative numbering' })

-- Neotree
vim.keymap.set('n', '<C-enter>', ':Neotree show filesystem toggle left<CR>')
vim.keymap.set('n', '<C-f>', ':Neotree focus filesystem left<CR>')
vim.keymap.set('n', '<C-b>', ':Neotree focus buffers float<CR>')

