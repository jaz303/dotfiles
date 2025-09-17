local ts = require('telescope.builtin')
local gs = require('gitsigns')

local map = function(mode, l, r, opts)
  vim.keymap.set(mode, l, r, opts or {})
end

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

-- Visual-mode indent without clearing selection
vim.keymap.set('v', '<C-.>', '>gv', { desc = 'Indent (retain selection)' })
vim.keymap.set('v', '<C-,>', '<gv', { desc = 'Dedent (retain selection)' })

-- C-/ to comment
-- TODO: fix these
vim.keymap.set('n', '<C-_>', 'gcc', { desc = 'Toggle linewise comment' })
vim.keymap.set('x', '<C-_>', 'gc', { desc = 'Toggle linewise comment' })

-- Treehopper
vim.keymap.set("o", "m", ":<C-U>lua require('tsht').nodes()<CR>", { silent = true })
vim.keymap.set("x", "m", ":lua require('tsht').nodes()<CR>", { silent = true })

-- Move Lines Up/Down in normal/insert modes
vim.keymap.set({ 'n', 'x' }, '<M-S-Up>', ':move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set({ 'n', 'x' }, '<M-S-Down>', ':move +1<cr>', { desc = 'Move Line Down' })
vim.keymap.set('i', '<M-S-Up>', '<C-o>:move -2<cr>', { desc = 'Move Line Up' })
vim.keymap.set('i', '<M-S-Down>', '<C-o>:move +1<cr>', { desc = 'Move Line Down' })

-- System clipboard shortcuts
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard after the cursor position' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard before the cursor position' })

--
-- Use LSP

vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>",
  { desc = 'Goto declaration', noremap = true, silent = true })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>",
  { desc = 'Goto definition', noremap = true, silent = true })
vim.keymap.set({ 'n', 'i' }, '<C-Enter>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = 'Code action' })

vim.keymap.set('n', '<leader>,', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { desc = "Signature help" })
vim.keymap.set('n', '<leader>?', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = "Diagnostics" })
vim.keymap.set('n', '<leader>.s', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { desc = "Signature help" })
vim.keymap.set('n', '<leader>.d', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = "Diagnostics" })

--
-- Navigating buffers

-- Shortcuts
vim.keymap.set('n', '<leader><leader>', ts.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader><BS>', '<C-^>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<leader>]', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>[', ':bprevious<cr>', { desc = 'Previous buffer' })

-- Discoverable versions
vim.keymap.set('n', '<leader>bt', ts.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>bb', '<C-^>', { desc = 'Alternate buffer' })
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>', { desc = 'Previous buffer' })

--
--

-- Augment <C-l> to turn off search highlighting
vim.keymap.set('n', '<C-l>', ':nohl<cr><C-l>', { desc = 'Cancel search highlighting' })

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
vim.keymap.set('n', '<C-p>', ts.find_files, { desc = 'Telescope find files' })
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

--
-- Git

map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, { desc = 'Popup blame line' })
map('n', '<leader>gt', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
map('n', '<leader>gw', gs.toggle_word_diff, { desc = 'Toggle word diff' })
map('n', '<leader>gd', gs.diffthis, { desc = 'Diff this' })
map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = 'Diff this (~)' })
map('n', '<leader>gsb', gs.stage_buffer, { desc = 'Stage buffer' })
map('n', '<leader>gsh', gs.stage_hunk, { desc = 'Stage hunk' })
map('n', '<leader>gsB', gs.reset_buffer, { desc = 'Reset buffer' })
map('n', '<leader>gsH', gs.reset_hunk, { desc = 'Reset hunk' })

-- map('v', '<C-u>', '<esc>gUawgi', { desc = 'Uppercase word' })
