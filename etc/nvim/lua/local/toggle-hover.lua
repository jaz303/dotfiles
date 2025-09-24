-- local/toggle-floating-docs.lua
--

local hover_win = nil

local function toggle_hover()
  if hover_win and vim.api.nvim_win_is_valid(hover_win) then
    vim.api.nvim_win_close(hover_win, true)
    hover_win = nil
    return
  end

  -- Otherwise, request a new hover
  vim.lsp.buf.hover()

  -- Defer to next tick to grab the newly created hover window
  vim.defer_fn(function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative ~= "" then
        hover_win = win
        break
      end
    end
  end, 10)
end

return toggle_hover
