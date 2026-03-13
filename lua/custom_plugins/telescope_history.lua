local M = {}
local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local utils = require('telescope.utils')
local path = require('plenary.path')

-- Path to history file
local history_file = vim.fn.stdpath('data') .. '/telescope_history.txt'

-- Function to read the history file
local function read_history_file()
  local file = io.open(history_file, "r")
  if not file then
    return {}
  end

  local lines = {}
  for line in file:lines() do
    if vim.fn.filereadable(line) == 1 then
      table.insert(lines, line)
    end
  end
  file:close()

  return lines
end

-- Function to write to history file
local function write_to_history(filepath)
  -- Don't add if it's already the most recent entry
  local history = read_history_file()
  if #history > 0 and history[1] == filepath then
    return
  end

  -- Remove existing entry of this file (if any)
  for i, path in ipairs(history) do
    if path == filepath then
      table.remove(history, i)
      break
    end
  end

  -- Add to the beginning
  table.insert(history, 1, filepath)

  -- Keep only the last 10000 entries
  if #history > 10000 then
    history[10001] = nil
  end

  -- Write back to file
  local file = io.open(history_file, "w")
  if not file then
    vim.notify("Failed to open history file for writing", vim.log.levels.ERROR)
    return
  end

  for _, path in ipairs(history) do
    file:write(path .. "\n")
  end
  file:close()
end

-- Register autocommand to track file access
function M.setup()
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
      local filepath = vim.api.nvim_buf_get_name(args.buf)
      if filepath ~= "" and vim.fn.filereadable(filepath) == 1 then
        write_to_history(filepath)
      end
    end
  })
end

-- The actual picker function
function M.history_picker(opts)
  opts = opts or {}

  local history = read_history_file()

  if #history == 0 then
    vim.notify("No files in history yet", vim.log.levels.INFO)
    return
  end

  pickers.new(opts, {
    prompt_title = "File History",
    finder = finders.new_table {
      results = history,
      entry_maker = function(entry)
        local display = path.new(entry):filename()
        return {
          value = entry,
          display = display,
          ordinal = entry,
          path = entry,
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    previewer = conf.file_previewer(opts),
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.8,
      preview_width = 0.5,
      prompt_position = "bottom",
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd('edit ' .. selection.value)
      end)
      return true
    end,
  }):find()
end

return M

