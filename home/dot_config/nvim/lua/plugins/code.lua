-- Plugins and settings related to LSP, completion, etc.
return {
  -- LazyVim plugins
  -- { import = "lazyvim.plugins.extras.coding.yanky" },
  -- { import = "lazyvim.plugins.extras.dap" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  -- { import = "lazyvim.plugins.extras.ui.edgy" },
  { import = "lazyvim.plugins.extras.util.project" },
  -- { import = "lazyvim.plugins.extras.vscode" },

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        ansiblels = {},
        bashls = {},
        gdscript = {},
        gopls = {},
        lua_ls = {},
        marksman = {
          filetypes = { "markdown", "telekasten" },
        },
        pyright = {},
        terraformls = {},
      },
    },
  },

  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "clojure",
        "dockerfile",
        "fish",
        "gdscript",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "ruby",
        "rust",
        "terraform",
        "tsx",
        "typescript",
        "vhs",
        "vim",
        "yaml",
      })
      vim.treesitter.language.register("markdown", "telekasten")
    end,
  },

  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.diagnostics.actionlint,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.gdlint.with({
            command = vim.fn.expand("~/.pyenv/shims/gdlint"),
          }),
          nls.builtins.formatting.gdformat.with({
            command = vim.fn.expand("~/.pyenv/shims/gdformat"),
            extra_args = { "--line-length", "80" },
          })
        },
      }
    end,
  },

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
      vim.cmd([[silent! GoInstallDeps]])
    end,
    keys = {
      { "<leader>ge", "<cmd> GoIfErr <cr>", desc = "GoIfErr" }
    },
  },

  -- inkle's ink
  { "ahayworth/ink-syntax-vim", ft = "ink", },

  -- godot
  { "habamax/vim-godot",        ft = "gdscript", },

  -- ansible-lint
  {
    "pearofducks/ansible-vim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
  },

  {
    "L3MON4D3/LuaSnip",
    config = function()
      require('luasnip').filetype_extend("telekasten", { "markdown" })
    end,
  },


  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "chrisgrieser/cmp-nerdfont",
      { "mtoohey31/cmp-fish", ft = "fish" },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      cmp.setup {
        window = {
          -- completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources,
        {
          { name = "fish" },
          { name = "emoji" },
          { name = "nerdfont" }
        }
      ))
    end,
  },
}
