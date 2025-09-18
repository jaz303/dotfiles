-- zap.lua
-- Registers :Zap command to close all unmodified buffers without a window
-- Adapted from https://www.reddit.com/r/neovim/comments/158it1i/comment/jtccow6/

vim.api.nvim_create_user_command('Zap', function()
  local buffers = vim.fn.getbufinfo({ buflisted = true })
  vim.tbl_map(function(b)
    if b.changed == 0 and (not b.windows or #b.windows == 0) then
      print(('Deleting buffer %d : %s'):format(b.bufnr, b.name))
      vim.api.nvim_buf_delete(b.bufnr, { force = false, unload = false })
    end
  end, buffers)
end, { desc = 'Zap all buffers not shown in a window' })

