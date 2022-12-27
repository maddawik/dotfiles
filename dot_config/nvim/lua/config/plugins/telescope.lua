local M = {
	"nvim-telescope/telescope.nvim",
	cmd = { "Telescope" },

	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		--{ "nvim-telescope/telescope-file-browser.nvim" },
	},
}

function M.config()
	local telescope = require("telescope")
  --local actions = require("telescope.actions")
	telescope.setup({
		defaults = {
			prompt_prefix = " ",
			selection_caret = " ",
			path_display = { "smart" },
			file_ignore_patterns = { ".git/", "node_modules" },
			layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
        preview_width = .6,
      },
      sorting_strategy = "ascending",
		},
	})
	telescope.load_extension("fzf")
	--telescope.load_extension("file_browser")
	telescope.load_extension("noice")
end

return M
