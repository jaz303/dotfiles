local ts = require('telescope.builtin')

-- Navigate visual lines
vim.keymap.set({ 'n', 'x' }, 'j', 'gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set({ 'n', 'x' }, 'k', 'gk', { desc = 'Navigate up (visual line)' })
vim.keymap.set({ 'n', 'x' }, '<Down>', 'gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set({ 'n', 'x' }, '<Up>', 'gk', { desc = 'Navigate up (visual line)' })
vim.keymap.set('i', '<Down>', '<C-\\><C-o>gj', { desc = 'Navigate down (visual line)' })
vim.keymap.set('i', '<Up>', '<C-\\><C-o>gk', { desc = 'Navigate up (visual line)' })

-- "C-backspace" - delete words
-- This is pretty non-standard but I can't shake the muscle memory...
-- According to some sources it's not compatible with all terminals but working
-- fine here on Alacritty/Linux.
vim.keymap.set('i', '<C-BS>', '<C-W>', { desc = 'Delete word' })

--
-- Move Lines Up/Down in normal/insert modes

vim.keymap.set({ 'n', 'x' }, '<M-S-Up>', ':move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set({ 'n', 'x' }, '<M-S-Down>', ':move +1<cr>', { desc = 'Move Line Down' })
vim.keymap.set('i', '<M-S-Up>', '<C-o>:move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set('i', '<M-S-Down>', '<C-o>:move +1<cr>', { desc = 'Move Line Down' })

--
-- Easier interaction with the system clipboard

vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard after the cursor position' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard before the cursor position' })

--
-- Use LSP

vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = 'Goto declaration', noremap = true, silent = true })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = 'Goto definition', noremap = true, silent = true })

--
-- Navigating buffers

vim.keymap.set('n', '<leader><leader>', ts.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader><BS>', '<C-^>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<leader>]', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>[', ':bprevious<cr>', { desc = 'Previous buffer' })

vim.keymap.set('n', '<leader>bb', '<C-^>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bt', ts.buffers, { desc = 'Telescope buffers' })

--
--

-- Ctrl-L redraws the screen by default. Now it will also toggle search highlighting.
vim.keymap.set('n', '<C-l>', ':set hlsearch!<cr><C-l>', { desc = 'Toggle search highlighting' })

-- Toggle visible whitespace characters
--vim.keymap.set('n', '<leader>l', ':listchars!<cr>', { desc = 'Toggle [l]istchars' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- A couple of VSCode bindings that by now are too far ingrained
vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', { desc = 'Rename' })
vim.keymap.set('n', '<F12>', '<cmd>lua vim.lsp.buf.definition()<cr>', { desc = 'Goto' })

--
-- Telescope stuff

vim.keymap.set('n', '<leader>ff', ts.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', ts.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fh', ts.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>ls', ts.lsp_document_symbols, { desc = 'Telescope document syms' })
vim.keymap.set('n', '<leader>lw', ts.lsp_workspace_symbols, { desc = 'Telescope workspace syms' })

--
-- Shunt

local shunt = require('local.shunt')

vim.keymap.set('n', '<leader>ss', shunt.push_selection, { desc = 'Shunt selection' })
vim.keymap.set('v', '<leader>ss', shunt.push_selection, { desc = 'Shunt selection' })
vim.keymap.set('n', '<leader>st', ':ShuntPushType<cr>', { desc = 'Shunt type' })
vim.keymap.set('n', '<leader>sh', ':ShuntHide<cr>', { desc = 'Hide shunt window' })
vim.keymap.set('v', '<leader>sh', '<cmd>ShuntHide<cr>', { desc = 'Hide shunt window' })
vim.keymap.set('n', '<leader>s<Enter>', ':ShuntToggle<cr>', { desc = 'Toggle shunt window' })
vim.keymap.set('v', '<leader>s<Enter>', '<cmd>ShuntToggle<cr>', { desc = 'Toggle shunt window' })
vim.keymap.set('n', '<leader>sc', ':ShuntClear<cr>', { desc = 'Clear shunt window' })
vim.keymap.set('v', '<leader>sc', '<cmd>ShuntClear<cr>', { desc = 'Clear shunt window' })

