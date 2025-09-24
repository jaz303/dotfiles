-- local/disable-auto-comment.lua
-- Disable automatic comment continuation on <CR>, o, O for the specified
-- file typs.

local S = require("config.settings")

vim.api.nvim_create_autocmd("FileType", {
  pattern = S.disable_auto_comment_filetypes,
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})
