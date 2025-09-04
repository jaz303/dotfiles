-- Default colourscheme; will be overridden by some plugin
-- This is just here so we get something acceptable in macOS terminal,
-- which doesn't support exotic colourschemes.
vim.cmd.colorscheme('sorbet')

require('config.globals')
require('config.options')
require('config.lsp')

require('local.wm')
require('local.shunt')
require('local.autoformat')
require('local.nt-shrink')
require('local.highlight-yank')
require('local.zap')
require('local.os')

require('plugins.packs')
require('plugins.theme')
require('plugins.nvim-treesitter')
require('plugins.telescope')
require('plugins.neotree')
require('plugins.which-key')
require('plugins.lualine')
require('plugins.scrollbar')
require('plugins.treehopper')
require('plugins.gitsigns')
require('plugins.surround')
require('plugins.snacks')
-- require('plugins.harpoon')

require('config.keymap')

local os = require('local.os')

function LaunchTerminalInWorkspaceDir()
  os.LaunchTerminalInDir(vim.fn.getcwd())
end

function LaunchTerminalInFileDir()
  local file_path = vim.api.nvim_buf_get_name(0)
  os.LaunchTerminalInDir(vim.fs.dirname(file_path))
end

vim.api.nvim_create_user_command('LaunchFloatingTerminalWS', LaunchTerminalInWorkspaceDir,
  { desc = 'Launch workspace terminal' })
vim.api.nvim_create_user_command('LaunchFloatingTerminalF', LaunchTerminalInFileDir,
  { desc = 'Launch file terminal' })
vim.api.nvim_create_user_command('LaunchGitClient', os.LaunchGitClient, { desc = 'Launch Lazygit' })

vim.keymap.set('n', '<M-Enter>', ':LaunchFloatingTerminalWS<cr>', { desc = 'Launch workspace terminal' })
vim.keymap.set('n', '<M-S-Enter>', ':LaunchFloatingTerminalF<cr>', { desc = 'Launch file terminal' })
vim.keymap.set('n', '<leader>gg', ':LaunchGitClient<cr>', { desc = 'lazygit' })

vim.keymap.set('n', '<M-0>', ':Neotree<cr>', { desc = 'Switch to Neotree' })
vim.keymap.set('n', '<M-S-0>', ':Neotree action=show toggle<cr>', { desc = 'Toggle Neotree' })

for n = 1, 8 do
  vim.keymap.set('n', '<M-' .. n .. '>', ':SwitchToNthWindow ' .. n .. '<cr>', { desc = 'Switch to window ' .. n })
  vim.keymap.set('n', '<M-S-' .. n .. '>', ':MoveActiveBufferToNthWindow ' .. n .. '<cr>',
    { desc = 'Move active buffer to window ' .. n })
  vim.keymap.set('n', '<M-C-' .. n .. '>', ':SwapActiveBufferWithNthWindow ' .. n .. '<cr>',
    { desc = 'Swap active buffer with window ' .. n })
end

vim.keymap.set('n', '<M-Left>', ':SwitchToRelWindow -1<cr>', { desc = 'Switch window left' })
vim.keymap.set('n', '<M-Right>', ':SwitchToRelWindow 1<cr>', { desc = 'Switch window right' })

vim.keymap.set('n', '<M-=>', ':EqualizeWindows<cr>', { desc = 'Equalize windows' })
vim.keymap.set('n', '<M-S-=>', ':FocusActiveWindow<cr>', { desc = 'Focus active window' })
