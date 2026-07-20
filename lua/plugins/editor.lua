return {
	-- ===========================================================================
	-- FILE EXPLORER: nvim-tree
	-- ===========================================================================
	-- A file explorer tree written in Lua
	-- Toggle with <leader>e, focus with <leader>o
	-- Navigate: j/k to move, Enter to open, a to create, d to delete
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" }, -- Lazy-load on command
		keys = {
			{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
			{ "<leader>o", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
		},
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- Icons for file types
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 35, -- Width of explorer window
				},
				filters = {
					dotfiles = false, -- Show dotfiles (set true to hide)
				},
				git = {
					enable = true, -- Show git status in tree
					ignore = false, -- Don't hide gitignored files
				},
			})
		end,
	},

	-- ===========================================================================
	-- AUTO PAIRS: nvim-autopairs
	-- ===========================================================================
	-- Automatically close brackets, quotes, etc.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter", -- Load when entering insert mode
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true, -- Use treesitter for smarter pairing
			})
		end,
	},

	-- ===========================================================================
	-- COMMENTS: Comment.nvim
	-- ===========================================================================
	-- Smart and powerful comment plugin
	-- gcc to toggle line comment, gbc for block comment
	-- gc{motion} to comment a region
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = function()
			require("Comment").setup()
		end,
	},

	-- ===========================================================================
	-- SURROUND: nvim-surround
	-- ===========================================================================
	-- Add/change/delete surrounding delimiter pairs
	-- cs"' to change " to ', ds" to delete ", ysiw" to add " around word
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- ===========================================================================
	-- KEYBINDING HELPER: which-key.nvim
	-- ===========================================================================
	-- Displays a popup with possible keybindings as you type
	-- Press <leader> and wait to see available options
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({})
		end,
	},

	-- ===========================================================================
	-- TERMINAL: toggleterm.nvim
	-- ===========================================================================
	-- Better terminal management
	-- Toggle with Ctrl+\ (floating terminal)
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = { { [[<C-\>]], desc = "Toggle terminal" } },
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<C-\>]], -- Keybinding to toggle
				direction = "float", -- Floating terminal
				float_opts = {
					border = "curved", -- Rounded border
				},
			})
		end,
	},

	-- ===========================================================================
	-- QUICKFIX ENHANCEMENT: nvim-bqf
	-- ===========================================================================
	-- Better quickfix window with preview and fuzzy search
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf", -- Load when quickfix window opens
	},
}
