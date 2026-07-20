-- =============================================================================
-- AUTOCOMMANDS
-- =============================================================================
-- Autocommands run automatically based on events
-- Use :autocmd to see all autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- -----------------------------------------------------------------------------
-- HIGHLIGHT ON YANK
-- -----------------------------------------------------------------------------
-- Briefly highlight yanked text
autocmd("TextYankPost", {
	group = augroup("HighlightYank", {}),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- -----------------------------------------------------------------------------
-- TRAILING WHITESPACE
-- -----------------------------------------------------------------------------
-- Remove trailing whitespace on save
autocmd("BufWritePre", {
	group = augroup("TrimWhitespace", {}),
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- -----------------------------------------------------------------------------
-- RESTORE CURSOR POSITION
-- -----------------------------------------------------------------------------
-- Return to last edit position when opening files
autocmd("BufReadPost", {
	group = augroup("LastEditPosition", {}),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- -----------------------------------------------------------------------------
-- AUTO-RESIZE SPLITS
-- -----------------------------------------------------------------------------
-- When resizing terminal, equalize splits
autocmd("VimResized", {
	group = augroup("ResizeSplits", {}),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- -----------------------------------------------------------------------------
-- FILETYPE-SPECIFIC SETTINGS
-- -----------------------------------------------------------------------------

-- Go: Use tabs (not spaces), width of 4
autocmd("FileType", {
	group = augroup("FileTypeSettings", {}),
	pattern = { "go" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = false -- Go uses tabs!
	end,
})

-- Python: 4-space indentation (PEP 8)
autocmd("FileType", {
	group = augroup("PythonSettings", {}),
	pattern = { "python" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})

-- C/C++: 4-space indentation
autocmd("FileType", {
	group = augroup("CSettings", {}),
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})

-- Quickfix: Close with 'q'
autocmd("FileType", {
	group = augroup("CloseQuickfix", {}),
	pattern = { "qf" },
	callback = function()
		vim.keymap.set("n", "q", ":close<CR>", { buffer = true, silent = true })
	end,
})

-- -----------------------------------------------------------------------------
-- LSP KEYMAPS
-- -----------------------------------------------------------------------------
-- These are applied when an LSP server attaches to a buffer
-- Note: gd, gr, gi, gy are handled by snacks.picker in lua/plugins/ui.lua
autocmd("LspAttach", {
	group = augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }

		-- Navigation (gd, gr, gi, gy handled by snacks.picker in plugin config)
		vim.keymap.set(
			"n",
			"gD",
			vim.lsp.buf.declaration,
			vim.tbl_extend("force", opts, { desc = "Go to declaration" })
		)

		-- Documentation
		vim.keymap.set(
			"n",
			"K",
			vim.lsp.buf.hover,
			vim.tbl_extend("force", opts, { desc = "Hover documentation" })
		)
		vim.keymap.set(
			"n",
			"<leader>k",
			vim.lsp.buf.signature_help,
			vim.tbl_extend("force", opts, { desc = "Signature help" })
		)

		-- Refactoring
		vim.keymap.set(
			"n",
			"<leader>rn",
			vim.lsp.buf.rename,
			vim.tbl_extend("force", opts, { desc = "Rename symbol" })
		)
		vim.keymap.set(
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code action" })
		)

		-- Formatting
		vim.keymap.set("n", "<leader>F", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, vim.tbl_extend("force", opts, { desc = "Format file" }))
	end,
})

-- =============================================================================
-- USER COMMANDS
-- =============================================================================
-- Custom commands you can run with :CommandName

-- -----------------------------------------------------------------------------
-- :Projects - Browse your git projects directory
-- -----------------------------------------------------------------------------
-- Note: Also available via dashboard "p" key
vim.api.nvim_create_user_command("Projects", function()
	Snacks.picker.files({ cwd = "~/Documents/git" })
end, { desc = "Browse projects" })

-- -----------------------------------------------------------------------------
-- :W - Format and save
-- -----------------------------------------------------------------------------
vim.api.nvim_create_user_command("W", function()
	require("conform").format({ async = false, lsp_fallback = true })
	vim.cmd("write")
end, { desc = "Format and save" })

-- -----------------------------------------------------------------------------
-- :ReloadConfig - Reload the config
-- -----------------------------------------------------------------------------
vim.api.nvim_create_user_command("ReloadConfig", function()
	for name, _ in pairs(package.loaded) do
		if name:match("^config%.") or name:match("^plugins%.") then
			package.loaded[name] = nil
		end
	end
	vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
	print("Config reloaded!")
end, { desc = "Reload nvim config" })
