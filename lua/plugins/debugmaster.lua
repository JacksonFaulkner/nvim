return {
    {
        "rcarriga/nvim-dap-ui",
        enabled = false,
    },
    {
        "miroshQa/debugmaster.nvim",
        dependencies = {
            "mfussenegger/nvim-dap",
            "jbyuki/one-small-step-for-vimkind",
        },
        config = function()
            local dm = require("debugmaster")

            -- Keymap: toggle debug mode
            -- Use built-in DebugMaster workflow on <leader>d
            vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true, desc = "Toggle debug mode" })

            -- Optional: exit terminal mode quickly
            vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

            -- Enable lua debugging integration (osv)
            dm.plugins.osv_integration.enabled = true

            -- You still need to configure dap adapters yourself in your dap config
            -- See: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
        end,
    },
}
