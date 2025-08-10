-- Disable plugin theme on macOS because the default terminal doesn't support
-- all the pretty colours.
if vim.loop.os_uname().sysname == "Darwin" then
  return
end

vim.pack.add({
  "https://github.com/folke/tokyonight.nvim.git"
})

-- Not sure if this is needed?
require('tokyonight')

vim.cmd.colorscheme('tokyonight-night')

--  
--return {
--  'folke/tokyonight.nvim',
--  lazy = false,
--  priority = 1000,
--  init = function()
--    -- Load the colorscheme here.
--    -- Like many other themes, this one has different styles, and you could load
--    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--    vim.cmd.colorscheme('tokyonight-night')
--
--    -- You can configure highlights by doing something like:
--    vim.cmd.hi('Comment gui=none')
--  end,
--  opts = {
--    transparent = true,
--    styles = {
--      sidebars = 'transparent',
--      floats = 'transparent',
--    },
--  },
--}
--
