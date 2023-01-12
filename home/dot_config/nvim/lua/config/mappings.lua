local wk = require("which-key")
local util = require("util")

vim.o.timeoutlen = 300

wk.setup({
	show_help = true,
	show_keys = true,
	triggers = "auto",
	plugins = {
		spelling = {
			enabled = true, -- z= to select spelling suggestions
		},
		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true,
			g = true,
		},
	},
	window = {
		border = "none", -- none, single, double, shadow, rounded
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "center", -- align columns left, center or right
	},
	key_labels = { ["<leader>"] = "Space" },
})


local opts = { silent = true }

-- Better window navigation
vim.keymap.set("n", "<C-h>", ":SmartCursorMoveLeft<cr>", opts)
vim.keymap.set("n", "<C-j>", ":SmartCursorMoveDown<cr>", opts)
vim.keymap.set("n", "<C-k>", ":SmartCursorMoveUp<cr>", opts)
vim.keymap.set("n", "<C-l>", ":SmartCursorMoveRight<cr>", opts)

vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":SmartResizeUp<cr>", opts)
vim.keymap.set("n", "<C-Down>", ":SmartResizeDown<cr>", opts)
vim.keymap.set("n", "<C-Left>", ":SmartResizeLeft<cr>", opts)
vim.keymap.set("n", "<C-Right>", ":SmartResizeRight<cr>", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<cr>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<cr>", opts)

-- Press jk fast to enter
vim.keymap.set("i", "jk", "<ESC>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Better paste
vim.keymap.set("v", "p", '"_dP', opts)

-- Save in insert mode
vim.keymap.set("i", "<C-s>", "<cmd>:w<cr><esc>", opts)
vim.keymap.set("n", "<C-s>", "<cmd>:w<cr><esc>", opts)

local leader = {
	[" "] = { "<cmd>Telescope find_files<cr>", "Find Files" },
	["c"] = { "<cmd>Bdelete<cr>", "Close Buffer" },
	["C"] = { "<cmd>Bdelete!<cr>", "Nuke Buffer" },
	["d"] = { "<cmd>Alpha<cr>", "Dashboard" },
	["e"] = { "<cmd>Neotree toggle<cr>", "Filetree" },
	["u"] = { "<cmd>UndotreeToggle<cr>", "Undotree" },
	["n"] = { "<cmd>ene<cr>", "New File" },
	["w"] = { "<cmd>w!<cr>", "Save" },
	["q"] = { "<cmd>q!<cr>", "Quit" },

	--b = {
	--	name = "Buffer",
	--},

	h = {
		name = "Help",
		t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
		c = { "<cmd>:Telescope commands<cr>", "Commands" },
		h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
		m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
		k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
		s = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
		l = { vim.show_pos, "Highlight Groups at cursor" },
		f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
		o = { "<cmd>:Telescope vim_options<cr>", "Options" },
		a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
	},

	p = {
		name = "Plugins",
		c = { "<cmd>Lazy check<cr>", "Lazy Check" },
		x = { "<cmd>Lazy clean<cr>", "Lazy Clean" },
		h = { "<cmd>Lazy home<cr>", "Lazy Home" },
		d = { "<cmd>Lazy debug<cr>", "Lazy Debug" },
		i = { "<cmd>Lazy install<cr>", "Lazy Install" },
		l = { "<cmd>Lazy log<cr>", "Lazy Log" },
		p = { "<cmd>Lazy profile<cr>", "Lazy Profile" },
		r = { "<cmd>Lazy restore<cr>", "Lazy Restore" },
		s = { "<cmd>Lazy sync<cr>", "Lazy Sync" },
		u = { "<cmd>Lazy update<cr>", "Lazy Update" },
		m = { "<cmd>Mason<cr>", "Mason" },
	},

	g = {
		name = "Git",
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		s = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		g = { "<cmd>lua _Lazygit_toggle()<cr>", "Lazygit" },
		d = {
			"<cmd>Gitsigns diffthis HEAD<cr>",
			"Diff",
		},
		-- https://github.com/sindrets/diffview.nvim
		-- d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
		h = {
			name = "Hunk",
			j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
			k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
			l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
			p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
			r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
			R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
			s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
			u = {
				"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
				"Undo Stage Hunk",
			},
		},
	},

	f = {
		name = "Find",
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		o = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
		r = { "<cmd>Telescope registers<cr>", "Registers" },
		f = { "<cmd>Telescope find_files<cr>", "Files" },
		w = { "<cmd>Telescope grep_string<cr>", "Word" },
		g = { "<cmd>Telescope live_grep<cr>", "Grep" },
		n = { "<cmd>Telescope noice<cr>", "Notifications" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
	},

	t = {
		name = "Toggle",
		h = { "<cmd>nohlsearch<cr>", "No Highlight" },
		t = { "<cmd>ToggleTerm<cr>", "Terminal" },
    ["-"] = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal Terminal" },
    ["\\"] = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical Terminal" },
		l = { "<cmd>lua _Lazygit_toggle()<cr>", "Lazygit" },
		f = {
			require("config.plugins.lsp.formatting").toggle,
			"Format on Save",
		},
		w = {
			function()
				util.toggle("wrap")
			end,
			"Word Wrap",
		},
		n = {
			function()
				util.toggle("number")
			end,
			"Line Numbers",
		},
		r = {
			function()
				util.toggle("relativenumber")
			end,
			"Relative Numbers",
		},
	},
}

local opts = {
	prefix = "<leader>",
}

wk.register(leader, opts)
