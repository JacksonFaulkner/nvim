return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'FzfLua',
  opts = {
    'telescope',
    defaults = { resume = true },
    keymap = {
      fzf = {
        ['alt-j'] = 'down',
        ['alt-k'] = 'up',
      },
    },
    winopts = {
      height = 0.85,
      width = 0.85,
      border = 'none',
      preview = {
        layout = 'horizontal',
        horizontal = 'right:50%',
        border = 'rounded',
        title = ' Preview ',
        title_pos = 'left',
        scrollbar = false,
      },
    },
    fzf_opts = {
      ['--pointer'] = '▶',
      ['--prompt'] = '> ',
      ['--list-border'] = 'rounded',
      ['--list-label'] = ' Results ',
      ['--input-border'] = 'rounded',
      ['--input-label'] = ' Search ',
      ['--no-separator'] = true,
    },
    fzf_colors = {
      ['bg']      = '#282a36',
      ['bg+']     = '#44475a',
      ['fg']      = '#f8f8f2',
      ['fg+']     = '#f8f8f2',
      ['hl']      = '#bd93f9',
      ['hl+']     = '#ff79c6',
      ['info']    = '#6272a4',
      ['prompt']  = '#8be9fd',
      ['pointer'] = '#ff79c6',
      ['marker']  = '#50fa7b',
      ['spinner'] = '#bd93f9',
      ['header']  = '#6272a4',
      ['border']  = '#6272a4',
    },
    files = {
      cwd_prompt = false,
      git_icons = false,
      file_icons = 'mini',
    },
    grep = {
      git_icons = false,
      file_icons = 'mini',
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096",
    },
    previewers = {
      builtin = {
        syntax_limit_b = 102400,
      },
    },
  },
}
