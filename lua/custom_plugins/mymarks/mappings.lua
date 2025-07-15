-- ~/.config/nvim/lua/custom_plugins/mymarks/mappings.lua

local M = {}
local core = require("custom_plugins.mymarks.core")

-- Allowed characters for marks
local mark_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local valid_chars = {}
for i = 1, #mark_chars do
  table.insert(valid_chars, mark_chars:sub(i, i))
end

function M.setup()
  local map = vim.keymap.set
  for _, char in ipairs(valid_chars) do
    map("n", "<leader>k" .. char, function()
      if core.has_mark(char) then
        core.jump_to_mark(char)
      else
        core.set_mark(char)
      end
    end, { desc = "Jump or set mark '" .. char .. "'" })
  end
end

return M

