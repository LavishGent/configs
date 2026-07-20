return {
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
}
