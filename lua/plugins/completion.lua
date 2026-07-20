return {
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
}
