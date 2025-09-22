-- Configuration for native LSP/completion stuff

-- If we're not using native LSP, do nothing
if not require("config.settings").lsp.native then
  return
end

vim.lsp.enable('lua_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('zls')
vim.lsp.enable('ts')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  --virtual_lines = {
  --  current_line = true
  --}
})
