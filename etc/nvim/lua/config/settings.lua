-- Global settings that can be interrogated for the purposes of, say, setting
-- up common keybindings that route to different LSP flavours

local lsp_flavour = "native"
local completion_flavour = "blink"

return {
  mac = (vim.loop.os_uname().sysname == "Darwin"),
  lsp = {
    flavour = lsp_flavour,
    coc = lsp_flavour == "coc",
    native = lsp_flavour == "native",

    completion = {
      flavour = completion_flavour,
      blink = completion_flavour == "blink",
      native = completion_flavour == "native",
    }
  },
  disable_auto_comment_filetypes = {
    "go",
    "lua",
  }
}
