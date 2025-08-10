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
require('plugins.goto-preview')
require('plugins.which-key')
require('plugins.lualine')

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

vim.keymap.set('n', '<M-1>', ':SwitchToNthWindow 1<cr>', { desc = 'Switch to window 1' })
vim.keymap.set('n', '<M-2>', ':SwitchToNthWindow 2<cr>', { desc = 'Switch to window 2' })
vim.keymap.set('n', '<M-3>', ':SwitchToNthWindow 3<cr>', { desc = 'Switch to window 3' })
vim.keymap.set('n', '<M-4>', ':SwitchToNthWindow 4<cr>', { desc = 'Switch to window 4' })

vim.keymap.set('n', '<M-S-1>', ':MoveActiveBufferToNthWindow 1<cr>', { desc = 'Move active buffer to window 1' })
vim.keymap.set('n', '<M-S-2>', ':MoveActiveBufferToNthWindow 2<cr>', { desc = 'Move active buffer to window 2' })
vim.keymap.set('n', '<M-S-3>', ':MoveActiveBufferToNthWindow 3<cr>', { desc = 'Move active buffer to window 3' })
vim.keymap.set('n', '<M-S-4>', ':MoveActiveBufferToNthWindow 4<cr>', { desc = 'Move active buffer to window 4' })

