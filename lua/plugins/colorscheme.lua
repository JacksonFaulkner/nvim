return {
  "Mofiqul/dracula.nvim",
  name = "dracula",
  priority = 1000,
  lazy = false,
  config = function()
    require("dracula").setup({})
    vim.cmd("colorscheme dracula")
    -- Terminal transparency: use guibg=NONE so treesitter gets no numeric bg to blend
    vim.cmd("hi! Normal guibg=NONE ctermbg=NONE")
    vim.cmd("hi! NormalNC guibg=NONE ctermbg=NONE")
    vim.cmd("hi! NormalFloat guibg=NONE ctermbg=NONE")
    vim.cmd("hi! SignColumn guibg=NONE ctermbg=NONE")
    vim.cmd("hi! EndOfBuffer guibg=NONE ctermbg=NONE")
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
