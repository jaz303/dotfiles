-- Global settings that can be interrogated for the purposes of, say, setting
-- up common keybindings that route to different LSP flavours

local lsp_flavour = "coc"

return {
  lsp = {
    flavour = lsp_flavour,
    coc = lsp_flavour == "coc",
    native = lsp_flavour == "native"
  },
}

