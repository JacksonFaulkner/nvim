return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  keys = {
    { "<leader>md", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle" },
  },
  build = function()
    vim.fn["mkdp#util#install"]()
    local app_dir = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app"
    vim.fn.system("cd " .. app_dir .. " && npm install mermaid@latest && cp node_modules/mermaid/dist/mermaid.min.js _static/mermaid.min.js")
  end,
}
