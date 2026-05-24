-- Custom tabline showing open buffers (replaces bufferline.nvim).
-- Hidden by default (showtabline = 0). Toggle with <leader>bt (see lua/config/keymaps.lua).

local function render()
  local s = ""
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
      if name == "" then name = "[No Name]" end
      local modified = vim.bo[buf].modified and " +" or ""
      if buf == current then
        s = s .. "%#TabLineSel# " .. name .. modified .. " %#TabLine#"
      else
        s = s .. "%#TabLine# " .. name .. modified .. " "
      end
    end
  end
  return s
end

_G.Tabline = render
vim.opt.showtabline = 0
vim.o.tabline = "%!v:lua.Tabline()"
