# Neovim Keybindings Reference

> **Leader key**: `Space`
>
> **Mode legend**: `n` = Normal · `i` = Insert · `v` = Visual · `x` = Visual (no select)

---

## Escape Alternatives

| Key | Mode | Description |
|-----|------|-------------|
| `jk` | i | Exit insert mode |
| `jj` | i | Exit insert mode |

---

## Window Navigation

> Seamless navigation between Neovim splits and tmux panes via **vim-tmux-navigator**.

| Key | Mode | Description |
|-----|------|-------------|
| `Ctrl+h` | n | Navigate left |
| `Ctrl+j` | n | Navigate down |
| `Ctrl+k` | n | Navigate up |
| `Ctrl+l` | n | Navigate right |

---

## Window Resizing

| Key | Mode | Description |
|-----|------|-------------|
| `Ctrl+↑` | n | Increase window height |
| `Ctrl+↓` | n | Decrease window height |
| `Ctrl+←` | n | Decrease window width |
| `Ctrl+→` | n | Increase window width |

---

## Buffer Management

| Key | Mode | Description |
|-----|------|-------------|
| `Shift+L` | n | Next buffer |
| `Shift+H` | n | Previous buffer |
| `<leader>bd` | n | Delete buffer |
| `<leader>bD` | n | Delete all buffers |

---

## Save & Quit

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>w` | n | Save file |
| `Ctrl+s` | n | Save file |
| `<leader>q` | n | Quit |
| `<leader>Q` | n | Force quit all |

---

## File Explorer (nvim-tree)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>e` | n | Toggle file explorer |
| `<leader>o` | n | Focus file explorer |

> **Inside nvim-tree**: `j`/`k` to move · `Enter` to open · `a` to create · `d` to delete

---

## Terminal

| Key | Mode | Description |
|-----|------|-------------|
| `Ctrl+\` | n | Toggle floating terminal |
| `<leader>th` | n | Tmux split horizontal |
| `<leader>tv` | n | Tmux split vertical |

---

## Fuzzy Finder (Snacks Picker)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ff` | n | Find files |
| `Ctrl+p` | n | Find files |
| `<leader>fg` | n | Live grep |
| `<leader>fw` | n | Grep word under cursor |
| `<leader>fb` | n | Buffers |
| `<leader>fr` | n | Recent files |
| `<leader>fh` | n | Help tags |
| `<leader>fk` | n | Keymaps |
| `<leader>f:` | n | Command history |
| `<leader>fd` | n | Diagnostics |
| `<leader>fs` | n | Git status |
| `<leader>fc` | n | Git commits |
| `<leader>ft` | n | Find todos |

> **Inside picker**: `Ctrl+j`/`Ctrl+k` to navigate results

---

## LSP (Language Server Protocol)

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gr` | n | Find references |
| `gi` | n | Go to implementation |
| `gy` | n | Go to type definition |
| `gD` | n | Go to declaration |
| `K` | n | Hover documentation |
| `<leader>k` | n | Signature help |
| `<leader>rn` | n | Rename symbol |
| `<leader>ca` | n | Code action |
| `<leader>F` | n | Format file |
| `<leader>ss` | n | LSP symbols (document) |
| `<leader>sS` | n | LSP symbols (workspace) |

---

## Git

### vim-fugitive

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gg` | n | Git status |
| `<leader>gp` | n | Git push |
| `<leader>gl` | n | Git pull |
| `<leader>gb` | n | Git blame |
| `<leader>gB` | n | Open in browser (gitbrowse) |
| `<leader>gf` | n | File history (git log) |
| `<leader>lg` | n | Lazygit |

### gitsigns (hunk operations)

| Key | Mode | Description |
|-----|------|-------------|
| `]h` | n | Next hunk |
| `[h` | n | Previous hunk |
| `<leader>hs` | n | Stage hunk |
| `<leader>hr` | n | Reset hunk |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame line |

---

## Diagnostics & Symbols (Trouble)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>xx` | n | Diagnostics (all) |
| `<leader>xX` | n | Diagnostics (current buffer) |
| `<leader>cs` | n | Symbols |
| `<leader>xq` | n | Quickfix list |

---

## Toggle Options

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>us` | n | Toggle spelling |
| `<leader>uw` | n | Toggle word wrap |
| `<leader>ul` | n | Toggle line numbers |
| `<leader>uL` | n | Toggle relative line numbers |
| `<leader>ud` | n | Toggle diagnostics |
| `<leader>uT` | n | Toggle treesitter |
| `<leader>uh` | n | Toggle inlay hints |
| `<leader>un` | n | Notification history |
| `<leader>uN` | n | Dismiss all notifications |

---

## Zen Mode

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>z` | n | Toggle Zen mode |
| `<leader>Z` | n | Toggle Zoom |

---

## Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `Ctrl+d` | n | Scroll down (cursor centered) |
| `Ctrl+u` | n | Scroll up (cursor centered) |
| `n` | n | Next search result (centered) |
| `N` | n | Previous search result (centered) |
| `<Esc>` | n | Clear search highlight |
| `]]` | n | Next word occurrence |
| `[[` | n | Previous word occurrence |

---

## Editing

| Key | Mode | Description |
|-----|------|-------------|
| `J` | v | Move selected lines down |
| `K` | v | Move selected lines up |
| `<leader>p` | x | Paste without overwriting register |
| `gcc` | n | Toggle line comment |
| `gbc` | n | Toggle block comment |
| `gc{motion}` | n | Comment a region |

### nvim-surround

| Key | Example | Description |
|-----|---------|-------------|
| `cs{a}{b}` | `cs"'` | Change surrounding `"` to `'` |
| `ds{char}` | `ds"` | Delete surrounding `"` |
| `ysiw{char}` | `ysiw"` | Add `"` around word |

---

## Completion (nvim-cmp)

| Key | Mode | Description |
|-----|------|-------------|
| `Ctrl+Space` | i | Trigger completion |
| `Tab` | i/s | Next completion / expand snippet |
| `Shift+Tab` | i/s | Previous completion |
| `Enter` | i | Confirm selection |
| `Ctrl+e` | i | Close completion menu |
| `Ctrl+b` | i | Scroll docs up |
| `Ctrl+f` | i | Scroll docs down |

---

## User Commands

| Command | Description |
|---------|-------------|
| `:W` | Format and save |
| `:ReloadConfig` | Reload Neovim config |
| `:Projects` | Browse `~/Documents/git` projects |
| `:Mason` | Open Mason (LSP/tool installer) |
| `:Lazy` | Open Lazy (plugin manager) |
