return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local cwd = vim.fn.getcwd()
            local venv_python = cwd .. "/.venv/bin/python"

            -- Open DAP terminals in a vertical split to the right
            dap.defaults.fallback.terminal_win_cmd = "vsplit | wincmd l"

            -- Python adapter using debugpy inside project .venv
            dap.adapters.python = {
                type = "executable",
                command = venv_python,
                args = { "-m", "debugpy.adapter" },
            }

            -- Base Python configurations table
            dap.configurations.python = dap.configurations.python or {}

            -- Debug current file
            table.insert(dap.configurations.python, {
                name = "Launch file",
                type = "python",
                request = "launch",
                program = "${file}",
                console = "integratedTerminal",
                cwd = cwd,
            })


        end,
    },
}
