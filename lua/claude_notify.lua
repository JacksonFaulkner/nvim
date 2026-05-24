local M = {}

function M.done()
  local msg = "Claude response ready ⚡"
  vim.schedule(function()
    vim.notify(msg, vim.log.levels.INFO, { title = "Claude Code" })
  end)
  return ""
end

return M
