return {
	-- ===========================================================================
	-- DIAGNOSTICS PANEL: trouble.nvim
	-- ===========================================================================
	-- A pretty list for diagnostics, quickfix, and location lists
	-- Toggle with <leader>xx
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" }, -- Lazy-load on command
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({})
		end,
	},

	-- ===========================================================================
	-- TODO COMMENTS: todo-comments.nvim
	-- ===========================================================================
	-- Highlight TODO, FIXME, NOTE, etc. comments
	-- Find all todos with <leader>ft
	{
		"folke/todo-comments.nvim",
		event = "BufReadPost", -- Load after buffer is read
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({})
		end,
	},

	-- ===========================================================================
	-- GO TOOLS: go.nvim
	-- ===========================================================================
	-- Enhanced Go development support
	-- Provides: go test, go run, struct tags, etc.
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		ft = { "go", "gomod" }, -- Only load for Go files
	},

	-- ===========================================================================
	-- AI ASSISTANT: GitHub Copilot (OPTIONAL)
	-- ===========================================================================
	-- AI pair programmer
	-- Comment out these lines if you don't want Copilot
	-- Run :Copilot setup after first install
	{
		"github/copilot.vim",
		event = "InsertEnter",
	},

	-- ===========================================================================
	-- TMUX NAVIGATION: vim-tmux-navigator
	-- ===========================================================================
	-- Seamless Ctrl+hjkl navigation between vim splits and tmux panes
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate Left (vim/tmux)" },
			{ "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate Down (vim/tmux)" },
			{ "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate Up (vim/tmux)" },
			{ "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate Right (vim/tmux)" },
		},
	},
}
