local S = require("config.settings")

local Config = require("lazy.core.config")
local function has(plugin)
  return Config.plugins[plugin] ~= nil
end

local has_saga = has("lspsaga.nvim")

--
-- Use LSP

-- Goto declaration
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", {
  desc = 'Goto declaration', noremap = true, silent = true
})

-- Goto definition
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", {
  desc = 'Goto definition', noremap = true, silent = true
})

-- Completion trigger
-- If we're using native completion hook up <C-Space> to trigger
-- Other completion engines (coc, blink) are configured automatically.
if S.lsp.completion.native then
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client:supports_method('textDocument/completion') then
        vim.keymap.set('i', '<C-Space>', function()
          vim.lsp.completion.get()
        end)
      end
    end,
  })
end

--
-- Diagnostics

vim.keymap.set('n', '<leader>xx', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = "Floating diagnostics" })
vim.keymap.set('n', '<leader>xo', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', {
  desc = "Toggle Trouble buffer diagnostics"
})
vim.keymap.set('n', '<leader>xO', '<cmd>Trouble diagnostics toggle<cr>', { desc = "Toggle Trouble diagnostics" })

--
-- Other LSP stuff

vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false win.position=right<cr>", {
  desc = "Toggle symbols"
})

vim.keymap.set("n", "<leader>cS", "<cmd>Trouble symbols open focus=true win.position=right<cr>", {
  desc = "Toggle symbols & focus"
})

vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", {
  desc = "Toggle symbols"
})

-- close Trouble
vim.keymap.set("n", "<leader>cq", "<cmd>Trouble close<cr>", {
  desc = "Close Trouble window"
})

--
--

if has_saga then
  vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>')
  vim.keymap.set({ 'n', 'i' }, '<C-Enter>', '<cmd>Lspsaga code_action<cr>', { desc = 'Code action' })
else
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-Enter>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = 'Code action' })
end

vim.keymap.set('n', '<leader>,', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { desc = "Signature help" })
vim.keymap.set('n', '<leader>?', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = "Diagnostics" })
vim.keymap.set('n', '<leader>.s', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { desc = "Signature help" })

-- Toggle visible whitespace characters
--vim.keymap.set('n', '<leader>l', ':listchars!<cr>', { desc = 'Toggle [l]istchars' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- A couple of VSCode bindings that by now are too far ingrained
vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', { desc = 'Rename' })
vim.keymap.set('n', '<F12>', '<cmd>lua vim.lsp.buf.definition()<cr>', { desc = 'Goto' })
