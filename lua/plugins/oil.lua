return {
  'stevearc/oil.nvim',
  opts = {
    default_file_explorer = true,
    columns = {
      "icon",
    },
  },
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    -- Override Python icon with 🐐 emoji
    require("nvim-web-devicons").set_icon {
      py = {
        icon = "󰌠",
        color = "#FFD700", -- gold, feel free to change
        cterm_color = "220",
        name = "Python",
      }
    }
  end,
}

