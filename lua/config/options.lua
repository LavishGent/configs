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

-- appearance
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
