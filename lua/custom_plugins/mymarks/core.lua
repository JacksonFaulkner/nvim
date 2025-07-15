-- ~/.config/nvim/lua/custom_plugins/mymarks/core.lua

local M = {}

-- Table to store marks: { [bufnr] = { [char] = { { line = ..., col = ... }, ... } } }
local marks = {}
local ns_id = vim.api.nvim_create_namespace("mymarks")

-- Hardcoded keys and their corresponding colors for highlighting
local color_keys = { "q", "w", "e", "r", "a", "s", "d", "f" }
local color_map = {
  q = "#FF6B6B", w = "#F7B267", e = "#FFD93D", r = "#6BCB77",
  a = "#4D96FF", s = "#9D4EDD", d = "#FF66CC", f = "#00CED1",
}

function M.setup()
  -- Cleanup marks on buffer unload
  vim.api.nvim_create_autocmd("BufUnload", {
    callback = function(args)
      marks[args.buf] = nil
    end,
  })

  -- Define highlight groups for our special keys with transparency
  for _, key in ipairs(color_keys) do
    vim.api.nvim_set_hl(0, "MarkCursor_" .. key, {
      fg = color_map[key],
      bg = "NONE",
      blend = 80,  -- Higher blend value = more transparent (range 0-100)
    })
  end
end

function M.set_mark(char)
  local bufnr = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0)  -- pos is {line, col}
  local line, col = pos[1], pos[2]

  marks[bufnr] = marks[bufnr] or {}
  marks[bufnr][char] = marks[bufnr][char] or {}
  table.insert(marks[bufnr][char], { line = line, col = col })

  -- Determine the highlight group: use our custom group if available
  local hl_group = "Comment"
  if color_map[char] then
    hl_group = "MarkCursor_" .. char
  end

  -- Highlight the character at the mark position.
  -- Note: extmarks are 0-indexed, so line - 1 is used.
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, line - 1, col, {
    end_line = line - 1,
    end_col = col + 1,
    hl_group = hl_group,
  })

  vim.notify("Mark '" .. char .. "' set at " .. line .. ":" .. col)
end

function M.has_mark(char)
  local bufnr = vim.api.nvim_get_current_buf()
  local entries = marks[bufnr] and marks[bufnr][char]
  return entries and #entries > 0
end

function M.jump_to_mark(char)
  local bufnr = vim.api.nvim_get_current_buf()
  local entries = marks[bufnr] and marks[bufnr][char]
  if not entries or #entries == 0 then
    vim.notify("No marks set for '" .. char .. "'", vim.log.levels.WARN)
    return
  end

  local mark = entries[1]  -- Jump to the first mark for now
  vim.api.nvim_win_set_cursor(0, { mark.line, mark.col })
end

return M

