return {
  "andyg/leap.nvim",
  url = "https://codeberg.org/andyg/leap.nvim",
  keys = {
    { "s", "<Plug>(leap)", desc = "Leap" },
  },
  config = function()
    require("leap").setup({})
  end,
}
