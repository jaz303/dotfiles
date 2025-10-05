local M = {}
local buf = nil
local win = nil

local function error(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function get_buffer()
  if not buf then
    buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true
    vim.api.nvim_buf_set_name(buf, '~shunt~')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'rtb-shunt')
  end
  return buf
end

local function open_window()
  vim.cmd("vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = get_buffer()
  vim.api.nvim_win_set_buf(win, buf)
end

local commands = {
  type = function(opts)
    local params = vim.lsp.util.make_position_params(0, "utf-8")
    local search_buf = vim.api.nvim_get_current_buf()


    open_window()
    local buf = get_buffer()

    vim.lsp.buf_request_all(search_buf, "textDocument/typeDefinition", params, function(results)
      -- results is a map: client_id -> { err? | error?, result? }
      for client_id, res in pairs(results or {}) do
        local err = res.err or res.error
        if err then
          vim.notify(("LSP %d error: %s"):format(client_id, vim.inspect(err)), vim.log.levels.WARN)
        else
          local r = res.result
          if r and not vim.tbl_isempty(r) then
            -- r may be a single Location or an array; take the first item if it's a list
            local loc = (vim.tbl_islist(r) and r[1]) or r
            -- schedule UI actions to be safe
            print(vim.inspect(r))
            return
          end
        end
      end
      vim.notify("No type definition found", vim.log.levels.INFO)
    end)
  end
}

vim.api.nvim_create_user_command('Shunt', function(opts)
  local fn = commands[opts.args]
  if fn ~= nil then
    fn(opts)
  else
    error("Shunt: unknown command")
  end
end, {
  desc = "Shunt",
  nargs = 1,
})

return M
