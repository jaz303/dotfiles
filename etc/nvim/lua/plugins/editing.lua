return {
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end
  },
  {
    "mfussenegger/nvim-treehopper",
    branch = "master"
  },
  {
    "windwp/nvim-autopairs",
    branch = "master",
    event = "InsertEnter",
    config = true,
    opts = {
      -- use this function to control whether the autopairs is enabled for the
      -- given buffer.
      enabled = function(bufnr)
        return true
      end,
    }
  },
}
