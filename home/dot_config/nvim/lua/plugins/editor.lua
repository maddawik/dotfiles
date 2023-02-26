local Util = require("lazyvim.util")

return {
  -- better splits and tmux navigation
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
  },

  -- Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      window = {
        mappings = {
          ["<space>"] = "none",
          ["<tab>"] = "toggle_node",
        },
        width = 30,
      },
    },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    opts = {
      defaults = {
        winblend = 7,
      },
    },
    keys = {
      -- disable some keymaps
      { "<leader>/",  false },
      { "<leader>sg", false },
      { "<leader>sG", false },
      { "<leader>sw", false },
      { "<leader>sW", false },
      -- add live grep and word search keymaps
      { "<leader>fg", Util.telescope("live_grep"),                    desc = "Grep (root dir)" },
      { "<leader>fG", Util.telescope("live_grep", { cwd = false }),   desc = "Grep (cwd)" },
      { "<leader>fw", Util.telescope("grep_string"),                  desc = "Word (root dir)" },
      { "<leader>fW", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
      -- add a keymap to browse plugin files
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    opts = {
      window = { winblend = 9 },
      layout = { align = "center", },
    }
  },

  -- Diffview
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
    config = true,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" }
    },
  },

  -- Symbol outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" }
    },
    config = true,
  },

  -- Noice
  {
    "folke/noice.nvim",
    opts = {
      views = {
        mini = {
          win_options = {
            winblend = 100
          }
        },
      },
      format = {
        spinner = {
          name = "moon"
        }
      }
    },
  },

  -- Smart cursor column
  {
    "m4xshen/smartcolumn.nvim",
    opts = {},
    event = {
      "BufReadPre",
      "BufNewFile",
    },
  },
}
