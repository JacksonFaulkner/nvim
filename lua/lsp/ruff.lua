local lspconfig = require('lspconfig')

lspconfig.ruff.setup({
    init_options = {
        settings = {
            lint = {
                select = { "F" },
            },
            format = {}, -- Enable formatting
        }
    },
})

-- Disable formatting in Pyright to avoid conflicts with Ruff
require('lspconfig').pyright.setup {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end,
}

return {}
