-- ~/.config/nvim/lua/custom_plugins/mymarks/init.lua

local M = {}

function M.setup()
  require("custom_plugins.mymarks.core").setup()
  require("custom_plugins.mymarks.mappings").setup()
end

return M

