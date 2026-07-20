-- =============================================================================
-- KEYMAPS
-- =============================================================================
-- Custom keybindings. The general pattern is:
--   <leader> = Space (primary modifier for custom actions)
--   g = "go to" actions
--   ] and [ = next/previous navigation
--
-- Use :map to see all mappings, :verbose map <key> to see where a key was set

local keymap = vim.keymap.set

keymap("n", "<leader>th", ":!tmux split-window -h<CR>", { desc = "Tmux split horizontal" })
keymap("n", "<leader>tv", ":!tmux split-window -v<CR>", { desc = "Tmux split vertical" })

-- -----------------------------------------------------------------------------
-- ESCAPE ALTERNATIVES
-- -----------------------------------------------------------------------------
-- For those who want to stay on home row
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- -----------------------------------------------------------------------------
-- WINDOW NAVIGATION
-- -----------------------------------------------------------------------------
-- Note: Window navigation is handled by vim-tmux-navigator plugin
-- which provides seamless navigation between Neovim splits and tmux panes with Ctrl+hjkl
-- Don't add manual keymaps here as they would override the plugin's tmux-aware navigation

-- -----------------------------------------------------------------------------
-- WINDOW RESIZING
-- -----------------------------------------------------------------------------
-- Resize splits with Ctrl+Arrow keys
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- -----------------------------------------------------------------------------
-- BUFFER NAVIGATION
-- -----------------------------------------------------------------------------
-- Quick buffer switching with Shift+H and Shift+L
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
-- Note: <leader>bd and <leader>bD are handled by snacks.nvim (bufdelete)

-- -----------------------------------------------------------------------------
-- LINE MOVEMENT
-- -----------------------------------------------------------------------------
-- Move selected lines up/down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- -----------------------------------------------------------------------------
-- CENTERED NAVIGATION
-- -----------------------------------------------------------------------------
-- Keep cursor centered when scrolling and searching
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
keymap("n", "n", "nzzzv", { desc = "Next search (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search (centered)" })

-- -----------------------------------------------------------------------------
-- SEARCH
-- -----------------------------------------------------------------------------
-- Clear search highlighting with Escape
keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })

-- -----------------------------------------------------------------------------
-- CLIPBOARD
-- -----------------------------------------------------------------------------
-- Paste without overwriting register (useful when replacing selected text)
keymap("x", "<leader>p", '"_dP', { desc = "Paste without overwriting" })

-- -----------------------------------------------------------------------------
-- SAVE & QUIT
-- -----------------------------------------------------------------------------
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<C-s>", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit all" })

-- -----------------------------------------------------------------------------
-- TROUBLE (DIAGNOSTICS)
-- -----------------------------------------------------------------------------
keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
keymap("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix (Trouble)" })

-- -----------------------------------------------------------------------------
-- GIT
-- -----------------------------------------------------------------------------
keymap("n", "<leader>gg", ":Git<CR>", { desc = "Git status (fugitive)" })
keymap("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
keymap("n", "<leader>gl", ":Git pull<CR>", { desc = "Git pull" })
keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
