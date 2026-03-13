-- This adds color next to hexcodes in certain filetypes
return {
  "NvChad/nvim-colorizer.lua",
  event = "VeryLazy",
  opts = {
    filetypes = {
      "css",
      "scss",
      "sass",
      "less",
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "lua",
      "vim",
      "markdown",
      "*",
    },
    user_default_options = {
      RGB = true,           -- #RGB hex codes
      RRGGBB = true,        -- #RRGGBB hex codes
      names = true,         -- "Blue" etc.
      RRGGBBAA = true,      -- #RRGGBBAA
      AARRGGBB = true,      -- 0xAARRGGBB
      rgb_fn = true,        -- rgb()/rgba()
      hsl_fn = true,        -- hsl()/hsla()
      css = true,           -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true,        -- Enable all CSS functions: rgb_fn, hsl_fn
      tailwind = true,      -- Tailwind class color hints
      mode = "virtualtext", -- Show a colored square next to the code
      virtualtext = "■",    -- The symbol to use for virtualtext mode
    },
  },
}

