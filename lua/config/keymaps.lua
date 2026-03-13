local opts = { noremap = true, silent = true }
-- Use Neovim's keymap helper
local keymap = vim.keymap.set

-- General Keybindings
keymap('n', '<leader>wo', function()
  vim.wo.wrap = not vim.wo.wrap
  if vim.wo.wrap then
    vim.wo.linebreak = true
    vim.wo.colorcolumn = "80"
    print("Wrap ON (80 col guide)")
  else
    vim.wo.linebreak = false
    vim.wo.colorcolumn = ""
    print("Wrap OFF")
  end
end, { desc = 'Toggle wrap with 80 char guide' })
keymap('n', '<leader>if', 'oif __name__ == "__main__":<CR>', { desc = 'Insert Python __main__ guard' })


-- Telescope
-- Function to get current directory (file or oil/netrw)
local function get_search_dir(levels_up)
  local current_dir

  if vim.bo.filetype == "oil" then
    -- For oil.nvim, get the current directory from oil
    current_dir = require('oil').get_current_dir()
  elseif vim.bo.filetype == "netrw" then
    -- Get the actual netrw directory
    current_dir = vim.b.netrw_curdir or vim.fn.getcwd()
  else
    -- Get directory of current file
    local file_path = vim.fn.expand("%:p")
    if file_path == "" then
      current_dir = vim.fn.getcwd()
    else
      current_dir = vim.fn.fnamemodify(file_path, ":h")
    end
  end

  -- Navigate up the specified number of levels
  for i = 1, levels_up do
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return current_dir
end

-- Abstracted telescope functions
local function telescope_find_files(levels_up)
  local levels_text = levels_up == 0 and "Current Dir" or
      levels_up .. " Dir" .. (levels_up == 1 and "" or "s") .. " Up"

  require('telescope.builtin').find_files({
    cwd = get_search_dir(levels_up),
    prompt_title = "Find Files (" .. levels_text .. ")"
  })
end

local function telescope_grep(levels_up)
  local levels_text = levels_up == 0 and "Current Dir" or
      levels_up .. " Dir" .. (levels_up == 1 and "" or "s") .. " Up"

  require('telescope.builtin').live_grep({
    cwd = get_search_dir(levels_up),
    prompt_title = "Grep (" .. levels_text .. ")"
  })
end

local function telescope_grep_word(levels_up, whole_word)
  require('telescope.builtin').grep_string({
    cwd = get_search_dir(levels_up),
    search = vim.fn.expand("<cword>"),
    word_match = whole_word and "-w" or nil
  })
end

keymap('n', '<leader>ff', function() telescope_find_files(0) end, { desc = 'Find Files (Current Dir)' })
keymap('n', '<leader>fjf', function() telescope_find_files(1) end, { desc = 'Find Files (1 Dir Up)' })
keymap('n', '<leader>fjjf', function() telescope_find_files(2) end, { desc = 'Find Files (2 Dirs Up)' })
keymap('n', '<leader>fjjjf', function() telescope_find_files(3) end, { desc = 'Find Files (3 Dirs Up)' })

keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find Buffers' })
keymap('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Find Recent Files' })
keymap('n', '<leader>fe', '<cmd>Telescope oldbuffers<cr>', { desc = 'Find Recent Buffers' })

keymap('n', '<leader>fg', function() telescope_grep(0) end, { desc = 'Grep (Current Dir)' })
keymap('n', '<leader>fjg', function() telescope_grep(1) end, { desc = 'Grep (1 Dir Up)' })
keymap('n', '<leader>fjjg', function() telescope_grep(2) end, { desc = 'Grep (2 Dirs Up)' })
keymap('n', '<leader>fjjjg', function() telescope_grep(3) end, { desc = 'Grep (3 Dirs Up)' })

keymap('n', '<leader>fh', function()
  require('telescope.builtin').find_files({
    cwd = vim.fn.getcwd(),
    prompt_title = 'Find Files (CWD)',
    no_ignore = true,
  })
end, { desc = 'Find Files (CWD)' })

keymap('n', '<leader>fhg', function()
  require('telescope.builtin').live_grep({
    cwd = vim.fn.getcwd(),
    prompt_title = 'Grep (CWD)'
  })
end, { desc = 'Grep (CWD)' })

-- Super persistent file history (custom extension)
keymap('n', '<leader>fj', function()
  require('custom_plugins.telescope_history').history_picker()
end, { desc = 'Persistent File History' })

-- Moving Text
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted block down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted block up" })

-- ESLint Popup
keymap("n", "<leader>gi", function()
  require("custom_plugins.eslint_popup").run_eslint()
end, { desc = "Run ESLint in popup" })

keymap("n", "<leader>wq", ":wq<CR>")
keymap("n", "<leader>ww", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>we", ":w<CR>:Oil<CR>")


-- Clipboard
keymap("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- Indentation
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Variable formatting (visual selection)
keymap("v", "<leader>sv", function()
  require("scripts.variable_formatting").format_visual_block()
end, { desc = "Align assignment block in selection" })

-- Open a terminal on the right with leader t l
keymap('n', '<leader>tl', '<cmd>ToggleTerm direction=vertical size=80<CR>', { desc = 'Terminal right (vertical)' })
keymap('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
keymap('t', 'jk', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })


-- LSP Keybindings
keymap("n", "<leader>gd", vim.lsp.buf.definition, opts)       -- Go to definition
keymap("n", "<leader>gr", vim.lsp.buf.references, opts)       -- Show references
keymap("n", "<leader>gh", vim.lsp.buf.hover, opts)
keymap("n", "<leader>gt", vim.lsp.buf.type_definition, opts)  -- Show type definition
keymap("n", "<leader>gs", vim.lsp.buf.workspace_symbol, opts) -- List workspace symbols
keymap("n", "<leader>gj", vim.diagnostic.open_float, opts)    -- Show diagnostics in a floating window

-- LSP Format (Ruff for Python, Prettier + ESLint for JS/TS/React)
keymap("n", "<leader>gl", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format with LSP + ESLint" })

-- Terraform formatting
keymap("n", "<leader>tf", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    return
  end
  vim.cmd("write")
  vim.fn.system({ "terraform", "fmt", bufname })
  vim.cmd("edit")
end, { desc = "Format Terraform files" })

-- Surround visual selection with characters (I made this. Hasn't failed so far)
keymap("x", "<leader>\"", [[<Esc>`>a"<Esc>`<i"<Esc>]], { desc = "Surround with double quotes" })
keymap("x", "<leader>'", [[<Esc>`>a'<Esc>`<i'<Esc>]], { desc = "Surround with single quotes" })
keymap("x", "<leader>(", [[<Esc>`>a)<Esc>`<i(<Esc>]], { desc = "Surround with parentheses" })
keymap("x", "<leader>{", [[<Esc>`>a}<Esc>`<i{<Esc>]], { desc = "Surround with curly braces" })
keymap("x", "<leader>[", [[<Esc>`>a]<Esc>`<i[<Esc>]], { desc = "Surround with square brackets" })

-- Window Movement
keymap("n", "<leader>wh", "<C-w>h", opts)
keymap("n", "<leader>wj", "<C-w>j", opts)
keymap("n", "<leader>wk", "<C-w>k", opts)
keymap("n", "<leader>wl", "<C-w>l", opts)

-- Teleport (opens splits to the right)
local home = vim.env.HOME
keymap("n", "<leader>vg", ":belowright vnew " .. home .. "/code/gitlab_repos/<CR>")
keymap("n", "<leader>vs", ":belowright vsplit<CR>")

-- Ruff: Fix all auto-fixable issues
keymap("n", "<leader>gf", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.fixAll.ruff" } },
    apply = true,
  })
end, { desc = "Ruff: Fix all auto-fixable issues (no prompt)" })

keymap("n", "<leader>to", "<cmd>silent !wezterm cli spawn --cwd $(pwd) -- lazygit<CR>", opts)
