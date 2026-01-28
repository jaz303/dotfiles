-- :Y  — Yank range to system clipboard
vim.api.nvim_create_user_command(
  'Y',
  function(opts)
    local range = opts.line1 .. ',' .. opts.line2
    vim.cmd(range .. 'y +')
  end,
  { range = true }
)

-- -- :P  — Paste system clipboard into range (replaces that range)
-- vim.api.nvim_create_user_command(
--   'P',
--   function(opts)
--     local range = opts.line1 .. ',' .. opts.line2
--     vim.cmd(range .. 'delete _') -- delete range without affecting registers
--     vim.cmd('put +')             -- paste clipboard after current line
--     -- ’put’ puts *after* the cursor line, so adjust cursor to line before range
--     vim.cmd(opts.line1 .. 'normal! k')
--   end,
--   { range = true }
-- )
