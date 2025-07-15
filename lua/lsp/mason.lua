local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

-- CRITICAL: Pre-emptively disable sqls before any LSP setup can happen
if lspconfig.sqls then
    -- Override default config to prevent sqls from attaching to any files
    lspconfig.sqls.filetypes = {}
    -- Or completely disable it by making cmd unreachable
    lspconfig.sqls.cmd = { "nonexistent-command-that-will-never-execute" }
end


mason.setup()

mason_lspconfig.setup({
    ensure_installed = {
        "pyright",
        "lua_ls",
        "ruff",
    },
    automatic_installation = true,
})

-- Custom LSP configurations
local custom_configs = {
    lua_ls = {
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
        root_dir = lspconfig.util.root_pattern(".git", "init.lua", "lua"),
    },
    
    ruff = {
        settings = {
            lint = {
                select = { "F" }
            },
            format = {
                -- Enable formatting
            }
        }
    },
    
    pyright = {
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
    },
}

-- Setup LSP servers
lspconfig.lua_ls.setup(custom_configs.lua_ls)
lspconfig.ruff.setup(custom_configs.ruff)
lspconfig.pyright.setup(custom_configs.pyright)

-- Explicitly tell lspconfig not to start sqls by providing an empty setup with disabled filetypes
if lspconfig.sqls then
    lspconfig.sqls.setup({
        filetypes = {}, -- Empty filetypes means it won't attach to any files
        autostart = false,
        cmd = { "nonexistent-command-for-sqls" }, -- This will prevent even manual startup
    })
end

-- Create autocommand to catch any attempts to start sqls
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("DisableSqlsGroup", {clear = true}),
    pattern = {"sql", "mysql"}, 
    callback = function(ev)
        -- Stop any sqls server that might have started for this buffer
        for _, client in ipairs(vim.lsp.get_active_clients({bufnr = ev.buf})) do
            if client.name == "sqls" then
                client.stop()
            end
        end
        return true
    end,
    desc = "Prevent sqls from attaching to SQL files",
})

-- Additional attempt: Remove sqls from Mason
vim.schedule(function()
    -- Attempt to uninstall sqls from Mason
    local mason_registry = require("mason-registry")
    if mason_registry.is_installed and mason_registry.is_installed("sqls") then
        vim.notify("Attempting to uninstall sqls from Mason...", vim.log.levels.INFO)
        local sqls_pkg = mason_registry.get_package("sqls") 
        sqls_pkg:uninstall()
    end
end)

-- nvim-lint configuration block removed as the plugin is not found or not used here anymore

-- Ensure Mason doesn't try to manage sqlfluff if installed via pip
-- Ensure Ruff LSP provides diagnostics (default, but good to be aware of)
