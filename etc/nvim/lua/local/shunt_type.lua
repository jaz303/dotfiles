local M = {}

-- Per-filetype type range resolvers.
-- Each entry is function(location, callback) where:
--   location = LSP Location { uri, range }
--   callback = function(err, entry) where entry = { source, lang, lines }
-- Add entries here to override the default LSP-range behaviour per filetype.
M.resolvers = {}

M.default = function(location, callback)
  local path = vim.uri_to_fname(location.uri)
  local start_line = location.range.start.line
  local end_line = location.range["end"].line

  local all_lines = vim.fn.readfile(path)
  if not all_lines or #all_lines == 0 then
    callback("Could not read: " .. path)
    return
  end

  local content = vim.list_slice(all_lines, start_line + 1, end_line + 1)
  local ft = vim.filetype.match({ filename = path }) or nil
  callback(nil, { source = path, lang = ft, lines = content })
end

M.resolve = function(location, filetype, callback)
  local resolver = M.resolvers[filetype] or M.default
  resolver(location, callback)
end

return M
