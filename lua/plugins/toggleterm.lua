return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.5
        end
        return 20
      end,
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      close_on_exit = true,
      modifiable = true,
      shell = vim.o.shell .. " -i",
      start_in_insert = false, -- 🚀 start in normal mode
      float_opts = {
        border = "curved",
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })
  end,
}


