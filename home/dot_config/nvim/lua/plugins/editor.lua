-- Editor settings not related to LSP, completion, etc.
local Util = require("lazyvim.util")

return {
  -- Telekasten - wiki
  {
    'renerocksai/telekasten.nvim',
    dependencies = {
      "renerocksai/calendar-vim"
    },
    cmd = "Telekasten",
    opts = {
      home = vim.fn.expand("~/wiki")
    },
  },

  -- Custom dashboard
  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      return dashboard
    end
  },

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
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "nvim-telescope/telescope-symbols.nvim",
        keys = {
          { "<leader>se", "<cmd>Telescope symbols<cr>", desc = "Emojis" }
        },
      }
    },
    opts = {
      defaults = {
        mappings = {
          i = {
                ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
                ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<C-k>"] = require("telescope.actions").move_selection_previous,
                ["<C-c>"] = require("telescope.actions").close,
          },
          n = {
                ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
                ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<C-k>"] = require("telescope.actions").move_selection_previous,
                ["<C-c>"] = require("telescope.actions").close,
          },
        },
      },
    },
    keys = {
      -- disable some keymaps
      { "<leader>/",  false },
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
    cmd = "DiffviewOpen",
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
    opts = {
      disabled_filetypes = {
        "Lazy",
        "mason",
        "neo-tree",
        "alpha",
        "help",
        "text",
        "markdown",
      },
    },
    event = {
      "BufReadPre",
      "BufNewFile",
    },
  },
}
