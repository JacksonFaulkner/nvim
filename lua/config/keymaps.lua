local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
-- General Keybindings
vim.g.mapleader = ' ' -- set leader to space

-- LazyGit
keymap('n', '<leader>gg', '<cmd>:LazyGit <cr>', { desc = 'Open LazyGit' })

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

-- Generate telescope find_files keymaps dynamically
for i = 0, 20 do
    local key_pattern = '<leader>f' .. string.rep('j', i-1) .. 'f'
    local levels_text
    
    if i == 0 then
        levels_text = "Current Dir"
    else
        levels_text = i .. " Dir" .. (i == 1 and "" or "s") .. " Up"
    end
    
    keymap('n', key_pattern, function()
        require('telescope.builtin').find_files({
            cwd = get_search_dir(i),
            prompt_title = "Find Files (" .. levels_text .. ")"
        })
    end, { desc = 'Find Files ' .. levels_text })
end

keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find Buffers' })
keymap('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Find Recent Files' })
keymap('n', '<leader>fe', '<cmd>Telescope oldbuffers<cr>', { desc = 'Find Recent Buffers' })


-- Super persistent file history (custom extension)
keymap('n', '<leader>fj', function()
    require('custom_plugins.telescope_history').history_picker()
end, { desc = 'Persistent File History' })

-- Alternative file history method
keymap('n', '<leader>fh', function()
    -- This approach uses a different method to access file history
    local builtin = require('telescope.builtin')
    builtin.find_files({
        no_ignore = true,
        hidden = true,
        sorter = require('telescope.sorters').get_fuzzy_file(),
        previewer = true,
        layout_strategy = "horizontal",
        layout_config = {
            width = 0.8,
            preview_width = 0.5,
            prompt_position = "bottom",
        },
    })
end, { desc = 'Find All Files (History Alternative)' })

-- Telescope With Last Yanked Text
keymap('n', '<leader>fg', function()
    -- Ensure we're in normal mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)

    local search_term = vim.fn.getreg('"') -- Get the contents of the unnamed register
    require('telescope.builtin').live_grep({
        default_text = search_term,        -- Use the last yanked text as the default search term
        additional_args = function()
            return { "--glob", "!*.lock" } -- Exclude .lock files
        end
    })
end, { desc = 'Live Grep with Last Yanked Text' })


-- Moving Text
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted block down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted block up" })

-- Save and Quit Files
vim.keymap.set("n", "<leader>ww", ":w<CR>")
vim.keymap.set("n", "<leader>wq", ":wq<CR>")
vim.keymap.set("n", "<leader>we", ":w<CR>:Oil<CR>")


-- Clipboard
keymap("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- Indentation
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Terminal Keymaps
keymap("n", "<leader>tt", "<cmd>ToggleTerm size=80 direction=vertical<CR>", { desc = "Open vertical terminal" })
keymap("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Function to get current directory (file or netrw)
local function get_current_dir()
    if vim.bo.filetype == "netrw" then
        -- Get the actual netrw directory
        return vim.b.netrw_curdir or vim.fn.getcwd()
    else
        -- Get directory of current file
        local file_path = vim.fn.expand("%:p")
        return vim.fn.fnamemodify(file_path, ":h")
    end
end

-- Terminal setup with state management
local Terminal = require("toggleterm.terminal").Terminal
local lastTerminal = nil -- Track the last opened terminal

-- Terminal manager to handle closing previous terminals
local function toggle_terminal(terminal)
    -- Close the last terminal if it exists and is different
    if lastTerminal and lastTerminal ~= terminal and lastTerminal:is_open() then
        lastTerminal:close()
    end
    
    -- Toggle the new terminal and make it the last one
    terminal:toggle()
    lastTerminal = terminal
end

-- Get size from the tt mapping
local vertical_size = 120 -- Larger fixed size in columns
local horizontal_size = 15

-- Fixed position terminals (right and bottom only)
local term_right = Terminal:new({ 
    direction = "vertical", 
    size = vertical_size, 
    cmd = vim.o.shell, 
    count = 1 -- Same count as bottom terminal
})

local term_bottom = Terminal:new({ 
    direction = "horizontal", 
    size = horizontal_size, 
    cmd = vim.o.shell, 
    count = 1 -- Same count as right terminal
})

-- Store terminals by path
local path_terminals = {
    vertical = {}, -- Store vertical terminals by path
    horizontal = {} -- Store horizontal terminals by path
}

-- Get next available terminal ID (starting from 10 to avoid conflicts)
local next_terminal_id = 10

-- Terminal keybindings - simplified to right and bottom only
keymap("n", "<leader>tl", function() 
    -- Ensure size is reset before toggling
    term_right.size = vertical_size
    toggle_terminal(term_right) 
end, { desc = "Toggle right terminal" })

keymap("n", "<leader>tj", function() 
    toggle_terminal(term_bottom) 
end, { desc = "Toggle bottom terminal" })

-- Context-aware terminals (these open in current directory)
keymap("n", "<leader>to", function()
    local current_dir = get_current_dir()
    
    -- Check if we already have a terminal for this path
    if not path_terminals.vertical[current_dir] then
        -- Create a new terminal with unique ID for this directory
        local terminal_id = next_terminal_id
        next_terminal_id = next_terminal_id + 1
        
        path_terminals.vertical[current_dir] = Terminal:new({
            cmd = vim.o.shell,
            dir = current_dir,
            direction = "vertical",
            size = vertical_size,
            count = terminal_id -- Use the same ID for both vertical and horizontal
        })
        
        -- Create the horizontal counterpart with the same ID if it doesn't exist
        if not path_terminals.horizontal[current_dir] then
            path_terminals.horizontal[current_dir] = Terminal:new({
                cmd = vim.o.shell,
                dir = current_dir,
                direction = "horizontal",
                size = horizontal_size,
                count = terminal_id -- Same ID as vertical for shared history
            })
        end
    end
    
    -- Toggle the terminal for this path
    toggle_terminal(path_terminals.vertical[current_dir])
end, { desc = "Open right terminal in current directory" })

keymap("n", "<leader>tu", function()
    local current_dir = get_current_dir()
    
    -- Check if we already have a terminal for this path
    if not path_terminals.horizontal[current_dir] then
        -- Create a new terminal with unique ID for this directory
        local terminal_id = next_terminal_id
        next_terminal_id = next_terminal_id + 1
        
        path_terminals.horizontal[current_dir] = Terminal:new({
            cmd = vim.o.shell,
            dir = current_dir,
            direction = "horizontal",
            size = horizontal_size,
            count = terminal_id -- Use the same ID for both horizontal and vertical
        })
        
        -- Create the vertical counterpart with the same ID if it doesn't exist
        if not path_terminals.vertical[current_dir] then
            path_terminals.vertical[current_dir] = Terminal:new({
                cmd = vim.o.shell,
                dir = current_dir,
                direction = "vertical",
                size = vertical_size,
                count = terminal_id -- Same ID as horizontal for shared history
            })
        end
    end
    
    -- Toggle the terminal for this path
    toggle_terminal(path_terminals.horizontal[current_dir])
end, { desc = "Open bottom terminal in current directory" })

-- LSP Keybindings
keymap("n", "<leader>gd", vim.lsp.buf.definition, opts)       -- Go to definition
keymap("n", "<leader>gr", vim.lsp.buf.references, opts)       -- Show references
keymap("n", "<leader>gh", vim.lsp.buf.hover, opts)
keymap("n", "<leader>gt", vim.lsp.buf.type_definition, opts)  -- Show type definition
keymap("n", "<leader>gs", vim.lsp.buf.workspace_symbol, opts) -- List workspace symbols
keymap("n", "<leader>gj", vim.diagnostic.open_float, opts)    -- Show diagnostics in a floating window

-- Ruff Linting
vim.keymap.set("n", "<leader>gl", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format with LSP (Ruff)" })

-- Format Json
vim.keymap.set("n", "<leader>lf", function()
    vim.cmd([[%!jq .]])
end, { desc = "Format JSON using jq" })

-- Surround visual selection with characters (I made this. Hasn't failed so far)
keymap("x", "<leader>\"", [[<Esc>`>a"<Esc>`<i"<Esc>]], { desc = "Surround with double quotes" })
keymap("x", "<leader>'", [[<Esc>`>a'<Esc>`<i'<Esc>]], { desc = "Surround with single quotes" })
keymap("x", "<leader>(", [[<Esc>`>a)<Esc>`<i(<Esc>]], { desc = "Surround with parentheses" })
keymap("x", "<leader>{", [[<Esc>`>a}<Esc>`<i{<Esc>]], { desc = "Surround with curly braces" })
keymap("x", "<leader>[", [[<Esc>`>a]<Esc>`<i[<Esc>]], { desc = "Surround with square brackets" })

-- Window Movement
function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

Map("n", "<leader>wh", "<C-w>hzz")
Map("n", "<leader>wj", "<C-w>jzz")
Map("n", "<leader>wk", "<C-w>kzz")
Map("n", "<leader>wl", "<C-w>lzz")

-- Ctrl+s + h/j/k/l to move window focus
keymap("n", "<C-s>h", "<C-w>h", { desc = "Window left" })
keymap("n", "<C-s>j", "<C-w>j", { desc = "Window down" })
keymap("n", "<C-s>k", "<C-w>k", { desc = "Window up" })
keymap("n", "<C-s>l", "<C-w>l", { desc = "Window right" })

-- Teleport (opens splits to the right)
vim.keymap.set("n", "<leader>vk", ":belowright vnew /Users/jacksonfaulkner/.config/nvim/lua/config/keymaps.lua<CR>")
vim.keymap.set("n", "<leader>vg", ":belowright vnew /Users/jfaulkne/Desktop/Beeps_and_Bops/Github-Repos/<CR>")
vim.keymap.set("n", "<leader>vs",
    ":belowright vnew /Users/jfaulkne/Desktop/Beeps_and_Bops/Github-Repos/samsung-media<CR>")
vim.keymap.set("n", "<leader>vn", ":belowright vnew /Users/jacksonfaulkner/.config/nvim/<CR>")
vim.keymap.set("n", "<leader>vs", ":belowright vsplit<CR>")

-- Ruff: Fix all auto-fixable issues
vim.keymap.set("n", "<leader>gf", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.fixAll.ruff" } },
    apply = true,
  })
end, { desc = "Ruff: Fix all auto-fixable issues (no prompt)" })

-- Manual SQL linting
vim.keymap.set("n", "<leader>aj", function()
  require("lint").try_lint()
end, { desc = "Run linter manually" })

-- Middle Screen Movement

-- zz (center screen after half-page scrolling)
keymap({"n", "v"}, "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
keymap({"n", "v"}, "<C-u>", "<C-u>zz", { desc = "Half page up and center" })
keymap({"n", "v"}, "n", "nzz", { desc = "Next search result and center" })
keymap({"n", "v"}, "N", "Nzz", { desc = "Previous search result and center" })
keymap({"n", "v"}, "G", "Gzz", { desc = "Go to end and center" })
keymap({"n", "v"}, "{", "{zz", { desc = "Previous paragraph and center" })
keymap({"n", "v"}, "}", "}zz", { desc = "Next paragraph and center" })

-- When pressing enter on a search, center the screen
keymap({"n", "v"}, "<CR>", function()
    -- If we're in command mode or have a search pattern, center after enter
    if vim.fn.getcmdtype() == "/" or vim.fn.getcmdtype() == "?" then
        return "<CR>zz"
    else
        return "<CR>"
    end
end, { expr = true, desc = "Enter and center on search" })

keymap({ "n", "v" }, "j", "jzz")
keymap({"n", "v"}, "k", "kzz")


-- Avante.nvim keymaps (AI assistant, see https://github.com/yetone/avante.nvim)
keymap('n', '<leader>sa', function() vim.cmd('AvanteAsk') end, { desc = 'Avante: Show Sidebar' })
keymap('n', '<leader>sj', function() vim.cmd('AvanteToggle') end, { desc = 'Avante: Toggle Sidebar' })
keymap('n', '<leader>sr', function() vim.cmd('AvanteRefresh') end, { desc = 'Avante: Refresh Sidebar' })
keymap('n', '<leader>sk', function() vim.cmd('AvanteFocus') end, { desc = 'Avante: Focus Sidebar' })
keymap('n', '<leader>se', function() vim.cmd('AvanteEdit') end, { desc = 'Avante: Edit Selected Blocks' })
keymap('n', '<leader>sS', function() vim.cmd('AvanteStop') end, { desc = 'Avante: Stop Current AI Request' })
keymap('n', '<leader>sh', function() vim.cmd('AvanteHistory') end, { desc = 'Avante: Chat History' })

vim.keymap.set("n", "<leader>ws", function()
    vim.fn.system({"open", "-a", "Cursor"})
end, { desc = "Open Cursor app via Unix command" })
