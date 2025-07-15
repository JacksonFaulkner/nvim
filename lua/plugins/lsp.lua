return {
  {
    'williamboman/mason.nvim',
    build = ":MasonUpdate",
    config = function()
      -- Just set up Mason without any additional configuration
      require("mason").setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'williamboman/mason.nvim' },
    config = function()
      -- Only tell mason-lspconfig which servers to install, but don't set them up
      require("mason-lspconfig").setup({
        ensure_installed = { "ruff", "pyright", "lua_ls" },
        automatic_installation = true,
      })
      
      -- Skip automatic server setup - we'll do it manually in lsp/mason.lua
      local old_setup_handlers = require("mason-lspconfig").setup_handlers
      require("mason-lspconfig").setup_handlers = function() end
    end
  },
}

