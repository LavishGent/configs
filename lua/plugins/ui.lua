return {
	-- ===========================================================================
	-- COLORSCHEME: Catppuccin
	-- ===========================================================================
	-- A warm, pastel theme with excellent treesitter support
	-- Flavours: latte (light), frappe, macchiato, mocha (darkest)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Load before other plugins (for colors)
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
				integrations = {
					cmp = true, -- nvim-cmp completion
					gitsigns = true, -- Git signs in gutter
					nvimtree = true, -- File explorer
					treesitter = true, -- Syntax highlighting
					mason = true, -- LSP installer
					which_key = true, -- Keybinding popup
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	-- ===========================================================================
	-- STATUSLINE: lualine.nvim
	-- ===========================================================================
	-- A blazing fast statusline written in Lua
	-- Shows: mode, branch, diff, diagnostics, filename, encoding, position
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin", -- Match our colorscheme
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" }, -- Current mode
					lualine_b = { "branch", "diff", "diagnostics" }, -- Git info
					lualine_c = { { "filename", path = 1 } }, -- Relative path
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" }, -- % through file
					lualine_z = { "location" }, -- Line:column
				},
			})
		end,
	},

	-- ===========================================================================
	-- BUFFER TABS: bufferline.nvim
	-- ===========================================================================
	-- A snazzy buffer line with minimal tab-line integration
	-- Navigate buffers with Shift+H and Shift+L
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers", -- Show buffers (not tabs)
					diagnostics = "nvim_lsp", -- Show LSP diagnostics in tabs
					offsets = {
						-- Push bufferline right when nvim-tree is open
						{ filetype = "NvimTree", text = "File Explorer", separator = true },
					},
				},
			})
		end,
	},

	-- ===========================================================================
	-- SNACKS.NVIM: Swiss Army Knife Plugin by Folke
	-- ===========================================================================
	-- A collection of small QoL plugins including:
	--   - Picker (fuzzy finder replacement for Telescope)
	--   - Dashboard (startup screen)
	--   - Notifier (better notifications)
	--   - Lazygit integration
	--   - Terminal
	--   - And more!
	{
		"folke/snacks.nvim",
		priority = 1000, -- Load early for dashboard
		lazy = false, -- Don't lazy load (needed for dashboard)
		opts = {
			-- -----------------------------------------------------------------------
			-- PICKER: Fuzzy finder (replaces Telescope)
			-- -----------------------------------------------------------------------
			picker = {
				enabled = true,
				sources = {
					files = {
						hidden = true, -- Show hidden files
						ignored = false, -- Don't show gitignored files
						exclude = {
							"node_modules",
							".git",
							"dist",
							"build",
							"coverage",
							"__pycache__",
							".next",
							".nuxt",
						},
					},
				},
				win = {
					input = {
						keys = {
							-- Navigate results with Ctrl+j/k
							["<C-j>"] = { "list_down", mode = { "i", "n" } },
							["<C-k>"] = { "list_up", mode = { "i", "n" } },
						},
					},
				},
			},

			-- -----------------------------------------------------------------------
			-- DASHBOARD: Startup screen
			-- -----------------------------------------------------------------------
			dashboard = {
				enabled = true,
				preset = {
					-- Custom header (ASCII art)
					header = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
					-- Quick action keys
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
						{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
						},
						{
							icon = " ",
							key = "p",
							desc = "Projects",
							action = ":lua Snacks.picker.files({ cwd = '~/Documents/git' })",
						},
						{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "recent_files", limit = 8, padding = 1 },
					{ section = "startup" },
				},
			},

			-- -----------------------------------------------------------------------
			-- NOTIFIER: Better notifications
			-- -----------------------------------------------------------------------
			notifier = {
				enabled = true,
				timeout = 3000, -- Auto-dismiss after 3 seconds
				style = "compact", -- compact, fancy, or minimal
			},

			-- -----------------------------------------------------------------------
			-- BIGFILE: Handle large files gracefully
			-- -----------------------------------------------------------------------
			bigfile = {
				enabled = true,
				size = 1.5 * 1024 * 1024, -- 1.5 MB
			},

			-- -----------------------------------------------------------------------
			-- QUICKFILE: Fast file opening
			-- -----------------------------------------------------------------------
			quickfile = { enabled = true },

			-- -----------------------------------------------------------------------
			-- STATUSCOLUMN: Better sign column
			-- -----------------------------------------------------------------------
			statuscolumn = { enabled = true },

			-- -----------------------------------------------------------------------
			-- WORDS: Highlight word under cursor
			-- -----------------------------------------------------------------------
			-- Jump between occurrences with ]] and [[
			words = { enabled = true },

			-- -----------------------------------------------------------------------
			-- LAZYGIT: Git UI integration
			-- -----------------------------------------------------------------------
			lazygit = { enabled = true },

			-- -----------------------------------------------------------------------
			-- GITBROWSE: Open in GitHub/GitLab
			-- -----------------------------------------------------------------------
			gitbrowse = { enabled = true },

			-- -----------------------------------------------------------------------
			-- INDENT: Indent guides (animation disabled for performance)
			-- -----------------------------------------------------------------------
			indent = {
				enabled = true,
				animate = {
					enabled = false, -- Disable animation to reduce runtime overhead
				},
			},

			-- -----------------------------------------------------------------------
			-- SCROLL: Smooth scrolling (disabled for performance)
			-- -----------------------------------------------------------------------
			scroll = {
				enabled = false, -- Disable scroll animation to reduce runtime overhead
			},

			-- -----------------------------------------------------------------------
			-- INPUT: Better vim.ui.input
			-- -----------------------------------------------------------------------
			input = { enabled = true },

			-- -----------------------------------------------------------------------
			-- RENAME: Better LSP rename UI
			-- -----------------------------------------------------------------------
			rename = { enabled = true },

			-- -----------------------------------------------------------------------
			-- STYLES: Custom window styles
			-- -----------------------------------------------------------------------
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap long notifications
				},
			},
		},

		-- Keybindings for snacks.nvim features
		keys = {
			-- Picker keymaps (replaces Telescope)
			{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
			{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
			{ "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
			{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
			{ "<leader>fs", function() Snacks.picker.git_status() end, desc = "Git status" },
			{ "<leader>fc", function() Snacks.picker.git_log() end, desc = "Git commits" },
			{ "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
			{ "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
			{ "<leader>f:", function() Snacks.picker.command_history() end, desc = "Command history" },
			{ "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
			{ "<C-p>", function() Snacks.picker.files() end, desc = "Find files" },

			-- Todo comments (via snacks picker)
			{ "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Find todos" },

			-- Git keymaps
			{ "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
			{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse (open in browser)" },
			{ "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git file history" },

			-- LSP keymaps (enhanced with snacks picker)
			{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Go to definition" },
			{ "gr", function() Snacks.picker.lsp_references() end, desc = "Find references" },
			{ "gi", function() Snacks.picker.lsp_implementations() end, desc = "Go to implementation" },
			{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Go to type definition" },
			{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols (document)" },
			{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP symbols (workspace)" },

			-- Notification history
			{ "<leader>un", function() Snacks.notifier.show_history() end, desc = "Notification history" },
			{ "<leader>uN", function() Snacks.notifier.hide() end, desc = "Dismiss all notifications" },

			-- Buffer delete (single source of truth — removes duplicate keymap)
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
			{ "<leader>bD", function() Snacks.bufdelete.all() end, desc = "Delete all buffers" },

			-- Words navigation (jump between occurrences)
			{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next occurrence" },
			{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous occurrence" },

			-- Zen mode / Focus
			{ "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen mode" },
			{ "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
		},

		-- Initialize snacks
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					_G.Snacks = require("snacks")

					-- Toggle options with <leader>u prefix
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle.inlay_hints():map("<leader>uh")
				end,
			})
		end,
	},
}
