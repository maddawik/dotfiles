vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.showtabline = 0
vim.opt.smartcase = true
vim.opt.smartindent = true

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.wrap = false
vim.opt.linebreak = true

vim.opt.hlsearch = true
vim.opt.ignorecase = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.termguicolors = true
vim.opt.fileencoding = "utf-8"
vim.opt.clipboard = "unnamedplus"

vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1

vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.ruler = false

vim.opt.timeoutlen = 300
vim.opt.updatetime = 300

vim.opt.mouse = "a"

vim.opt.laststatus = 3
vim.opt.numberwidth = 4
vim.opt.pumheight = 10

-- vim.opt.guifont = "monospace:h17"
-- vim.opt.whichwrap = "bs<>[]hl"
