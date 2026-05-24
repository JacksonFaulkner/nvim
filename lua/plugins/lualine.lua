return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local dracula = require("lualine.themes.dracula")

    -- Make backgrounds transparent to match ghostty
    for _, mode in pairs(dracula) do
      for _, section in pairs(mode) do
        if section.bg then
          section.bg = "NONE"
        end
      end
    end

    -- Refresh statusline every second for clock
    local timer = vim.uv.new_timer()
    timer:start(1000, 1000, vim.schedule_wrap(function()
      vim.cmd.redrawstatus()
    end))

    require("lualine").setup({
      options = {
        theme = dracula,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics" },
        lualine_y = { "filetype" },
        lualine_z = {
          "location",
          function()
            return os.date("%I:%M %p")
          end,
        },
      },
    })
  end,
}
