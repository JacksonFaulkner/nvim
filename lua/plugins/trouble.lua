return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    modes = {
      lsp_and_diag = {
        desc = "Diagnostics + LSP refs/defs",
        sections = { "diagnostics", "lsp_definitions", "lsp_references" },
        diagnostics = { mode = "diagnostics", title = "Diagnostics" },
        lsp_definitions = { mode = "lsp_definitions", title = "Definitions" },
        lsp_references = { mode = "lsp_references", title = "References" },
      },
    },
  },
  keys = {
    { "<leader>gj", "<cmd>Trouble lsp_and_diag toggle focus=true<cr>", desc = "Diagnostics + LSP (Trouble)" },
  },
}
