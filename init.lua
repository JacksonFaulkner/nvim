-- General settings
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.tabstop = 2
vim.opt.swapfile = false
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.o.shell = "/bin/zsh"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.g.mapleader = " "

-- Shada settings for persistent history
vim.o.shada = "!,'10000,<10000,s100,h"
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("rshada")
  end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("wshada!")
  end,
})

-- JSON folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99
  end,
})

-- Terraform folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99
  end,
})

require("config.lazy")
require("config.keymaps")
