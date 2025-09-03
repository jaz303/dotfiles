require('snacks').setup({
  indent = {
    enabled = true,
    indent = {
      -- i would prefer this to be left-aligned but that variant (U+23B8) is
      -- not full-height in my font. bah.
      -- char = "⎸",
      char = "│",
    },
    animate = {
      enabled = false,
    },
    scope = {
      enabled = false,
    },
  }
})
