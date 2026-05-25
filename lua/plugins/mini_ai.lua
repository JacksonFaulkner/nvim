return {
  "echasnovski/mini.ai",
  event = "VeryLazy",
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        f = ai.gen_spec.function_call(),
      },
      search_method = "cover_or_next",
    }
  end,
}
