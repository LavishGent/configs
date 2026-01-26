vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- use relative numbers to jump using
opt.number = true
opt.relativenumber = true

-- tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- search behavior
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- appearanve
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "100"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

-- behavior
opt.hidden = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.swapfile = false
opt.backup = false
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = { "menu", "menuone", "noselect" }
opt.splitright = true
opt.splitbelow = true

-- folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

-- lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim exists, if not clone it from GitHub
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none", -- Shallow clone for speed
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- Use stable release
		lazypath,
	})
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- PLUGIN CONFIGURATION
-- =============================================================================
-- All plugins are configured below using lazy.nvim's spec format
-- Each plugin can have:
--   - dependencies: plugins it requires
--   - config: function to run after loading
--   - ft: filetype to lazy-load on
--   - cmd: command to lazy-load on
--   - event: event to lazy-load on

require("lazy").setup({

	-- ===========================================================================
	-- COLORSCHEME: Catppuccin
	-- ===========================================================================
	-- A warm, pastel theme with excellent treesitter support
	-- Flavours: latte (light), frappe, macchiato, mocha (darkest)
	-- Change flavour below to switch themes
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
	-- FILE EXPLORER: nvim-tree
	-- ===========================================================================
	-- A file explorer tree written in Lua
	-- Toggle with <leader>e, focus with <leader>o
	-- Navigate: j/k to move, Enter to open, a to create, d to delete
	{
		"nvim-tree/nvim-tree.lua",
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
	-- SNACKS.NVIM: Swiss Army Knife Plugin by Folke
	-- ===========================================================================
	-- A collection of small QoL plugins including:
	--   - Picker (fuzzy finder replacement for Telescope)
	--   - Dashboard (startup screen)
	--   - Notifier (better notifications)
	--   - Lazygit integration
	--   - Terminal
	--   - And more!
	--
	-- Key bindings:
	--   <leader>ff - Find files
	--   <leader>fg - Live grep (search in files)
	--   <leader>fb - List buffers
	--   <leader>fh - Help tags
	--   <leader>fr - Recent files
	--   <C-p>      - Quick file find (like VS Code)
	{
		"folke/snacks.nvim",
		priority = 1000, -- Load early for dashboard
		lazy = false, -- Don't lazy load (needed for dashboard)
		opts = {
			-- -----------------------------------------------------------------------
			-- PICKER: Fuzzy finder (replaces Telescope)
			-- -----------------------------------------------------------------------
			-- Fast, async picker with preview
			picker = {
				enabled = true,
				-- Ignore these directories/patterns in searches
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
				-- Window appearance
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
			-- Shows recent files and quick actions on startup
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
			-- Pretty notification popups instead of messages
			notifier = {
				enabled = true,
				timeout = 3000, -- Auto-dismiss after 3 seconds
				style = "compact", -- compact, fancy, or minimal
			},

			-- -----------------------------------------------------------------------
			-- BIGFILE: Handle large files gracefully
			-- -----------------------------------------------------------------------
			-- Disables features that slow down on large files
			bigfile = {
				enabled = true,
				size = 1.5 * 1024 * 1024, -- 1.5 MB
			},

			-- -----------------------------------------------------------------------
			-- QUICKFILE: Fast file opening
			-- -----------------------------------------------------------------------
			-- Render file immediately before plugins load
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
			-- Open lazygit in a floating window with <leader>lg
			lazygit = { enabled = true },

			-- -----------------------------------------------------------------------
			-- GITBROWSE: Open in GitHub/GitLab
			-- -----------------------------------------------------------------------
			gitbrowse = { enabled = true },

			-- -----------------------------------------------------------------------
			-- INDENT: Animated indent guides
			-- -----------------------------------------------------------------------
			indent = {
				enabled = true,
				animate = {
					enabled = true,
					duration = {
						step = 15, -- Animation speed
						total = 150,
					},
				},
			},

			-- -----------------------------------------------------------------------
			-- SCROLL: Smooth scrolling
			-- -----------------------------------------------------------------------
			scroll = {
				enabled = true,
				animate = {
					duration = { step = 10, total = 100 },
				},
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
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help tags",
			},
			{
				"<leader>fr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent files",
			},
			{
				"<leader>fs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git status",
			},
			{
				"<leader>fc",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git commits",
			},
			{
				"<leader>fd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>fw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Grep word under cursor",
			},
			{
				"<leader>f:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command history",
			},
			{
				"<leader>fk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<C-p>",
				function()
					Snacks.picker.files()
				end,
				desc = "Find files",
			},

			-- Git keymaps
			{
				"<leader>lg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git browse (open in browser)",
			},
			{
				"<leader>gf",
				function()
					Snacks.picker.git_log_file()
				end,
				desc = "Git file history",
			},

			-- LSP keymaps (enhanced with snacks picker)
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Go to definition",
			},
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				desc = "Find references",
			},
			{
				"gi",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Go to implementation",
			},
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Go to type definition",
			},
			{
				"<leader>ss",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP symbols (document)",
			},
			{
				"<leader>sS",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "LSP symbols (workspace)",
			},

			-- Notification history
			{
				"<leader>un",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification history",
			},
			{
				"<leader>uN",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss all notifications",
			},

			-- Buffer delete
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete buffer",
			},
			{
				"<leader>bD",
				function()
					Snacks.bufdelete.all()
				end,
				desc = "Delete all buffers",
			},

			-- Words navigation (jump between occurrences)
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next occurrence",
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Previous occurrence",
			},

			-- Zen mode / Focus
			{
				"<leader>z",
				function()
					Snacks.zen()
				end,
				desc = "Toggle Zen mode",
			},
			{
				"<leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
		},

		-- Initialize snacks
		init = function()
			-- Setup global Snacks variable for keymaps
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Create global toggle mappings
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

	-- ===========================================================================
	-- SYNTAX HIGHLIGHTING: Treesitter
	-- ===========================================================================
	-- Treesitter provides superior syntax highlighting by parsing code into AST
	-- Also enables: smart indentation, code folding, text objects
	-- Run :TSInstall <language> to install additional parsers
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- Auto-update parsers
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects", -- Additional text objects
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				-- Languages to install parsers for
				-- Based on your project stack
				ensure_installed = {
					-- Config/tooling
					"lua",
					"vim",
					"vimdoc",

					-- Web development (your main stack)
					"typescript",
					"tsx", -- React/TypeScript
					"javascript",
					"html",
					"css",
					"json",
					"jsonc", -- JSON with comments
					"svelte", -- For chimera-tracker
					"vue",

					-- Backend languages
					"go", -- For rentfree project
					"gomod",
					"gosum",
					"python", -- For asi-aoai
					"c", -- For QMK firmware
					"cpp",
					"c_sharp", -- For unified-cache-manager

					-- DevOps/Infrastructure
					"terraform", -- For manifests projects
					"hcl", -- HashiCorp config language
					"yaml", -- Kubernetes configs
					"toml",
					"dockerfile",
					"bash",

					-- Documentation
					"markdown",
					"markdown_inline",

					-- Git
					"gitignore",
					"gitcommit",
				},

				-- Enable syntax highlighting
				highlight = { enable = true },

				-- Enable treesitter-based indentation
				indent = { enable = true },

				-- Incremental selection based on AST
				-- Use <C-space> to start and expand selection
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>", -- Start selection
						node_incremental = "<C-space>", -- Expand to larger node
						scope_incremental = false,
						node_decremental = "<bs>", -- Shrink selection (backspace)
					},
				},

				-- Text objects for selecting/operating on code structures
				-- Examples: vaf = select around function, vic = select inner class
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Jump to next if cursor not on text object
						keymaps = {
							["af"] = "@function.outer", -- Around function
							["if"] = "@function.inner", -- Inside function
							["ac"] = "@class.outer", -- Around class
							["ic"] = "@class.inner", -- Inside class
							["aa"] = "@parameter.outer", -- Around argument/parameter
							["ia"] = "@parameter.inner", -- Inside argument/parameter
						},
					},
					-- Move between functions/classes with ]f, [f, ]c, [c
					move = {
						enable = true,
						set_jumps = true, -- Add to jumplist
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
						},
					},
				},
			})
		end,
	},

	-- ===========================================================================
	-- LSP CONFIGURATION
	-- ===========================================================================
	-- Language Server Protocol provides:
	--   - Code completion
	--   - Go to definition
	--   - Find references
	--   - Diagnostics (errors/warnings)
	--   - Code actions
	--   - And more!
	--
	-- Mason handles LSP server installation
	-- Run :Mason to see/install available servers
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim", -- LSP installer
			"williamboman/mason-lspconfig.nvim", -- Bridge between mason and lspconfig
			"j-hui/fidget.nvim", -- LSP progress indicator
		},
		config = function()
			-- Show LSP progress in bottom right
			require("fidget").setup({})

			-- Setup Mason (LSP installer)
			require("mason").setup()

			-- Configure which LSP servers to auto-install
			-- These are chosen based on your project languages
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- TypeScript/JavaScript (your main frontend stack)
					"ts_ls", -- TypeScript language server
					"eslint", -- ESLint for linting

					-- Go (rentfree project)
					"gopls", -- Official Go language server

					-- Python (asi-aoai project)
					"pyright", -- Fast Python type checker

					-- C/C++ (QMK firmware, corne-keyboard)
					"clangd", -- LLVM-based C/C++ server

					-- C# (unified-cache-manager)
					"omnisharp", -- .NET language server

					-- Infrastructure
					"terraformls", -- Terraform language server
					"yamlls", -- YAML language server (for k8s configs)

					-- Lua (for this config file!)
					"lua_ls", -- Lua language server

					-- Docker
					"dockerls", -- Dockerfile language server

					-- Svelte (chimera-tracker)
					"svelte", -- Svelte language server

					-- CSS
					"tailwindcss", -- Tailwind CSS IntelliSense
				},
			})

			-- Get LSP capabilities from nvim-cmp for better completion
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- -------------------------------------------------------------------------
			-- TypeScript/JavaScript Configuration
			-- -------------------------------------------------------------------------
			-- ts_ls (formerly tsserver) provides rich TypeScript support
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				settings = {
					typescript = {
						inlayHints = {
							-- Show type hints inline (useful for implicit types)
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
						},
					},
				},
			})

			-- ESLint - auto-fix on save
			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = function(_, bufnr)
					-- Run ESLint fix on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})

			-- -------------------------------------------------------------------------
			-- Go Configuration
			-- -------------------------------------------------------------------------
			-- gopls is the official Go language server
			lspconfig.gopls.setup({
				capabilities = capabilities,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true, -- Warn about unused params
							shadow = true, -- Warn about variable shadowing
						},
						staticcheck = true, -- Enable staticcheck linter
						gofumpt = true, -- Use gofumpt for formatting
					},
				},
			})

			-- -------------------------------------------------------------------------
			-- Python Configuration
			-- -------------------------------------------------------------------------
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})

			-- -------------------------------------------------------------------------
			-- C/C++ Configuration
			-- -------------------------------------------------------------------------
			-- clangd for QMK firmware development
			lspconfig.clangd.setup({
				capabilities = capabilities,
			})

			-- -------------------------------------------------------------------------
			-- C# Configuration
			-- -------------------------------------------------------------------------
			-- OmniSharp for .NET projects
			lspconfig.omnisharp.setup({
				capabilities = capabilities,
			})

			-- -------------------------------------------------------------------------
			-- Terraform Configuration
			-- -------------------------------------------------------------------------
			lspconfig.terraformls.setup({
				capabilities = capabilities,
			})

			-- -------------------------------------------------------------------------
			-- YAML Configuration
			-- -------------------------------------------------------------------------
			-- Configured with Kubernetes schema for your manifest projects
			lspconfig.yamlls.setup({
				capabilities = capabilities,
				settings = {
					yaml = {
						schemas = {
							-- Kubernetes schema for YAML validation
							["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.yaml",
						},
						validate = true,
						completion = true,
					},
				},
			})

			-- -------------------------------------------------------------------------
			-- Lua Configuration
			-- -------------------------------------------------------------------------
			-- For editing this config and other Lua files
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" }, -- Don't warn about vim global
						},
						workspace = {
							-- Include Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- -------------------------------------------------------------------------
			-- Docker Configuration
			-- -------------------------------------------------------------------------
			lspconfig.dockerls.setup({
				capabilities = capabilities,
			})

			-- -------------------------------------------------------------------------
			-- Svelte Configuration
			-- -------------------------------------------------------------------------
			lspconfig.svelte.setup({
				capabilities = capabilities,
			})

			-- -------------------------------------------------------------------------
			-- Tailwind CSS Configuration
			-- -------------------------------------------------------------------------
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})
		end,
	},

	-- ===========================================================================
	-- AUTOCOMPLETION: nvim-cmp
	-- ===========================================================================
	-- Completion engine with multiple sources
	-- Tab/Shift-Tab to navigate, Enter to confirm, Ctrl-Space to trigger
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP completion source
			"hrsh7th/cmp-buffer", -- Buffer words completion
			"hrsh7th/cmp-path", -- File path completion
			"L3MON4D3/LuaSnip", -- Snippet engine
			"saadparwaiz1/cmp_luasnip", -- Snippet completion source
			"rafamadriz/friendly-snippets", -- Pre-made snippets collection
			"onsails/lspkind.nvim", -- VS Code-like icons in completion menu
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			-- Load VS Code-style snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				-- Snippet expansion function
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				-- Keybindings for completion menu
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
					["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll docs down
					["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
					["<C-e>"] = cmp.mapping.abort(), -- Close menu
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection

					-- Tab to cycle through completions and expand snippets
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					-- Shift-Tab to go backwards
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				-- Completion sources (in priority order)
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- LSP completions (highest priority)
					{ name = "luasnip" }, -- Snippets
					{ name = "buffer" }, -- Words from current buffer
					{ name = "path" }, -- File paths
				}),

				-- Use VS Code-like icons
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text", -- Show symbol + text
						maxwidth = 50,
					}),
				},
			})
		end,
	},

	-- ===========================================================================
	-- CODE FORMATTING: conform.nvim
	-- ===========================================================================
	-- Async formatter that supports multiple formatters per filetype
	-- Formats on save automatically
	-- Install formatters via Mason or your package manager
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				-- Define formatters for each filetype
				formatters_by_ft = {
					-- Lua
					lua = { "stylua" },

					-- JavaScript/TypeScript (using Prettier)
					javascript = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					javascriptreact = { "prettier" },
					json = { "prettier" },
					jsonc = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
					svelte = { "prettier" },
					vue = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },

					-- Go
					go = { "gofumpt", "goimports" }, -- gofumpt + imports organization

					-- Python
					python = { "black", "isort" }, -- black + import sorting

					-- C/C++
					c = { "clang_format" },
					cpp = { "clang_format" },

					-- C#
					cs = { "csharpier" },

					-- Terraform
					terraform = { "terraform_fmt" },
					tf = { "terraform_fmt" },
				},

				-- Format on save (disable if you prefer manual formatting)
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true, -- Use LSP format if no formatter configured
				},
			})
		end,
	},

	-- ===========================================================================
	-- GIT INTEGRATION: gitsigns.nvim
	-- ===========================================================================
	-- Shows git diff signs in the gutter
	-- Navigate hunks with ]h and [h
	-- Stage/reset hunks with <leader>hs and <leader>hr
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				-- Customize signs shown in gutter
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},

				-- Keybindings (applied when gitsigns attaches to buffer)
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigate between hunks
					map("n", "]h", gs.next_hunk, { desc = "Next hunk" })
					map("n", "[h", gs.prev_hunk, { desc = "Previous hunk" })

					-- Stage/reset hunks
					map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
					map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
				end,
			})
		end,
	},

	-- ===========================================================================
	-- GIT UI: vim-fugitive
	-- ===========================================================================
	-- The ultimate Git wrapper for Vim
	-- :Git (or :G) for status, :Git blame, :Git push, etc.
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gstatus", "Gblame", "Gpush", "Gpull" }, -- Lazy load
	},

	-- ===========================================================================
	-- STATUSLINE: lualine.nvim
	-- ===========================================================================
	-- A blazing fast statusline written in Lua
	-- Shows: mode, branch, diff, diagnostics, filename, encoding, position
	{
		"nvim-lualine/lualine.nvim",
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
	-- INDENT GUIDES: Handled by snacks.nvim
	-- ===========================================================================
	-- Note: indent-blankline.nvim replaced by snacks.indent (configured above)
	-- snacks.indent provides animated indent guides with scope highlighting

	-- ===========================================================================
	-- TERMINAL: toggleterm.nvim
	-- ===========================================================================
	-- Better terminal management
	-- Toggle with Ctrl+\ (floating terminal)
	{
		"akinsho/toggleterm.nvim",
		version = "*",
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
	-- DIAGNOSTICS PANEL: trouble.nvim
	-- ===========================================================================
	-- A pretty list for diagnostics, quickfix, and location lists
	-- Toggle with <leader>xx
	{
		"folke/trouble.nvim",
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
	-- QUICKFIX ENHANCEMENT: nvim-bqf
	-- ===========================================================================
	-- Better quickfix window with preview and fuzzy search
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf", -- Load when quickfix window opens
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
	-- Tmux Navigation (seamless Ctrl+hjkl between vim and tmux panes)
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
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
}, {
	-- ===========================================================================
	-- LAZY.NVIM OPTIONS
	-- ===========================================================================
	install = {
		colorscheme = { "catppuccin" }, -- Use this theme during install
	},
	checker = {
		enabled = true, -- Auto-check for plugin updates
		notify = false, -- Don't notify on updates (check with :Lazy)
	},
	performance = {
		rtp = {
			-- Disable some built-in plugins we don't need
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

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
-- Note: Window navigation is handled by vim-tmux-navigator plugin (lines 1278-1295)
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
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

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
-- FILE EXPLORER
-- -----------------------------------------------------------------------------
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap("n", "<leader>o", ":NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- -----------------------------------------------------------------------------
-- SNACKS.NVIM PICKER KEYMAPS
-- -----------------------------------------------------------------------------
-- Note: Most snacks keymaps are defined in the plugin config above
-- These are just the remaining ones that use vim.keymap.set pattern

-- -----------------------------------------------------------------------------
-- LSP KEYMAPS
-- -----------------------------------------------------------------------------
-- These are applied when an LSP server attaches to a buffer
-- Note: gd, gr, gi are handled by snacks.picker for better UI
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }

		-- Navigation (gd, gr, gi handled by snacks.picker in plugin config)
		keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))

		-- Documentation
		keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
		keymap("n", "<leader>k", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

		-- Refactoring
		keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
		keymap("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))

		-- Formatting
		keymap("n", "<leader>F", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, vim.tbl_extend("force", opts, { desc = "Format file" }))
	end,
})

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

-- -----------------------------------------------------------------------------
-- TODO COMMENTS
-- -----------------------------------------------------------------------------
-- Note: Use snacks picker for todos: <leader>ft mapped in snacks config
keymap("n", "<leader>ft", function()
	Snacks.picker.todo_comments()
end, { desc = "Find todos" })

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

-- =============================================================================
-- USER COMMANDS
-- =============================================================================
-- Custom commands you can run with :CommandName

-- -----------------------------------------------------------------------------
-- :Projects - Browse your git projects directory
-- -----------------------------------------------------------------------------
-- Note: Also available via dashboard "p" key and <leader>fp
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
-- :ReloadConfig - Reload this config file
-- -----------------------------------------------------------------------------
vim.api.nvim_create_user_command("ReloadConfig", function()
	vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
	print("Config reloaded!")
end, { desc = "Reload nvim config" })

-- =============================================================================
-- STARTUP MESSAGE
-- =============================================================================
print("Neovim config loaded successfully!")

-- =============================================================================
-- QUICK REFERENCE (for your projects)
-- =============================================================================
--
-- GENERAL:
--   <Space>       Leader key
--   jk or jj      Exit insert mode
--   <C-s>         Save file
--   <Space>q      Quit
--   <Space>z      Zen mode (distraction-free)
--   <Space>Z      Zoom current window
--
-- FILE NAVIGATION (snacks.picker):
--   <Space>e      Toggle file explorer
--   <Space>ff     Find files
--   <Space>fg     Search in files (grep)
--   <Space>fw     Grep word under cursor
--   <Space>fb     List buffers
--   <Space>fr     Recent files
--   <Space>fh     Help tags
--   <Space>fk     Keymaps
--   <Space>f:     Command history
--   <C-p>         Quick file find
--
-- BUFFER NAVIGATION:
--   Shift+H       Previous buffer
--   Shift+L       Next buffer
--   <Space>bd     Delete buffer
--   <Space>bD     Delete all buffers
--
-- WINDOW NAVIGATION:
--   Ctrl+h/j/k/l  Move between windows
--   Ctrl+Arrows   Resize windows
--
-- LSP (when editing code):
--   gd            Go to definition (with picker)
--   gr            Find references (with picker)
--   gi            Go to implementation (with picker)
--   gy            Go to type definition (with picker)
--   gD            Go to declaration
--   K             Show documentation
--   <Space>rn     Rename symbol
--   <Space>ca     Code action
--   <Space>F      Format file
--   <Space>ss     Document symbols
--   <Space>sS     Workspace symbols
--
-- WORD NAVIGATION:
--   ]]            Next occurrence of word under cursor
--   [[            Previous occurrence
--
-- GIT:
--   <Space>lg     Lazygit (full Git UI)
--   <Space>gB     Open file in browser (GitHub/GitLab)
--   <Space>gf     Git file history
--   <Space>fs     Git status (picker)
--   <Space>fc     Git commits (picker)
--   <Space>gg     Git status (fugitive)
--   ]h / [h       Next/prev git hunk
--   <Space>hs     Stage hunk
--   <Space>hr     Reset hunk
--
-- DIAGNOSTICS:
--   <Space>xx     Toggle diagnostics panel
--   <Space>fd     Search diagnostics (picker)
--   <Space>ud     Toggle diagnostics
--
-- TOGGLES (<Space>u prefix):
--   <Space>us     Toggle spelling
--   <Space>uw     Toggle word wrap
--   <Space>uL     Toggle relative line numbers
--   <Space>ul     Toggle line numbers
--   <Space>ud     Toggle diagnostics
--   <Space>uT     Toggle treesitter
--   <Space>uh     Toggle inlay hints
--
-- NOTIFICATIONS:
--   <Space>un     Show notification history
--   <Space>uN     Dismiss all notifications
--
-- TERMINAL:
--   Ctrl+\        Toggle floating terminal
--
-- COMMENTS:
--   gcc           Toggle line comment
--   gbc           Toggle block comment
--
-- DASHBOARD (on startup):
--   f             Find files
--   g             Grep text
--   r             Recent files
--   p             Projects (~/Documents/git)
--   c             Config files
--   l             Lazy plugin manager
--   q             Quit
--
-- =============================================================================
