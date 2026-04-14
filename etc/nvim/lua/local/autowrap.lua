-- Automatically enable/disable wrapping based on file-type
-- Apparently wrapping is a window-local setting, not buffer, so ftplugin
-- is not the best place to do it. Instead, reset the behaviour on each
-- BufWinEnter event.

local wrap_fts = {
  markdown = true,
  text = true,
  gitcommit = true,
  mail = true,
  org = true,
}

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(args)
    local wrap = wrap_fts[vim.bo[args.buf].filetype] == true
    -- vim.opt_local acts on the current window
    vim.opt_local.wrap = wrap
    vim.opt_local.linebreak = wrap
  end,
})
