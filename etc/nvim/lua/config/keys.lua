-- keys.lua
-- I prefer to define all my keybinds in a single file rather than spreading
-- them across a bunch of plugin config files. Hence, the checks for plugins.

local set = function(mode, l, r, opts)
  vim.keymap.set(mode, l, r, opts or {})
end

local Config = require("lazy.core.config")
local function has(plugin)
  return Config.plugins[plugin] ~= nil
end

local settings = require("config.settings")

local has_gitsigns = has("gitsigns.nvim")
local has_telescope = has("telescope.nvim")
local has_neotree = has("neo-tree.nvim")
local has_treehopper = has("nvim-treehopper")

-- Augment <C-l> to turn off search highlighting
set('n', '<C-l>', ':nohl<cr><C-l>', { desc = 'Cancel search highlighting' })

-- Navigate visual lines
set({ 'n', 'x' }, 'j', 'gj', { desc = 'Navigate down (visual line)' })
set({ 'n', 'x' }, 'k', 'gk', { desc = 'Navigate up (visual line)' })
set({ 'n', 'x' }, '<Down>', 'gj', { desc = 'Navigate down (visual line)' })
set({ 'n', 'x' }, '<Up>', 'gk', { desc = 'Navigate up (visual line)' })
set('i', '<Down>', '<C-\\><C-o>gj', { desc = 'Navigate down (visual line)' })
set('i', '<Up>', '<C-\\><C-o>gk', { desc = 'Navigate up (visual line)' })

-- "C-backspace" - delete words
-- This is pretty non-standard but I can't shake the muscle memory...
-- According to some sources it's not compatible with all terminals but working
-- fine here on Alacritty/Linux.
set('i', '<C-BS>', '<C-W>', { desc = 'Delete word' })

-- Visual-mode indent without clearing selection
set('v', '<C-.>', '>gv', { desc = 'Indent (retain selection)' })
set('v', '<C-,>', '<gv', { desc = 'Dedent (retain selection)' })

-- C-/ to comment
-- TODO: fix these
set('n', '<C-_>', 'gcc', { desc = 'Toggle linewise comment' })
set('x', '<C-_>', 'gc', { desc = 'Toggle linewise comment' })

-- Move Lines Up/Down in normal/insert modes
set({ 'n', 'x' }, '<M-S-Up>', ':move -2<cr>', { desc = 'Move Line Up' })
set({ 'n', 'x' }, '<M-S-Down>', ':move +1<cr>', { desc = 'Move Line Down' })
set('i', '<M-S-Up>', '<C-o>:move -2<cr>', { desc = 'Move Line Up' })
set('i', '<M-S-Down>', '<C-o>:move +1<cr>', { desc = 'Move Line Down' })

-- System clipboard shortcuts
set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard after the cursor position' })
set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard before the cursor position' })

--
-- Telescope builtins
-- (see also "Buffer navigation")

if has_telescope then
  local ts = require("telescope.builtin")
  set('n', '<leader>ff', ts.find_files, { desc = 'Telescope find files' })
  set('n', '<C-p>', ts.find_files, { desc = 'Telescope find files' })
  set('n', '<leader>fg', ts.live_grep, { desc = 'Telescope live grep' })
  set('n', '<leader>fh', ts.help_tags, { desc = 'Telescope help tags' })
  -- TODO: only enable these if using native LSP
  -- vim.keymap.set('n', '<leader>ls', ts.lsp_document_symbols, { desc = 'Telescope document syms' })
  -- vim.keymap.set('n', '<leader>lw', ts.lsp_workspace_symbols, { desc = 'Telescope workspace syms' })
end

--
-- Buffer navigation

-- Quick
if has_telescope then
  local ts = require("telescope.builtin")
  set('n', '<leader><leader>', ts.buffers, { desc = 'Telescope buffers' })
end
set('n', '<leader><BS>', '<C-^>', { desc = 'Alternate buffer' })
set('n', '<leader>]', ':bnext<cr>', { desc = 'Next buffer' })
set('n', '<leader>[', ':bprevious<cr>', { desc = 'Previous buffer' })

-- which-key discoverable versions
if has_telescope then
  local ts = require("telescope.builtin")
  set('n', '<leader>bt', ts.buffers, { desc = 'Telescope buffers' })
end
set('n', '<leader>bb', '<C-^>', { desc = 'Alternate buffer' })
set('n', '<leader>bn', ':bnext<cr>', { desc = 'Next buffer' })
set('n', '<leader>bp', ':bprevious<cr>', { desc = 'Previous buffer' })

--
-- Gitsigns

if has_gitsigns then
  local gs = require("gitsigns")
  set('n', '<leader>gb', function() gs.blame_line({ full = true }) end, { desc = 'Popup blame line' })
  set('n', '<leader>gt', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
  set('n', '<leader>gw', gs.toggle_word_diff, { desc = 'Toggle word diff' })
  set('n', '<leader>gd', gs.diffthis, { desc = 'Diff this' })
  set('n', '<leader>gD', function() gs.diffthis('~') end, { desc = 'Diff this (~)' })
  set('n', '<leader>gsb', gs.stage_buffer, { desc = 'Stage buffer' })
  set('n', '<leader>gsh', gs.stage_hunk, { desc = 'Stage hunk' })
  set('n', '<leader>gsB', gs.reset_buffer, { desc = 'Reset buffer' })
  set('n', '<leader>gsH', gs.reset_hunk, { desc = 'Reset hunk' })
end

--
-- Treehopper
-- Use "m" in operator-pending mode to activate

if has_treehopper then
  set("o", "m", ":<C-U>lua require('tsht').nodes()<CR>", { silent = true })
  set("x", "m", ":lua require('tsht').nodes()<CR>", { silent = true })
end

--
-- Shunt

-- This is a work in progress
-- local shunt = require('local.shunt')
-- vim.keymap.set('n', '<leader>ss', shunt.push_selection, { desc = 'Shunt selection' })
-- vim.keymap.set('v', '<leader>ss', shunt.push_selection, { desc = 'Shunt selection' })
-- vim.keymap.set('n', '<leader>st', ':ShuntPushType<cr>', { desc = 'Shunt type' })
-- vim.keymap.set('n', '<leader>sh', ':ShuntHide<cr>', { desc = 'Hide shunt window' })
-- vim.keymap.set('v', '<leader>sh', '<cmd>ShuntHide<cr>', { desc = 'Hide shunt window' })
-- vim.keymap.set('n', '<leader>s<Enter>', ':ShuntToggle<cr>', { desc = 'Toggle shunt window' })
-- vim.keymap.set('v', '<leader>s<Enter>', '<cmd>ShuntToggle<cr>', { desc = 'Toggle shunt window' })
-- vim.keymap.set('n', '<leader>sc', ':ShuntClear<cr>', { desc = 'Clear shunt window' })
-- vim.keymap.set('v', '<leader>sc', '<cmd>ShuntClear<cr>', { desc = 'Clear shunt window' })

--
-- Neotree

if has_neotree then
  set('n', '<M-0>', ':Neotree<cr>', { desc = 'Switch to Neotree' })
  set('n', '<M-S-0>', ':Neotree action=show toggle<cr>', { desc = 'Toggle Neotree' })
  set('n', '\\', ':Neotree show reveal<CR>', { desc = 'Reveal current file in NT' })
  set('n', '|', ':NTShrink<CR>', { desc = 'Shrink Neotree' })
  set('n', '<leader>fr', ':Neotree show reveal<CR>', { desc = 'Reveal current file in NT' })
end

--
-- External tools

set('n', '<M-Enter>', ':LaunchFloatingTerminalWS<cr>', { desc = 'Launch workspace terminal' })
set('n', '<M-S-Enter>', ':LaunchFloatingTerminalF<cr>', { desc = 'Launch file terminal' })
set('n', '<leader>gg', ':LaunchGitClient<cr>', { desc = 'Git client' })

--
-- Window manager

for n = 1, 8 do
  set('n', '<M-' .. n .. '>', ':SwitchToNthWindow ' .. n .. '<cr>', { desc = 'Switch to window ' .. n })
  set('n', '<M-S-' .. n .. '>', ':MoveActiveBufferToNthWindow ' .. n .. '<cr>',
    { desc = 'Move active buffer to window ' .. n })
  set('n', '<M-C-' .. n .. '>', ':SwapActiveBufferWithNthWindow ' .. n .. '<cr>',
    { desc = 'Swap active buffer with window ' .. n })
end

set('n', '<M-Left>', ':SwitchToRelWindow -1<cr>', { desc = 'Switch window left' })
set('n', '<M-Right>', ':SwitchToRelWindow 1<cr>', { desc = 'Switch window right' })

set('n', '<M-=>', ':EqualizeWindows<cr>', { desc = 'Equalize windows' })
set('n', '<M-S-=>', ':FocusActiveWindow<cr>', { desc = 'Focus active window' })

-- 
-- LSP

if settings.lsp.coc then
  require("config.keys.coc")
elseif settings.lsp.native then
  require("config.keys.native_lsp")
end
