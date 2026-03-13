return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim",
        "rafamadriz/friendly-snippets", -- ES7+ React/Redux/React-Native snippets
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        
        -- Load friendly-snippets (includes ES7+ React snippets)
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered({
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                    border = "rounded",
                }),
                documentation = cmp.config.window.bordered({
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                    border = "rounded",
                }),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-j>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if cmp.get_selected_entry() == nil then
                            cmp.select_next_item()
                            cmp.select_next_item()
                        else
                            cmp.select_next_item()
                        end
                    else
                        cmp.mapping.scroll_docs(-4)()
                    end
                end, { "i", "s" }),
                ["<C-k>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        cmp.mapping.scroll_docs(4)()
                    end
                end, { "i", "s" }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept explicitly selected item
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" }, -- LSP source (includes PyRight completions)
                { name = "luasnip" },  -- For snippets
                { name = "buffer" },   -- Text within current buffer
                { name = "path" },     -- File paths
            }),
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "...",
                }),
            },
            experimental = {
                ghost_text = true,  -- Shows VS Code-like ghost text
            },
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" }
            }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" }
            }, {
                { name = "cmdline" }
            })
        })
    end,
}
