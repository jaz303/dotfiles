-- Highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- LSP format-on-save for specified file types
-- TODO: there might be a more idiomatic way to achieve this
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    local filetype = vim.bo.filetype
    local should_format = (filetype == "zig") or (filetype == "go")
    if should_format and vim.bo.modified and mode == "n" then
      vim.cmd("lua vim.lsp.buf.format()")
    end
  end
})

