return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    event = "BufReadPre",
    config = function()
      local lsp = vim.lsp
      if lsp and not lsp._request_name_to_capability then
        if lsp.protocol and lsp.protocol._request_name_to_capability then
          lsp._request_name_to_capability = lsp.protocol._request_name_to_capability
        else
          lsp._request_name_to_capability = {}
        end
      end

      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- Terraform
          null_ls.builtins.formatting.terraform_fmt,
          null_ls.builtins.diagnostics.terraform_validate,

          -- JavaScript/TypeScript/React (Prettier)
          null_ls.builtins.formatting.prettier.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "json",
              "css",
              "scss",
              "html",
              "markdown",
            },
          }),
        },
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "terraform_fmt",
          "ruff",
          "prettier",
          "eslint_d",
          "eslint-lsp",
        },
        automatic_installation = true,
      })
    end,
  },
}
