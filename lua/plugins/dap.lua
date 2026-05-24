return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local cwd = vim.fn.getcwd()
      local venv_python = cwd .. "/.venv/bin/python"

      dap.defaults.fallback.terminal_win_cmd = "vsplit | wincmd l"

      dap.adapters.python = {
        type = "executable",
        command = venv_python,
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = dap.configurations.python or {}

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
      vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true, desc = "Toggle debug mode" })
      vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
      dm.plugins.osv_integration.enabled = true
    end,
  },
}
