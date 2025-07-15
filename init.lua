-- Simple .env loader for OPENAI_API_KEY from Neovim config directory
local env_file = vim.fn.expand("~/.config/nvim/.env")
local file = io.open(env_file, "r")
if file then
  for line in file:lines() do
    local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
    if key == "OPENAI_API_KEY" then
      vim.env.OPENAI_API_KEY = value
    end
  end
  file:close()
end

-- General settings
-- Disable netrw completely for Oil.nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.tabstop = 4                                    -- Number of spaces for a tab
vim.opt.swapfile = false                               -- Disable swap file
vim.opt.shiftwidth = 4                                 -- Number of spaces to indent
vim.opt.expandtab = true                               -- Convert tabs to spaces
vim.opt.smartindent = true                             -- Enable smart indentation
vim.opt.wrap = false                                   -- Disable line wrapping
vim.opt.backup = false                                 -- Disable backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Undo history
vim.opt.undofile = true
vim.opt.hlsearch = false                               -- Disable search highlight
vim.opt.incsearch = true                               -- Incremental search
vim.opt.termguicolors = true                           -- Enable 24-bit RGB colors
vim.o.shell = "/bin/zsh"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
-- Leader key setup
vim.g.mapleader = " " -- Set space as the leader key

-- Shada settings for persistent history
vim.o.shada = "!,'10000,<10000,s100,h"  -- Significantly increased limits
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("rshada")  -- Read shada on start
  end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("wshada!")  -- Write shada on exit with force
  end,
})

vim.cmd [[
  highlight Normal guibg=NONE
  highlight NonText guibg=NONE
]]

require("config.lazy")
require("config.keymaps")
require("lsp.mason")
require("lint.lint")  -- Load our custom linting module
require("oil").setup({})
require("smear_cursor").setup({
  stiffness = 0.5,
  trailing_stiffness = 0.5,
  never_draw_over_target = true,
})

vim.cmd [[colorscheme melange]]
