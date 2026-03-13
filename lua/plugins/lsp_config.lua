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

      -- ESLint LSP configuration (replaces eslint_d via null-ls)
      vim.lsp.config('eslint', {
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
      })

      -- Enable all configured servers
      vim.lsp.enable({'lua_ls', 'ruff', 'pyright', 'ts_ls', 'terraformls', 'cssls', 'eslint'})

      -- Global format-on-save (prefers null-ls when available)
      local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
          group = format_group,
          callback = function(args)
              local bufnr = args.buf
              local clients = vim.lsp.get_clients({ bufnr = bufnr })
              local function supports_format(client)
                  if client.supports_method then
                      return client.supports_method("textDocument/formatting")
                  end
                  local caps = client.server_capabilities or {}
                  return caps.documentFormattingProvider or caps.documentRangeFormattingProvider
              end

              local has_null_ls_formatter = false

              for _, client in ipairs(clients) do
                  if client.name == "null-ls" and supports_format(client) then
                      has_null_ls_formatter = true
                      break
                  end
              end

              if has_null_ls_formatter then
                  vim.lsp.buf.format({
                      bufnr = bufnr,
                      filter = function(client)
                          return client.name == "null-ls" and supports_format(client)
                      end,
                  })
              else
                  vim.lsp.buf.format({ bufnr = bufnr })
              end
          end,
      })

      -- Disable sqls to prevent conflicts
      vim.lsp.config('sqls', { enabled = false })
    end
  },
}
