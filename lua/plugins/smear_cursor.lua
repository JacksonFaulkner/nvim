return {
  {
    dir = vim.fn.stdpath("config") .. "/lua/custom_plugins/smear_cursor",
    name = "smear_cursor",
    event = "VeryLazy",
    config = function()
      require("custom_plugins.smear_cursor").setup({
        stiffness = 0.5,
        trailing_stiffness = 0.5,
        never_draw_over_target = true,
      })
    end,
  },
}
