return {
  {
    'williamboman/mason.nvim',
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'williamboman/mason.nvim' },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
          ensure_installed = {
              "lua_ls",
              "pyright",
              "ruff",
              "ts_ls",
              "terraformls",
              "cssls",
              "eslint",
              "gopls",
          },
          automatic_installation = true,
      })

      -- Use vim.lsp.config instead of deprecated require('lspconfig')
      
      -- Lua LSP configuration
      vim.lsp.config('lua_ls', {
          settings = {
              Lua = {
                  runtime = {
                      version = "LuaJIT",
                      path = vim.split(package.path, ";"),
                  },
                  diagnostics = {
                      globals = { "vim" },
                  },
                  workspace = {
                      library = vim.api.nvim_get_runtime_file("", true),
                      checkThirdParty = false,
                  },
                  telemetry = {
                      enable = false,
                  },
              },
          },
      })

      -- Ruff linter configuration
      vim.lsp.config('ruff', {
          settings = {
              lint = {
                  -- Use all Ruff rules so fixAll can apply everything (including imports).
                  select = { "ALL" },
                  fixable = { "ALL" },
              },
          }
      })

      -- Python LSP configuration
      vim.lsp.config('pyright', {
          settings = {
              pyright = {
                  -- Using Ruff's import organizer
                  disableOrganizeImports = true,
              },
              python = {
                  analysis = {
                      -- Ignore all files for analysis to exclusively use Ruff for linting
                      ignore = { '*' },
                      autoSearchPaths = true,
                      diagnosticMode = "openFilesOnly",
                      useLibraryCodeForTypes = true
                  },
              },
          },
          on_attach = function(client, bufnr)
              client.server_capabilities.documentFormattingProvider = false
          end,
      })

      -- TypeScript/JavaScript LSP configuration
      vim.lsp.config('ts_ls', {
          settings = {
              typescript = {
                  inlayHints = {
                      includeInlayParameterNameHints = "all",
                      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                      includeInlayFunctionLikeReturnTypeHints = true,
                      includeInlayEnumMemberValueHints = true,
                      includeInlayVariableTypeHints = true,
                      includeInlayPropertyDeclarationTypeHints = true,
                  },
              },
              javascript = {
                  inlayHints = {
                      includeInlayParameterNameHints = "all",
                      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                      includeInlayFunctionLikeReturnTypeHints = true,
                      includeInlayEnumMemberValueHints = true,
                      includeInlayVariableTypeHints = false,
                  },
              },
          },
      })

      -- Terraform LSP configuration
      vim.lsp.config('terraformls', {
        cmd = { 'terraform-ls', 'serve' },
        filetypes = { 'terraform', 'terraform-vars', 'tf' },
        root_markers = { '.terraform', '.git', 'main.tf', 'terraform.tfvars' },
        settings = {
          terraformls = {
            telemetry = {
              enable = false,
            },
          },
          terraform = {
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Ensure .tf files are recognized as terraform
      vim.filetype.add({
        extension = {
          tf = 'terraform',
          tfvars = 'terraform-vars',
        },
      })

      -- CSS LSP configuration
      vim.lsp.config('cssls', {
        filetypes = { 'css', 'scss', 'less' },
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      })

      vim.lsp.config('eslint', {
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
      })

      vim.lsp.enable({'lua_ls', 'ruff', 'pyright', 'ts_ls', 'terraformls', 'cssls', 'eslint'})

      -- Format-on-save handled by conform.nvim (see plugins/null_ls.lua)

      vim.lsp.config('sqls', { enabled = false })
    end
  },
}
