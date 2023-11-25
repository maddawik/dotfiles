local minifiles_toggle = function(...)
  if not MiniFiles.close() then
    MiniFiles.open(...)
  end
end

return {
  "echasnovski/mini.files",
  opts = {
    mappings = {
      synchronize = "<CR>",
    },
    options = {
      use_as_default_explorer = true,
    },
  },
  -- Passing a function that returns the table of keymaps overrides any of the
  -- defaults that LazyVim has (<leader>fm, and <leader>fM in this case)
  keys = function()
    return {
      {
        "-",
        function()
          minifiles_toggle(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open files (directory of current file)",
      },
      {
        "<leader>e",
        function()
          minifiles_toggle(require("lazyvim.util.root").get(), true)
        end,
        desc = "Open files (cwd)",
      },
      {
        "<leader>E",
        function()
          minifiles_toggle(nil, false)
        end,
        desc = "Open files (root dir)",
      },
    }
  end,
}
