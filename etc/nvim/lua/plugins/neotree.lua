local mappings = {}

--
-- Key map for opening files directly into splits

local wm = require('local.wm')

local function open_in_split(n, state)
  local node = state.tree:get_node()
  if not node then return end

  local path = vim.fn.fnamemodify(node:get_id(), ":p")

  -- if the target window does not exist, just open a new one at the
  -- rightmost position.
  local win = wm.GetCandidateWindows()[n]
  if not win then
    local current_win = vim.api.nvim_get_current_win()
    vim.cmd("vsplit " .. vim.fn.fnameescape(path))
    vim.cmd("wincmd L")
    vim.api.nvim_set_current_win(current_win)
  else
    local new_buf = vim.fn.bufnr(path, true)
    vim.fn.bufload(new_buf)
    vim.api.nvim_win_set_buf(win.id, new_buf)
  end
end

for n = 1, 8 do
  local desc = "open in window 1 (also 2..8)"
  if n > 1 then
    desc = "<hidden>"
  end
  mappings["" .. n] = {
    function(state) open_in_split(n, state) end,
    desc = desc,
  }
end

--
-- Copy path to register or clipboard
-- Adapted from https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370

local function copy_path(state, reg, desc)
  -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
  -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
  local node = state.tree:get_node()
  local filepath = node:get_id()
  local filename = node.name
  local modify = vim.fn.fnamemodify

  local results = {
    filepath,
    modify(filepath, ":."),
    modify(filepath, ":~"),
    filename,
    modify(filename, ":r"),
    modify(filename, ":e"),
  }

  vim.ui.select({
    "1. Absolute path: " .. results[1],
    "2. Path relative to CWD: " .. results[2],
    "3. Path relative to HOME: " .. results[3],
    "4. Filename: " .. results[4],
    "5. Filename without extension: " .. results[5],
    "6. Extension of the filename: " .. results[6],
  }, { prompt = "Choose to copy to " .. desc .. ":" }, function(choice)
    if choice then
      local i = tonumber(choice:sub(1, 1))
      if i then
        local result = results[i]
        vim.fn.setreg(reg, result)
      else
        vim.notify("Invalid choice")
      end
    else
      vim.notify("Cancelled")
    end
  end)
end

mappings["y"] = {
  function(state)
    copy_path(state, '"', 'register')
  end,
  desc = "Copy path to register"
}

mappings["Y"] = {
  function(state)
    copy_path(state, '+', 'clipboard')
  end,
  desc = "Copy path to clipboard"
}

return {
  {
    -- my fork of neo-tree allows keybindings to be hidden by setting
    -- the desc to "<hidden>"
    "jaz303/neo-tree.nvim",
    commit = "ea7bdfc",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "antosha417/nvim-lsp-file-operations"
    },
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      filesystem = {
        window = {
          mappings = mappings,
        },
        filtered_items = {
          always_show = {
            ".github",
          }
        }
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      require("plugins.neotree.shrink")
    end
  },
}
