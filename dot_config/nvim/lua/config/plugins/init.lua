return {
  "nvim-lua/plenary.nvim",
  "kyazdani42/nvim-web-devicons",
  "MunifTanjim/nui.nvim",
  "williamboman/mason-lspconfig.nvim",
  "folke/which-key.nvim",
  "stevearc/dressing.nvim",
  "catppuccin/nvim",
  "folke/tokyonight.nvim",
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function ()
      require("dressing").setup({
        select = {
          telescope = {},
        }
      })
    end
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle"
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd =  "SymbolsOutline",
    config = function() require('symbols-outline').setup() end
  },

  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy"
  },
  {
    "numToStr/Comment.nvim",
    config = function() require('Comment').setup() end
  },
  {
    "max397574/better-escape.nvim",
  },
  {
    "famiu/bufdelete.nvim",
    cmd = "Bdelete"
  },
  {
    "ggandor/lightspeed.nvim",
    event = "BufReadPre"
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
}
