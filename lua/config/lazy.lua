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

require("lazy").setup({
	spec = {
		{ import = "plugins" }, -- Load all files from lua/plugins/
	},
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
