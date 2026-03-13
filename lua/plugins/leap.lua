return {
    dir = vim.fn.stdpath("config") .. "/lua/custom_plugins/leap.nvim",
    name = "leap.nvim",
    keys = {
        { "s", "<Plug>(leap)", mode = { "n", "x", "o" }, desc = "Leap bidirectional" },
        { "S", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap backward" },
    },
}
