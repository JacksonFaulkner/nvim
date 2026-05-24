return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  event = "BufReadPost",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "markdown",
        "markdown_inline",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      auto_install = true,
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["ak"] = "@class.outer",
            ["ik"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
          },
          include_surrounding_whitespace = false,
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          -- Need to change these keybindings
          goto_next_start = {
            ["<leader>sj"] = "@function.outer",
            ["<leader>sC"] = "@class.outer",
            ["<leader>s?"] = "@comment.outer",
            ["<leader>sI"] = "@conditional.*",
            ["<leader>sL"] = "@loop.*",
          },
          goto_next_end = {
            ["<leader>ef"] = "@function.outer",
            ["<leader>ec"] = "@class.outer",
            ["<leader>e/"] = "@comment.outer",
            ["<leader>ei"] = "@conditional.*",
            ["<leader>el"] = "@loop.*",
          },
          goto_previous_start = {
            ["<leader>sk"] = "@function.outer",
            ["<leader>sc"] = "@class.outer",
            ["<leader>s/"] = "@comment.outer",
            ["<leader>si"] = "@conditional.*",
            ["<leader>sl"] = "@loop.*",
          },
          goto_previous_end = {
            ["<leader>ej"] = "@function.outer",
            ["<leader>eC"] = "@class.outer",
            ["<leader>e?"] = "@comment.outer",
            ["<leader>eI"] = "@conditional.*",
            ["<leader>eL"] = "@loop.*",
          },
        },
      },
    })
  end,
}
