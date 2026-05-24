-- General settings
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.tabstop = 2
vim.opt.swapfile = false
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.o.shell = "/bin/zsh"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.hidden = true
vim.opt.sidescrolloff = 8
vim.g.mapleader = " "

-- Shada settings for persistent history
vim.o.shada = "!,'10000,<10000,s100,h"
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("rshada")
  end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("wshada!")
  end,
})

-- JSON folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99
  end,
})

-- Terraform folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99
  end,
})

-- Push current buffer path to tmux pane title
if vim.env.TMUX then
  local home = os.getenv("HOME")

  -- Strip ~/code path down to a useful prefix.
  -- gitlab_repos/github_repos are stripped entirely; other categories kept as prefix.
  local function strip_code_prefix(abs)
    local rel = abs:gsub("^" .. home .. "/code/", "")
    if rel == abs:gsub("^" .. home .. "/", "") then
      -- Not under ~/code, return nil to fall back
      return nil
    end
    local category, rest = rel:match("^([^/]+)/(.+)$")
    if not category then return rel end
    if category == "gitlab_repos" or category == "github_repos" then
      return rest
    else
      return category .. "/" .. rest
    end
  end

  -- Truncate a path to max chars with a 30/70 left/right split around …
  local function truncate(s, max)
    if #s <= max then return s end
    local left = math.floor(max * 0.30)
    local right = max - left - 1 -- … is 1 char
    return s:sub(1, left) .. "…" .. s:sub(-right)
  end

  local function hex_to_ansi(hex)
    if not hex then return "" end
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    if not r then return "" end
    return string.format("\27[38;2;%d;%d;%dm", r, g, b)
  end

  -- Returns plain icon (no color) and colored icon separately
  local function get_icon(fname, is_dir)
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then return "", "" end
    local icon, color
    if is_dir then
      return "󰉋", "\27[38;2;139;233;253m󰉋\27[0m" -- dracula cyan #8BE9FD
    else
      local ext = fname:match("%.([^%.]+)$")
      icon, color = devicons.get_icon_color(fname, ext, { default = true })
      icon = icon or ""
    end
    if icon == "" then return "", "" end
    local ansi = hex_to_ansi(color)
    local colored_icon = ansi ~= "" and (ansi .. icon .. "\27[0m") or icon
    return icon, colored_icon
  end

  local function set_tmux_title()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == "" then return end
    local path, plain_icon, colored_icon
    if bufname:match("^oil://") then
      local dir = bufname:gsub("^oil://", ""):gsub("/$", "")
      local dirname = vim.fn.fnamemodify(dir, ":t")
      plain_icon, colored_icon = get_icon(dirname, true)
      local stripped = strip_code_prefix(dir)
      if stripped then
        local parts = {}
        for p in stripped:gmatch("[^/]+") do parts[#parts + 1] = p end
        if #parts >= 2 then
          path = parts[1] .. "/" .. parts[#parts - 1] .. "/" .. parts[#parts] .. "/"
        else
          path = stripped .. "/"
        end
      else
        path = dirname .. "/"
      end
    else
      local abs = vim.fn.expand("%:p")
      local fname = vim.fn.fnamemodify(abs, ":t")
      plain_icon, colored_icon = get_icon(fname, false)
      local stripped = strip_code_prefix(abs)
      if stripped then
        path = stripped
      else
        local cwd = vim.fn.getcwd()
        local project = vim.fn.fnamemodify(cwd, ":t")
        local rel = vim.fn.fnamemodify(abs, ":~:.")
        path = project .. "/" .. rel
      end
    end
    if path == "" then return end
    path          = truncate(path, 55)
    local plain   = plain_icon ~= "" and (plain_icon .. " " .. path) or path
    local colored = colored_icon ~= "" and (colored_icon .. " " .. path) or path
    -- Use array form to avoid shell mangling ESC bytes
    vim.fn.system({ "tmux", "rename-window", plain })
    vim.fn.system({ "tmux", "set-option", "-w", "@title", colored })
  end
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, { callback = set_tmux_title })
  -- Reset on exit so tmux goes back to auto-rename
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      vim.fn.system({ "tmux", "set-window-option", "automatic-rename", "on" })
      vim.fn.system({ "tmux", "set-option", "-wu", "@title" })
    end,
  })
end

-- Workaround for Neovim 0.12.x crash: `(#set! conceal_lines "")` in the
-- runtime markdown highlights query feeds a nil node into vim.treesitter
-- .get_range -> node:range(true). Guard the nil case so the highlighter
-- doesn't abort. See neovim/neovim#39032, nvim-treesitter/nvim-treesitter#8618.
do
  local ts = vim.treesitter
  local orig_get_range = ts.get_range
  function ts.get_range(node, source, metadata)
    if type(node) == 'table' and node[1] ~= nil then
      node = node[1]
    end
    if node == nil or type(node) ~= 'userdata' then
      if metadata and metadata.range then
        return ts._range.add_bytes(assert(source), metadata.range)
      end
      return { 0, 0, 0, 0, 0, 0 }
    end
    return orig_get_range(node, source, metadata)
  end
end

require("config.lazy")
require("config.keymaps")

require("custom_plugins.bufferline")
require("custom_plugins.stay_centered")
require("custom_plugins.smear_cursor").setup({
  stiffness = 0.5,
  trailing_stiffness = 0.5,
  never_draw_over_target = true,
})
