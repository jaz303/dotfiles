-- Default colourscheme; will be overridden by some plugin
-- This is just here so we get something acceptable in macOS terminal,
-- which doesn't support exotic colourschemes.
vim.cmd.colorscheme('sorbet')

require('config.globals')
require('config.options')
require('config.lsp')

require('local.wm')

require('plugins.deps')
require('plugins.theme')
require('plugins.nvim-treesitter')
require('plugins.telescope')
require('plugins.neotree')
require('plugins.which-key')
require('plugins.lualine')
require('plugins.scrollbar')

require('config.autocmd')
require('config.keymap')

-- Launch a floating terminal with the given working directory
function LaunchFloatingTerminalInDir(dir, cmd)
  local exec = "exec alacritty --class floating_term -o 'window.dimensions.columns=150' -o 'window.dimensions.lines=35' --working-directory '" .. dir .. "'"

  if cmd then
    exec = exec .. " -e '" .. cmd .. "'"
  end

  vim.fn.system({"i3-msg", exec})
end

-- Launch a floating terminal in the workspace dir
function LaunchFloatingTerminalInWorkspaceDir()
  LaunchFloatingTerminalInDir(vim.fn.getcwd())
end

-- Launch a floating terminal in the file dir
function LaunchFloatingTerminalInFileDir()
  local file_path = vim.api.nvim_buf_get_name(0)
  LaunchFloatingTerminalInDir(vim.fs.dirname(file_path))
end

function LaunchFloatingGitClient()
  LaunchFloatingTerminalInDir(vim.fn.getcwd(), "lazygit")
end

vim.api.nvim_create_user_command('LaunchFloatingTerminalWS', LaunchFloatingTerminalInWorkspaceDir, {desc = 'Launch workspace terminal'})
vim.api.nvim_create_user_command('LaunchFloatingTerminalF', LaunchFloatingTerminalInFileDir, {desc = 'Launch file terminal'})
vim.api.nvim_create_user_command('LaunchGitClient', LaunchFloatingGitClient, {desc = 'Launch Lazygit'})

vim.keymap.set('n', '<M-Enter>', ':LaunchFloatingTerminalWS<cr>', { desc = 'Launch workspace terminal' })
vim.keymap.set('n', '<M-S-Enter>', ':LaunchFloatingTerminalF<cr>', { desc = 'Launch file terminal' })
vim.keymap.set('n', '<leader>g', ':LaunchGitClient<cr>', { desc = 'Launch git client' })

vim.keymap.set('n', '<M-0>', ':Neotree<cr>', { desc = 'Switch to Neotree' })

for n = 1,4 do
  vim.keymap.set('n', '<M-' .. n .. '>', ':SwitchToNthWindow ' .. n .. '<cr>', { desc = 'Switch to window ' .. n })
  vim.keymap.set('n', '<M-S-' .. n .. '>', ':MoveActiveBufferToNthWindow ' .. n .. '<cr>', { desc = 'Move active buffer to window ' .. n })
  vim.keymap.set('n', '<M-C-' .. n .. '>', ':SwapActiveBufferWithNthWindow ' .. n .. '<cr>', { desc = 'Swap active buffer with window ' .. n })
end

vim.keymap.set('n', '<M-Left>', ':SwitchToRelWindow -1<cr>', { desc = 'Switch window left' })
vim.keymap.set('n', '<M-Right>', ':SwitchToRelWindow 1<cr>', { desc = 'Switch window right' })

vim.keymap.set('n', '<M-=>', ':EqualizeWindows<cr>', { desc = 'Equalize windows' })
vim.keymap.set('n', '<M-S-=>', ':FocusActiveWindow<cr>', { desc = 'Focus active window' })

