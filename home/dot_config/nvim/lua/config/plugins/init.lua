return {
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",
  "MunifTanjim/nui.nvim",
  "williamboman/mason-lspconfig.nvim",
  "folke/which-key.nvim",
  "stevearc/dressing.nvim",
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        select = {
          telescope = {},
        },
      })
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = true,
  },
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
  },
  {
    "max397574/better-escape.nvim",
  },
  {
    "famiu/bufdelete.nvim",
    cmd = "Bdelete",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
      keys = {
        {
          "<leader>qs",
          function()
            require("persistence").load()
          end,
          desc = "Restore Session",
        },
        {
          "<leader>ql",
          function()
            require("persistence").load({ last = true })
          end,
          desc = "Restore Last Session",
        },
        {
          "<leader>qd",
          function()
            require("persistence").stop()
          end,
          desc = "Don't Save Current Session",
        },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  },
}
