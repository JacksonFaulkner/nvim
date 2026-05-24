return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'kkharji/sqlite.lua' },
  config = function()
    local telescope = require('telescope')

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
        path_display = { "tail" },
      },
      pickers = {
        oldfiles = {
          -- Show more oldfiles (default is 6)
          initial_mode = "insert",
          cwd_only = false,
          include_current_session = true,
          results_show_title = false,
          limit = 10000,  -- Greatly increased limit
          path_display = { "tail" },
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.8,
            preview_width = 0.5,
            prompt_position = "bottom",
          },
          tiebreak = function(a, b)
            -- Sort by recency
            return a.index < b.index
          end,
        },
      },
    })

    -- Setup our custom history extension
    require('custom_plugins.telescope_history').setup()
  end
}

