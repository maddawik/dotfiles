-- plugins and settings related to lsp, completion, etc.
return {
  -- lazyvim plugins

  -- nvim-lspconfig

  -- nvim-treesitter

  -- null-ls
  -- {
  --   "nvimtools/none-ls.nvim",
  --   opts = function()
  --     local nls = require("null-ls")
  --     return {
  --       sources = {
  --         nls.builtins.diagnostics.actionlint,
  --         nls.builtins.diagnostics.fish,
  --         nls.builtins.formatting.fish_indent,
  --         nls.builtins.diagnostics.gdlint.with({
  --           command = vim.fn.expand("~/.pyenv/shims/gdlint"),
  --         }),
  --         nls.builtins.formatting.gdformat.with({
  --           command = vim.fn.expand("~/.pyenv/shims/gdformat"),
  --           extra_args = { "--line-length", "80" },
  --         })
  --       },
  --     }
  --   end,
  -- },

  -- mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "actionlint",
        "stylua",
        "shellcheck",
        "shfmt",
      },
    },
  },

  -- go tools
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = true,
    build = function()
      vim.cmd([[silent! goinstalldeps]])
    end,
    keys = {
      { "<leader>ge", "<cmd> goiferr <cr>", desc = "goiferr" },
    },
  },

  -- inkle's ink
  { "ahayworth/ink-syntax-vim", ft = "ink" },

  -- godot
  { "habamax/vim-godot", ft = "gdscript", enabled = false },

  -- ansible-lint
  {
    "pearofducks/ansible-vim",
    event = {
      "bufreadpre",
      "bufnewfile",
    },
  },

  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "chrisgrieser/cmp-nerdfont",
      { "mtoohey31/cmp-fish", ft = "fish" },
    },
    ---@param opts cmp.configschema
    opts = function(_, opts)
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      cmp.setup({
        window = {
          -- completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "fish" },
        { name = "emoji" },
        { name = "nerdfont" },
      }))
    end,
  },
}
