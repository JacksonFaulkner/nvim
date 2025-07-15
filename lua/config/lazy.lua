-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader key setup
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim (single setup call)
require("lazy").setup({
  spec = {
    -- Import other plugins from `plugins/` directory
    { import = "plugins" },

    -- Melange color scheme
    {
      "savq/melange-nvim",
      lazy = false,
      priority = 1000,
    },

    -- Lazygit setup
    {
      "kdheepak/lazygit.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Marks enhancement
    {
      "chentoast/marks.nvim",
      event = "VeryLazy",
      opts = {},
    },

    -- Treesitter setup
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "lua",
            "vim",
            "python",
            "javascript",
            "typescript",
            "json",
            "markdown",
          },
          highlight = {
            enable = true,
          },
          indent = {
            enable = true,
          },
          auto_install = true,
        })
      end,
    },

    -- Mason setup
    {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
  },

  -- Default colorscheme to load
  install = { colorscheme = { "melange" } },

  -- Automatically check for updates
  checker = { enabled = true },
})

