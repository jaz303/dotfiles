-- Autoformat on save via LSP
-- If no LSP, just strip trailing whitespace

-- does the buffer have an attached formatter?
local function has_formatter(buf)
  local clients = vim.lsp.get_clients({ bufnr = buf })
  for _, client in ipairs(clients) do
    if client.server_capabilities.documentFormattingProvider then
      return true
    end
  end
  return false
end

local group = vim.api.nvim_create_augroup("AutoFormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  callback = function(args)
    if has_formatter(args.buf) then
      vim.lsp.buf.format({ bufnr = args.buf })
    else
      local save = vim.fn.winsaveview()
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.winrestview(save)
    end
  end,
})
