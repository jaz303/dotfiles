-- Default colourscheme; will be overridden by some plugin
vim.cmd.colorscheme('sorbet')

require('config.globals')
require('config.options')
require('config.lsp')

require('plugins.deps')
require('plugins.theme')
require('plugins.nvim-treesitter')
require('plugins.telescope')
require('plugins.nvim-tree')
require('plugins.goto-preview')
require('plugins.which-key')

require('config.autocmd')
require('config.keymap')
