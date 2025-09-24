local settings = require("config.settings")

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    cond = settings.lsp.native,
    dependencies = {
      "rafamadriz/friendly-snippets"
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default'
      },

      appearance = {
        nerd_font_variant = 'mono'
      },

      signature = {
        enabled = true,
        trigger = {
          -- show automatically
          enabled = true,
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  }
}
