return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lsp = vim.lsp
      -- nvim 0.12 renamed protocol._request_name_to_capability → _request_name_to_server_capability.
      -- none-ls reads from the old names; alias so capability_is_disabled works.
      if lsp and lsp.protocol then
        local src = lsp.protocol._request_name_to_capability
            or lsp.protocol._request_name_to_server_capability
        if src then
          lsp.protocol._request_name_to_capability = src
          lsp._request_name_to_capability = src
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
