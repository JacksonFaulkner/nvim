local M = {}

local function format_assignment_block(lines)
  local parsed = {}
  local max_key_len = 0
  local anchor_indent = nil

  for _, line in ipairs(lines) do
    local indent, key, _, value =
        line:match("^(%s*)([%w_]+)(%s*)=%s*(.-)%s*$")

    if indent and key then
      if not anchor_indent then
        anchor_indent = indent
      end
      if indent == anchor_indent then
        if #key > max_key_len then
          max_key_len = #key
        end
        table.insert(parsed, {
          original = line,
          indent = indent,
          key = key,
          value = value,
          is_assignment = true,
          align = true,
        })
      else
        table.insert(parsed, {
          original = line,
          is_assignment = true,
          align = false,
        })
      end
    else
      table.insert(parsed, {
        original = line,
        is_assignment = false,
      })
    end
  end

  if max_key_len == 0 or not anchor_indent then
    return lines
  end

  local out = {}
  local target_indent = anchor_indent

  for _, item in ipairs(parsed) do
    if not item.is_assignment or not item.align then
      table.insert(out, item.original)
    else
      local spaces_before_eq = max_key_len - #item.key + 1
      local line =
          target_indent
          .. item.key
          .. string.rep(" ", spaces_before_eq)
          .. "= "
          .. item.value
      table.insert(out, line)
    end
  end

  return out
end

function M.format_visual_block()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local end_line = end_pos[2]

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local lines =
      vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

  local formatted = format_assignment_block(lines)

  vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, formatted)
end

return M
