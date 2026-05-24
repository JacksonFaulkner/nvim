local M = {}

M.cfg = {
  skip_filetypes = { "TelescopePrompt", "oil", "neo-tree", "lazy" },
  enabled = true,
  active = true,
  allow_scroll_move = true,
  disable_on_mouse = true,
}

local insert = "insert"
local other = "other"

local function must_skip_file(skip_filetypes, current_type)
  if skip_filetypes == nil then
    return false
  end
  for _, value in ipairs(skip_filetypes) do
    if value == current_type then
      return true
    end
  end
  return false
end

local function stay_centered(ctx)
  if not ctx.cfg.enabled or not ctx.cfg.active then
    return
  end
  if must_skip_file(ctx.cfg.skip_filetypes, vim.bo.filetype) then
    return
  end

  local line = vim.api.nvim_win_get_cursor(0)[1]
  if vim.b.last_line == nil then
    vim.b.last_line = line
  end

  if ctx.cfg.allow_scroll_move then
    local top = vim.fn.line("w0") + vim.o.scrolloff
    local bottom = vim.fn.line("w$") - vim.o.scrolloff
    if (line <= top and line > vim.b.last_line) or (line >= bottom and line < vim.b.last_line) then
      vim.b.last_line = line
      return
    end
  end

  if line ~= vim.b.last_line then
    local column = vim.fn.getcurpos()[3]
    vim.cmd("norm! zz")
    vim.b.last_line = line
    if ctx.mode == insert then
      vim.fn.cursor({ line, column })
    end
  end
end

-- Autocmds
local group = vim.api.nvim_create_augroup("StayCentered", { clear = true })

vim.api.nvim_create_autocmd("CursorMovedI", {
  group = group,
  callback = function()
    stay_centered({ mode = insert, cfg = M.cfg })
  end,
})
vim.api.nvim_create_autocmd("CursorMoved", {
  group = group,
  callback = function()
    stay_centered({ mode = other, cfg = M.cfg })
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function()
    stay_centered({ mode = other, cfg = M.cfg })
  end,
})

-- Mouse callback
M.mouse_callback = function(key, _)
  if not M.cfg.enabled then
    return
  end
  if key == vim.api.nvim_replace_termcodes("<LeftMouse>", true, true, true) then
    M.cfg.active = false
  end
  if key == vim.api.nvim_replace_termcodes("<LeftRelease>", true, true, true) then
    vim.b.last_line = vim.api.nvim_win_get_cursor(0)[1]
    M.cfg.active = true
  end
end

if M.cfg.disable_on_mouse then
  vim.on_key(M.mouse_callback)
end

return M
