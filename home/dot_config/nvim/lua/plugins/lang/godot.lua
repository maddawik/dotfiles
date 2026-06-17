if vim.fn.executable("godot") ~= 1 then
  return {}
end

return {
  {
    "habamax/vim-godot",
    ft = { "gdscript", "gsl" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("godot_lsp", { clear = true }),
        pattern = { "gd", "gdscript" },
        callback = function()
          local cmd = vim.lsp.rpc.connect("127.0.0.1", 6005)
          vim.lsp.start({
            name = "gdscript",
            filetypes = { "gdscript" },
            cmd = cmd,
            autostart = true,
            root_dir = vim.fs.dirname(vim.fs.find({ "project.godot", ".git" }, { upward = true })[1]),
          })
        end,
        desc = "Enable godot LSP for gdscript files",
      })
    end,
  },

  -- Per-filetype extensions to existing plugins
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        gdscript = { "gdscript-formatter" },
      },
      formatters = {
        gdformat = {
          prepend_args = { "--line-length", "120" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.gdscript = { "gdlint" }
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "gdtoolkit",
        "gdscript-formatter",
      })
    end,
  },
}
