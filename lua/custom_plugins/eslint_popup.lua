local M = {}

function M.run_eslint()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " ESLint ",
    title_pos = "center",
  })

  vim.fn.termopen("eslint .", {
    cwd = vim.fn.getcwd(),
    on_exit = function()
      vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })

  vim.cmd("startinsert")
end

return M
