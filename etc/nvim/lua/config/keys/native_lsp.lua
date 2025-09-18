
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


-- Toggle visible whitespace characters
--vim.keymap.set('n', '<leader>l', ':listchars!<cr>', { desc = 'Toggle [l]istchars' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- A couple of VSCode bindings that by now are too far ingrained
vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', { desc = 'Rename' })
vim.keymap.set('n', '<F12>', '<cmd>lua vim.lsp.buf.definition()<cr>', { desc = 'Goto' })

