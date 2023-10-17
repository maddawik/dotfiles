-- Editor settings not related to LSP, completion, etc.
local Util = require("lazyvim.util")

return {
  -- Scoped buffers
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Better splits and tmux navigation
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

  -- Colors
  {
    "NvChad/nvim-colorizer.lua",
    lazy = false,
    config = true,
    opts = {
      filetypes = {
        html = { mode = "foreground" },
        "css",
        "javascript",
        "typescript",
        lua = { names = false },
        vim = { names = false },
      },
    },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
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
      { "<leader>/", false },
      -- add live grep and word search keymaps
      { "<leader>fg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
      { "<leader>fG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>fw", Util.telescope("grep_string"), desc = "Word (root dir)" },
      { "<leader>fW", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
      -- add a keymap to browse plugin files
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
  },

  -- More intuitive motions for w, e, and b
  {
    "chrisgrieser/nvim-spider",
    init = function()
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
    end,
    enabled = false,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    opts = {
      -- window = { winblend = 10 },
      layout = { align = "center" },
      show_help = false,
    },
  },

  -- Diffview
  {
    "sindrets/diffview.nvim",
    config = true,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
    },
  },

  -- Noice
  {
    "folke/noice.nvim",
    opts = {
      format = {
        spinner = {
          name = "moon",
        },
      },
    },
  },

  -- Zettelkasten
  {
    "renerocksai/telekasten.nvim",
    keys = {
      { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", desc = "Show Backlinks" },
      { "<leader>zd", "<cmd>Telekasten goto_today<CR>", desc = "Todays Note" },
      { "<leader>zf", "<cmd>Telekasten find_notes<CR>", desc = "Find Notes" },
      { "<leader>zF", "<cmd>Telekasten find_friend_notes<CR>", desc = "Friend Notes" },
      { "<leader>zg", "<cmd>Telekasten search_notes<CR>", desc = "Grep Notes" },
      { "<leader>zi", "<cmd>Telekasten insert_link<CR>", desc = "Insert Link" },
      { "<leader>zn", "<cmd>Telekasten new_note<CR>", desc = "New Note" },
      { "<leader>zN", "<cmd>Telekasten new_templated_note<CR>", desc = "Templated Note" },
      { "<leader>zp", "<cmd>Telekasten panel<CR>", desc = "Command Palette" },
      { "<leader>zr", "<cmd>Telekasten rename_note<CR>", desc = "Rename Note" },
      { "<leader>zw", "<cmd>Telekasten goto_thisweek<CR>", desc = "Weeks Note" },
      { "<leader>zy", "<cmd>Telekasten yank_link_to_note<CR>", desc = "Yank Link" },
      { "<leader>zz", "<cmd>Telekasten follow_link<CR>", desc = "Follow Link" },
    },
    init = function()
      require("which-key").register({ z = { name = "+zettelkasten" } }, { prefix = "<leader>" })
    end,
    opts = {
      auto_set_filetype = false,
      home = vim.fn.expand("~/.nb/zettelkasten"),
      template_new_note = vim.fn.expand("~/.nb/zettelkasten/templates/basenote.md"),
      template_new_daily = vim.fn.expand("~/.nb/zettelkasten/templates/daily.md"),
      template_new_weekly = vim.fn.expand("~/.nb/zettelkasten/templates/weekly.md"),
    },
  },

  -- Super smart column status
  {
    "Bekaboo/deadcolumn.nvim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
  },

  -- Smart sort
  {
    "sQVe/sort.nvim",
    config = true,
    keys = {
      { "<leader>S", "<esc><cmd>Sort<cr>", desc = "Sort", mode = "v" },
      { "<leader>U", "<esc><cmd>Sort u<cr>", desc = "Unique Sort", mode = "v" },
    },
  },

  -- Split/Join blocks of code
  {
    "Wansmer/treesj",
    keys = {
      { "gS", "<esc><cmd>TSJSplit<cr>", desc = "Split node under cursor" },
      { "gJ", "<esc><cmd>TSJJoin<cr>", desc = "Join node under cursor" },
    },
    config = true,
  },

  -- Super GitHub Integration
  {
    "pwntester/octo.nvim",
    config = true,
    cmd = "Octo",
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      require("which-key").register({ m = { name = "+markdown" } }, { prefix = "<leader>" })
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<esc><cmd>MarkdownPreview<cr>", desc = "Preview" },
      { "<leader>mt", "<esc><cmd>MarkdownPreviewToggle<cr>", desc = "Toggle" },
      { "<leader>ms", "<esc><cmd>MarkdownPreviewStop<cr>", desc = "Stop" },
    },
  },

  -- Code Map
  {
    "gorbit99/codewindow.nvim",
    config = true,
    keys = {
      { "<leader>um", '<esc><cmd>lua require("codewindow").toggle_minimap()<cr>', desc = "Toggle Minimap" },
    },
    opts = {
      window_border = "none",
      minimap_width = 15,
      show_cursor = false,
      screen_bounds = "background",
    },
    enabled = false,
  },

  -- Worktrees dude
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("git_worktree")
    end,
    keys = {
      {
        "<leader>gt",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "Search Worktrees",
      },
      {
        "<leader>gT",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "Search Worktrees",
      },
    },
    enabled = false,
  },

  {
    "nvim-telescope/telescope-symbols.nvim",
    keys = {
      { "<leader>se", "<cmd>Telescope symbols<cr>", desc = "Emojis" },
    },
  },

  -- Flash
  {
    "folke/flash.nvim",
    opts = {
      label = {
        rainbow = {
          enabled = true,
        },
      },
    },
  },

  -- Twilight
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    keys = { { "<leader>ut", "<cmd>Twilight<cr>", desc = "Toggle Twilight" } },
  },

  -- Zen-mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle Zen-Mode" } },
    opts = {
      plugins = {
        tmux = { enabled = true },
      },
    },
  },
}
