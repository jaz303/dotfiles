local S = require("config.settings")

--
-- vim.g

-- Set <space> as leader key
-- NOTE: Must happen before loading plugins.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if S.mac then
  vim.g.clipboard = 'pbcopy'
else
  vim.g.clipboard = 'xclip'
end

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

--
-- vim.opt

-- Relative and absolute line numbers combined
vim.opt.number = true
vim.opt.relativenumber = true

-- No scroll offset
-- vim.opt.scrolloff = 0

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Cursorline
vim.opt.cursorline = true

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions
vim.opt.inccommand = 'split'

-- Text wrapping
vim.opt.wrap = false
vim.opt.breakindent = true

-- Tabstops
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Window splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Save undo history
vim.opt.undofile = true

-- Only default to rounded borders if we're not using CoC; something in
-- that plugin gets completely messed up if this is enabled.
if not S.lsp.coc then
  vim.opt.winborder = 'rounded'
end

-- Disable backups to avoid confusing LSPs
vim.opt.backup = false
vim.opt.writebackup = false
