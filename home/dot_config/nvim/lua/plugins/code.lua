return {
  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        ansiblels = {},
        bashls = {},
        gopls = {},
        marksman = {},
        terraformls = {},
        pyright = {},
        lua_ls = {},
      },
    },
  },

  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "fish",
        "go",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "terraform",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "vhs",
      })
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

  -- ansible-lint
  {
    "pearofducks/ansible-vim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable( -1) then
            luasnip.jump( -1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
