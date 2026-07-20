return {
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
}
