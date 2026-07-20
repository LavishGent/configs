return {
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
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				settings = {
					typescript = {
						inlayHints = {
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
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})

			-- -------------------------------------------------------------------------
			-- Go Configuration
			-- -------------------------------------------------------------------------
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
			lspconfig.clangd.setup({
				capabilities = capabilities,
			})

			-- -------------------------------------------------------------------------
			-- C# Configuration
			-- -------------------------------------------------------------------------
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
			lspconfig.yamlls.setup({
				capabilities = capabilities,
				settings = {
					yaml = {
						schemas = {
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
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" }, -- Don't warn about vim global
						},
						workspace = {
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
}
