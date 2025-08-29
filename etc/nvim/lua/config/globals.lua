-- Set <space> as leader key
-- NOTE: Must happen before loading plugins.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if vim.loop.os_uname().sysname == "Darwin" then
  vim.g.clipboard = 'pbcopy'
else
  vim.g.clipboard = 'xclip'
end

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
