return {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    priority = 1000,
    lazy = false,
    config = function()
        require("dracula").setup({
            -- You can add custom highlight overrides here if needed
        })
        vim.cmd("colorscheme dracula")
        -- Python keywords in blue (import, class, async, return, def, if, else, for, while, etc.)
        vim.api.nvim_set_hl(0, "@keyword", { fg = "#6495ED" })
        vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#6495ED" })
        vim.api.nvim_set_hl(0, "@keyword.type", { fg = "#6495ED" })
        vim.api.nvim_set_hl(0, "@keyword.return", { fg = "#6495ED" })
        vim.api.nvim_set_hl(0, "@keyword.operator", { fg = "#6495ED" })
        vim.api.nvim_set_hl(0, "pythonImport", { fg = "#6495ED" })
        vim.api.nvim_set_hl(0, "pythonKeyword", { fg = "#6495ED" })
        vim.api.nvim_set_hl(0, "pythonStatement", { fg = "#6495ED" })
    end,
}
