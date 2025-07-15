return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        -- Just install Python parser
        ensure_installed = { "python" },
        
        -- Enable syntax highlighting
        highlight = {
          enable = true,
          -- Disable vim's regex syntax highlighting
          additional_vim_regex_highlighting = false,
        },
      })
    end
  }
}

