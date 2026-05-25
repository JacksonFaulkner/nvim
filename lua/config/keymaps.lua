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


-- fzf-lua pickers
local function get_search_dir(levels_up)
  local current_dir

  if vim.bo.filetype == "oil" then
    current_dir = require('oil').get_current_dir()
  elseif vim.bo.filetype == "netrw" then
    current_dir = vim.b.netrw_curdir or vim.fn.getcwd()
  else
    local file_path = vim.fn.expand("%:p")
    if file_path == "" then
      current_dir = vim.fn.getcwd()
    else
      current_dir = vim.fn.fnamemodify(file_path, ":h")
    end
  end

  for _ = 1, levels_up do
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return current_dir
end

local function levels_text(levels_up)
  return levels_up == 0 and "Current Dir" or
      levels_up .. " Dir" .. (levels_up == 1 and "" or "s") .. " Up"
end

local function fzf_files(levels_up)
  require('fzf-lua').files({
    cwd = get_search_dir(levels_up),
    prompt = 'Find Files (' .. levels_text(levels_up) .. ')> ',
  })
end

local function fzf_grep(levels_up)
  require('fzf-lua').live_grep({
    cwd = get_search_dir(levels_up),
    prompt = 'Grep (' .. levels_text(levels_up) .. ')> ',
  })
end

keymap('n', '<leader>ff', function() fzf_files(0) end, { desc = 'Find Files (Current Dir)' })
keymap('n', '<leader>fjf', function() fzf_files(1) end, { desc = 'Find Files (1 Dir Up)' })
keymap('n', '<leader>fjjf', function() fzf_files(2) end, { desc = 'Find Files (2 Dirs Up)' })
keymap('n', '<leader>fjjjf', function() fzf_files(3) end, { desc = 'Find Files (3 Dirs Up)' })

keymap('n', '<leader>fb', function() require('fzf-lua').buffers() end, { desc = 'Find Buffers' })
keymap('n', '<leader>fw',
  function() vim.fn.jobstart('bash /Users/jfaulkner/.config/tmux/plugins/plain/scripts/sessionx.sh', { detach = true }) end,
  { desc = 'Tmux sessionx' })
keymap('n', '<leader>fr', function() require('fzf-lua').oldfiles() end, { desc = 'Find Recent Files' })

keymap('n', '<leader>fg', function() fzf_grep(0) end, { desc = 'Grep (Current Dir)' })
keymap('n', '<leader>fjg', function() fzf_grep(1) end, { desc = 'Grep (1 Dir Up)' })
keymap('n', '<leader>fjjg', function() fzf_grep(2) end, { desc = 'Grep (2 Dirs Up)' })
keymap('n', '<leader>fjjjg', function() fzf_grep(3) end, { desc = 'Grep (3 Dirs Up)' })

keymap('n', '<leader>fh', function()
  require('fzf-lua').files({
    cwd = vim.fn.getcwd(),
    prompt = 'Find Files (CWD, no ignore)> ',
    fd_opts = "--color=never --type f --hidden --no-ignore --exclude .git",
    rg_opts = "--color=never --files --hidden --no-ignore --glob '!.git'",
  })
end, { desc = 'Find Files (CWD, no ignore)' })

keymap('n', '<leader>fhg', function()
  require('fzf-lua').live_grep({ cwd = vim.fn.getcwd(), prompt = 'Grep (CWD)> ' })
end, { desc = 'Grep (CWD)' })

-- Line navigation
keymap({ "n", "v" }, "gh", "^", { desc = "Go to first non-blank character" })
keymap({ "n", "v" }, "gl", "g_", { desc = "Go to last non-blank character" })

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
keymap("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory in Oil" })
keymap("n", "<leader>ae", ":edit!<CR>", { desc = "Reload file from disk" })


-- Clipboard
keymap("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("n", "<leader>cy", function()
  require("custom_plugins.chrome_auth").copy_auth_token()
end, { desc = "Copy Auth0 token and run in Chrome console" })

-- Indentation
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })


-- Toggle a persistent terminal on the right with leader t l
local _term_buf = nil
local _term_win = nil
keymap('n', '<leader>tl', function()
  -- If terminal window is open, close it
  if _term_win and vim.api.nvim_win_is_valid(_term_win) then
    vim.api.nvim_win_close(_term_win, true)
    _term_win = nil
    return
  end
  -- If terminal buffer exists and is valid, show it
  if _term_buf and vim.api.nvim_buf_is_valid(_term_buf) then
    vim.cmd('botright vnew')
    _term_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(_term_win, _term_buf)
    vim.cmd('vertical resize 80')
  else
    -- Create new terminal
    vim.cmd('botright vnew | terminal')
    vim.cmd('vertical resize 80')
    _term_buf = vim.api.nvim_get_current_buf()
    _term_win = vim.api.nvim_get_current_win()
  end
end, { desc = 'Toggle terminal right (vertical)' })
keymap('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
keymap('t', 'jk', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })


-- LSP Keybindings
keymap("n", "<leader>gd", vim.lsp.buf.definition, opts)       -- Go to definition
keymap("n", "<leader>gr", vim.lsp.buf.references, opts)       -- Show references
keymap("n", "<leader>gh", vim.lsp.buf.hover, opts)
keymap("n", "<leader>gt", vim.lsp.buf.type_definition, opts)  -- Show type definition
keymap("n", "<leader>gs", vim.lsp.buf.workspace_symbol, opts) -- List workspace symbols
-- <leader>gj: Trouble panel (diagnostics + LSP refs) — see lua/plugins/trouble.lua

-- LSP Format (Ruff for Python, Prettier + ESLint for JS/TS/React)
keymap("n", "<leader>gk", function()
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
keymap("n", "<leader>w=", "<C-w>=", { desc = "Equalize split sizes" })

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

keymap("n", "<leader>to", function()
  vim.cmd("silent !tmux new-window -n lazygit -c " .. vim.fn.getcwd() .. " lazygit")
end, { desc = "Open LazyGit in new tmux window" })

-- Buffer navigation (built-in, no plugin)
keymap("n", "<S-h>", "<cmd>bprev<CR>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end, { desc = "Close other buffers" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })


-- Toggle bufferline visibility (show buffer tabs over Ghostty tab bar)
keymap("n", "<leader>bt", function()
  if vim.o.showtabline == 0 then
    vim.o.showtabline = 2
  else
    vim.o.showtabline = 0
  end
end, { desc = "Toggle bufferline visibility" })
