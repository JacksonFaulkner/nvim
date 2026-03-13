# Keymaps Reference (test diff - delete this parenthetical)

Leader key: `Space`

## General

| Keys         | Mode | Description                         |
| ------------ | ---- | ----------------------------------- |
| `<leader>wo` | n    | Toggle word wrap with 80 char guide |
| `<leader>if` | n    | Insert Python `__main__` guard      |

## File Operations

| Keys         | Mode | Description                     |
| ------------ | ---- | ------------------------------- |
| `<leader>ww` | n    | Save file                       |
| `<leader>wq` | n    | Save and quit                   |
| `<leader>we` | n    | Save and open Oil               |
| `<leader>ga` | n    | Save (+ ESLint for JS/TS files) |

## LazyGit

| Keys         | Mode | Description                     |
| ------------ | ---- | ------------------------------- |
| `<leader>gg` | n    | Open LazyGit                    |
| `<leader>to` | n    | Open LazyGit in new WezTerm tab |

## Telescope - Find Files

| Keys           | Mode | Description                                        |
| -------------- | ---- | -------------------------------------------------- |
| `<leader>ff`   | n    | Find files (current dir)                           |
| `<leader>fg`   | n    | Grep (current dir)                                 |
| `<leader>fjf`  | n    | Find files (1 dir up)                              |
| `<leader>fjg`  | n    | Grep (1 dir up)                                    |
| `<leader>fjjf` | n    | Find files (2 dirs up)                             |
| `<leader>fjjg` | n    | Grep (2 dirs up)                                   |
| ...            | n    | Pattern continues: add `j` per level up (up to 20) |
| `<leader>fw`   | n    | Find files (CWD)                                   |
| `<leader>fw.`  | n    | Grep (CWD)                                         |
| `<leader>fG`   | n    | Grep project root                                  |
| `<leader>fW`   | n    | Grep whole word under cursor                       |
| `<leader>fb`   | n    | Find buffers                                       |
| `<leader>fr`   | n    | Find recent files (oldfiles)                       |
| `<leader>fe`   | n    | Find recent buffers                                |
| `<leader>fj`   | n    | Persistent file history (custom)                   |
| `<leader>fh`   | n    | Find all files (hidden + ignored)                  |

### Telescope Insert Mode

| Keys    | Mode | Description                            |
| ------- | ---- | -------------------------------------- |
| `<C-u>` | i    | Disabled (default scroll up removed)   |
| `<C-d>` | i    | Disabled (default scroll down removed) |

## Moving Text

| Keys | Mode | Description                 |
| ---- | ---- | --------------------------- |
| `J`  | v    | Move highlighted block down |
| `K`  | v    | Move highlighted block up   |

## Clipboard

| Keys        | Mode | Description              |
| ----------- | ---- | ------------------------ |
| `<leader>y` | n, v | Yank to system clipboard |

## Indentation

| Keys | Mode | Description                         |
| ---- | ---- | ----------------------------------- |
| `<`  | v    | Indent left (stays in visual mode)  |
| `>`  | v    | Indent right (stays in visual mode) |

## Surround (Visual Selection)

| Keys        | Mode | Description                   |
| ----------- | ---- | ----------------------------- |
| `<leader>"` | x    | Surround with double quotes   |
| `<leader>'` | x    | Surround with single quotes   |
| `<leader>(` | x    | Surround with parentheses     |
| `<leader>{` | x    | Surround with curly braces    |
| `<leader>[` | x    | Surround with square brackets |

## Variable Formatting

| Keys         | Mode | Description                         |
| ------------ | ---- | ----------------------------------- |
| `<leader>sv` | v    | Align assignment block in selection |

## LSP

| Keys         | Mode | Description                         |
| ------------ | ---- | ----------------------------------- |
| `<leader>gd` | n    | Go to definition                    |
| `<leader>gr` | n    | Show references                     |
| `<leader>ge` | n    | Show references (alias)             |
| `<leader>gh` | n    | Hover documentation                 |
| `<leader>gt` | n    | Show type definition                |
| `<leader>gs` | n    | List workspace symbols              |
| `<leader>gj` | n    | Show diagnostics in floating window |
| `<leader>gl` | n    | Format with LSP                     |
| `<leader>gy` | n    | Ruff fixAll (unused imports, etc.)  |
| `<leader>gf` | n    | Ruff: Fix all auto-fixable issues   |
| `<leader>gi` | n    | Run ESLint in popup                 |

## Formatting

| Keys         | Mode | Description            |
| ------------ | ---- | ---------------------- |
| `<leader>tf` | n    | Format Terraform files |
| `<leader>lf` | n    | Format JSON using jq   |

## Terminal

| Keys         | Mode | Description                             |
| ------------ | ---- | --------------------------------------- |
| `<C-\>`      | n    | Toggle terminal (ToggleTerm)            |
| `<leader>tt` | n    | Open vertical terminal (80 cols)        |
| `<leader>tl` | n    | Open terminal right (vertical, 80 cols) |
| `<Esc>`      | t    | Exit terminal mode                      |
| `jk`         | t    | Exit terminal mode                      |
| `<C-\>`      | t    | Exit terminal mode (debugmaster)        |

## Window Movement

| Keys         | Mode | Description          |
| ------------ | ---- | -------------------- |
| `<leader>wh` | n    | Move to window left  |
| `<leader>wj` | n    | Move to window down  |
| `<leader>wk` | n    | Move to window up    |
| `<leader>wl` | n    | Move to window right |
| `<C-s>h`     | n    | Move to window left  |
| `<C-s>j`     | n    | Move to window down  |
| `<C-s>k`     | n    | Move to window up    |
| `<C-s>l`     | n    | Move to window right |

## Teleport (Quick Open Splits)

| Keys         | Mode | Description                            |
| ------------ | ---- | -------------------------------------- |
| `<leader>vk` | n    | Open keymaps.lua in right split        |
| `<leader>vg` | n    | Open github_repos dir in right split   |
| `<leader>vn` | n    | Open nvim config dir in right split    |
| `<leader>vs` | n    | Open vertical split                    |
| `<leader>vl` | n    | Resize window left, open WezTerm right |

## Misc

| Keys         | Mode | Description     |
| ------------ | ---- | --------------- |
| `<leader>ws` | n    | Open Cursor app |

## Completion (nvim-cmp)

| Keys        | Mode | Description                            |
| ----------- | ---- | -------------------------------------- |
| `<C-j>`     | i, s | Next completion item / scroll docs     |
| `<C-k>`     | i, s | Previous completion item / scroll docs |
| `<C-Space>` | i    | Trigger completion                     |
| `<C-e>`     | i    | Abort completion                       |
| `<CR>`      | i    | Confirm selected item                  |
| `<Tab>`     | i, s | Next item / expand snippet / jump      |
| `<S-Tab>`   | i, s | Previous item / jump back in snippet   |

## Claude Code

| Keys         | Mode | Description                            |
| ------------ | ---- | -------------------------------------- |
| `<leader>ac` | n    | Toggle Claude                          |
| `<leader>af` | n    | Focus Claude                           |
| `<leader>ar` | n    | Resume Claude                          |
| `<leader>aC` | n    | Continue Claude                        |
| `<leader>am` | n    | Select Claude model                    |
| `<leader>ab` | n    | Add current buffer to Claude           |
| `<leader>as` | v    | Send selection to Claude               |
| `<leader>as` | n    | Add file from tree (in file explorers) |
| `<leader>aa` | n    | Accept diff                            |
| `<leader>ad` | n    | Deny diff                              |
| `<leader>aS` | n    | Claude status                          |
| `<C-,>`      | t    | Hide Claude window                     |
| `<C-g>`      | t    | Hide Claude window                     |

## Debug (debugmaster.nvim)

| Keys        | Mode | Description       |
| ----------- | ---- | ----------------- |
| `<leader>d` | n, v | Toggle debug mode |

## Treesitter Text Objects

### Select

| Keys | Mode | Description              |
| ---- | ---- | ------------------------ |
| `af` | o, x | Select outer function    |
| `if` | o, x | Select inner function    |
| `ai` | o, x | Select outer conditional |
| `ii` | o, x | Select inner conditional |
| `ak` | o, x | Select outer class       |
| `ik` | o, x | Select inner class       |
| `al` | o, x | Select outer loop        |
| `il` | o, x | Select inner loop        |

### Go to Next (Start)

| Keys         | Mode | Description            |
| ------------ | ---- | ---------------------- |
| `<leader>tF` | n    | Next function start    |
| `<leader>tC` | n    | Next class start       |
| `<leader>t?` | n    | Next comment start     |
| `<leader>tI` | n    | Next conditional start |
| `<leader>tL` | n    | Next loop start        |

### Go to Next (End)

| Keys         | Mode | Description          |
| ------------ | ---- | -------------------- |
| `<leader>tf` | n    | Next function end    |
| `<leader>tc` | n    | Next class end       |
| `<leader>t/` | n    | Next comment end     |
| `<leader>ti` | n    | Next conditional end |
| `<leader>tl` | n    | Next loop end        |

### Go to Previous (Start)

| Keys         | Mode | Description                |
| ------------ | ---- | -------------------------- |
| `<leader>sf` | n    | Previous function start    |
| `<leader>sc` | n    | Previous class start       |
| `<leader>s/` | n    | Previous comment start     |
| `<leader>si` | n    | Previous conditional start |
| `<leader>sl` | n    | Previous loop start        |

### Go to Previous (End)

| Keys         | Mode | Description              |
| ------------ | ---- | ------------------------ |
| `<leader>sF` | n    | Previous function end    |
| `<leader>sC` | n    | Previous class end       |
| `<leader>s?` | n    | Previous comment end     |
| `<leader>sI` | n    | Previous conditional end |
| `<leader>sL` | n    | Previous loop end        |

<!-- Test diff: you can accept or deny this line -->
