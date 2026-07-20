-- =============================================================================
-- NEOVIM CONFIGURATION ENTRYPOINT
-- =============================================================================
-- Leader keys must be set before lazy.nvim loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options") -- vim.opt settings
require("config.lazy") -- lazy.nvim bootstrap + plugin loading
require("config.keymaps") -- general keymaps
require("config.autocmds") -- autocommands and user commands
