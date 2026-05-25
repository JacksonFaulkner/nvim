-- General settings
vim.loader.enable()
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
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.o.shell = "/bin/zsh"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.hidden = true
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

-- Indent-based folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "terraform" },
  callback = function()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99
  end,
})

require("config.tmux")

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft
    if not lang or lang == "" then return end
    if pcall(vim.treesitter.start, bufnr, lang) then
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

-- Workaround for Neovim 0.12.x crash: `(#set! conceal_lines "")` in the
-- runtime markdown highlights query feeds a nil node into vim.treesitter
-- .get_range -> node:range(true). Guard the nil case so the highlighter
-- doesn't abort. See neovim/neovim#39032, nvim-treesitter/nvim-treesitter#8618.
do
  local ts = vim.treesitter
  local orig_get_range = ts.get_range
  function ts.get_range(node, source, metadata)
    if type(node) == 'table' and node[1] ~= nil then
      node = node[1]
    end
    if node == nil or type(node) ~= 'userdata' then
      if metadata and metadata.range then
        return ts._range.add_bytes(assert(source), metadata.range)
      end
      return { 0, 0, 0, 0, 0, 0 }
    end
    return orig_get_range(node, source, metadata)
  end
end

require("config.lazy")
require("config.keymaps")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("custom_plugins.bufferline")
    require("custom_plugins.stay_centered")
  end,
})
