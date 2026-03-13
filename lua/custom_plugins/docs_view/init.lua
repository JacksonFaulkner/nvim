local M = {}

-- Cache dir for annotated files
local cache_dir = vim.fn.stdpath("cache") .. "/docs_view"

-- State: tracks which buffers have a docs view and toggle state
-- key = original file path, value = { docs_path, showing_docs }
local state = {}

local function ensure_cache_dir()
  vim.fn.mkdir(cache_dir, "p")
end

local function cache_path_for(filepath)
  -- Create a unique cache filename from the full path
  local encoded = filepath:gsub("/", "%%")
  return cache_dir .. "/" .. encoded .. ".annotated"
end

local function get_filetype(filepath)
  local ext = vim.fn.fnamemodify(filepath, ":e")
  local ft_map = {
    py = "python", js = "javascript", ts = "typescript",
    tsx = "typescriptreact", jsx = "javascriptreact",
    lua = "lua", go = "go", rs = "rust", rb = "ruby",
    tf = "terraform", hcl = "terraform", sh = "bash",
    yml = "yaml", yaml = "yaml", json = "json",
  }
  return ft_map[ext] or ext
end

--- Generate annotated docs view for the current file using claude CLI
function M.generate()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    vim.notify("No file open", vim.log.levels.WARN)
    return
  end

  ensure_cache_dir()
  local docs_path = cache_path_for(filepath)
  local filename = vim.fn.fnamemodify(filepath, ":t")

  vim.notify("Generating docs view for " .. filename .. "...", vim.log.levels.INFO)

  local prompt = string.format(
    'Read the file at %s and create a heavily annotated version. '
    .. 'Add detailed comments explaining what each section does, why it exists, '
    .. 'how the pieces connect, and any non-obvious behavior. '
    .. 'Keep ALL original code exactly as-is — only add comments. '
    .. 'Output ONLY the annotated code, no markdown fences, no preamble.',
    filepath
  )

  vim.fn.jobstart({
    "claude", "-p", prompt, "--output-format", "text",
  }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        -- Remove trailing empty strings
        while #data > 0 and data[#data] == "" do
          table.remove(data)
        end
        if #data > 0 then
          vim.fn.writefile(data, docs_path)
          vim.schedule(function()
            state[filepath] = { docs_path = docs_path, showing_docs = false }
            vim.notify("Docs view ready for " .. filename .. ". Use <leader>ao to toggle.", vim.log.levels.INFO)
          end)
        end
      end
    end,
    on_stderr = function(_, data)
      if data and data[1] and data[1] ~= "" then
        vim.schedule(function()
          vim.notify("docs_view error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
        end)
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify("docs_view: claude exited with code " .. code, vim.log.levels.ERROR)
        end)
      end
    end,
  })
end

--- Toggle between original file and its annotated docs view
function M.toggle()
  local filepath = vim.fn.expand("%:p")

  -- Check if we're currently viewing a docs file, find the original
  local original_for_docs = nil
  for orig, s in pairs(state) do
    if s.docs_path == filepath then
      original_for_docs = orig
      break
    end
  end

  if original_for_docs then
    -- We're in the docs view, switch back to original
    state[original_for_docs].showing_docs = false
    vim.cmd("edit " .. vim.fn.fnameescape(original_for_docs))
    return
  end

  -- We're in the original file
  local s = state[filepath]
  if not s or not vim.fn.filereadable(s.docs_path) then
    -- No docs view exists yet, generate one
    M.generate()
    return
  end

  -- Toggle to docs view
  s.showing_docs = true
  local ft = get_filetype(filepath)
  vim.cmd("edit " .. vim.fn.fnameescape(s.docs_path))
  vim.bo.filetype = ft
  vim.bo.modifiable = false
  vim.bo.buftype = "nofile"
end

return M
