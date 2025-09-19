local settings = require("config.settings")

return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    cond = settings.lsp.coc
  }
}
