return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("claudecode").setup({
      -- Server Configuration
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "info", -- "trace", "debug", "info", "warn", "error"
      terminal_cmd = nil, -- nil uses "claude" by default

      -- Send/Focus Behavior
      focus_after_send = false,

      -- Selection Tracking
      track_selection = true,
      visual_demotion_delay_ms = 50,

      -- Terminal Configuration
      terminal = {
        split_side = "right",
        split_width_percentage = 0.40,
        provider = "snacks",
        auto_close = true,

        -- Working directory control
        git_repo_cwd = true,

        -- Snacks.nvim floating window options
        snacks_win_opts = {
          position = "float",
          width = 0.9,
          height = 0.9,
          border = "rounded",
          backdrop = false,
          keys = {
            claude_hide = {
              "<C-,>",
              function(self)
                self:hide()
              end,
              mode = "t",
              desc = "Hide Claude",
            },
            exit_terminal = {
              "<C-g>",
              function(self)
                self:hide()
              end,
              mode = "t",
              desc = "Hide Claude window",
            },
          },
        },
      },

      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = true,
        keep_terminal_focus = false,
      },
    })

    -- Always enter normal mode when entering Claude Code window
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*",
      callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match("claude") and vim.bo.buftype == "terminal" then
          vim.defer_fn(function()
            local mode = vim.api.nvim_get_mode().mode
            if mode == "t" then
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true),
                "n",
                false
              )
            end
          end, 10)
        end
      end,
    })
  end,
  keys = {
    { "<leader>a",  nil,                              desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file from tree",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    {
      "<leader>ao",
      function()
        require("custom_plugins.docs_view").toggle()
      end,
      desc = "Toggle annotated docs view",
    },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>",     desc = "Claude status" },
    {
      "<leader>al",
      function()
        -- Open Claude if not already open, then send the pre-prompt
        vim.cmd("ClaudeCode")
        vim.defer_fn(function()
          local prompt =
          'I prob just sent you some code or context use this skill located at .claude/skills/skill_issues/UNDERSTAND-CODE.md and make use that as a wireframe for an interactive activity to learn about the context.\n\n'
          -- Send keystrokes to the terminal
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("i", true, false, true),
            "n",
            false
          )
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(prompt, "t", false)
          end, 50)
        end, 300)
      end,
      desc = "Claude with SLOW-CODE-GEN prompt",
    },
  },
}
