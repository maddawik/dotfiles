if vim.fn.executable("python3") ~= 1 and vim.fn.executable("python") ~= 1 and vim.fn.executable("uv") ~= 1 then
  return {}
end

return {
  -- venv-selector (auto-detects uv venvs alongside pip/poetry/conda)
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    ft = "python",
    keys = { { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
    opts = {
      options = {
        notify_user_on_venv_activation = true,
        override_notify = false,
      },
    },
  },

  -- Extra treesitter parsers for Python ecosystem
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ninja", "rst" })
    end,
  },

  -- nvim-dap-python: debugger integration (loads on python files / DAP keys)
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      {
        "<leader>dPt",
        function()
          require("dap-python").test_method()
        end,
        desc = "Debug Method",
        ft = "python",
      },
      {
        "<leader>dPc",
        function()
          require("dap-python").test_class()
        end,
        desc = "Debug Class",
        ft = "python",
      },
    },
    config = function()
      require("dap-python").setup("python")
    end,
  },
}
