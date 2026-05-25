return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup()
    local parsers = {
      'python', 'lua', 'bash', 'json', 'yaml', 'toml',
      'javascript', 'typescript', 'tsx', 'html', 'css',
      'markdown', 'markdown_inline', 'terraform', 'hcl',
      'go', 'rust', 'vim', 'vimdoc', 'query', 'regex', 'sql',
    }
    require('nvim-treesitter').install(parsers)
  end,
}
