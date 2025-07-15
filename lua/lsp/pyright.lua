local lspconfig = require('lspconfig')

lspconfig.pyright.setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        venvPath = ".",  -- Look for virtual environments in the project root
        pythonPath = vim.fn.exepath("python"),  -- Use whatever Python is in your PATH
      },
    },
  },
})

