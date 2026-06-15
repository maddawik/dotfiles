return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Flash motion / treesitter selection
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      {
        "<c-space>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = { ["<c-space>"] = "next", ["<BS>"] = "prev" },
          })
        end,
        desc = "Treesitter Incremental Selection",
      },
    },
  },

  -- Diagnostics / quickfix / symbols panel
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },

  -- Treesitter-aware commenting
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Session management (used by snacks dashboard "Restore Session")
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
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

  -- Better splits and tmux navigation
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<C-h>", "<cmd>SmartCursorMoveLeft<CR>", mode = { "n", "t" }, desc = "Move to left split" },
      { "<C-j>", "<cmd>SmartCursorMoveDown<CR>", mode = { "n", "t" }, desc = "Move to lower split" },
      { "<C-k>", "<cmd>SmartCursorMoveUp<CR>", mode = { "n", "t" }, desc = "Move to upper split" },
      { "<C-l>", "<cmd>SmartCursorMoveRight<CR>", mode = { "n", "t" }, desc = "Move to right split" },
      { "<C-Up>", "<cmd>SmartResizeUp<CR>", mode = { "n", "t" }, desc = "Resize split up" },
      { "<C-Down>", "<cmd>SmartResizeDown<CR>", mode = { "n", "t" }, desc = "Resize split down" },
      { "<C-Left>", "<cmd>SmartResizeLeft<CR>", mode = { "n", "t" }, desc = "Resize split left" },
      { "<C-Right>", "<cmd>SmartResizeRight<CR>", mode = { "n", "t" }, desc = "Resize split right" },
    },
    opts = {},
  },

  -- Smart sort
  {
    "sQVe/sort.nvim",
    cmd = "Sort",
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
      { "gj", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  -- Dial (smart increment/decrement)
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement",
      },
    },
  },

  -- Yanky (better yank/paste with history)
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      {
        "<leader>p",
        function()
          Snacks.picker.yanky()
        end,
        mode = { "n", "x" },
        desc = "Open Yank History",
      },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
    },
    opts = {
      ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    },
  },

  -- Search and replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          require("grug-far").open({})
        end,
        desc = "Search & replace (grug-far)",
      },
      {
        "<leader>sr",
        function()
          require("grug-far").with_visual_selection({})
        end,
        mode = "v",
        desc = "Search & replace selection (grug-far)",
      },
    },
    opts = {},
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Prev TODO",
      },
    },
    opts = {
      signs = true,
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*:]],
      },
    },
  },

  -- Symbols outline
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    opts = {
      keymaps = {
        up_and_jump = "<up>",
        down_and_jump = "<down>",
      },
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
        end
        map("n", "]h", function()
          gs.nav_hunk("next")
        end, "Next hunk")
        map("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Prev hunk")
        map({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
      end,
    },
  },

  -- Code screenshots
  {
    "mistricky/codesnap.nvim",
    build = "make",
    cmd = {
      "CodeSnap",
      "CodeSnapHighlight",
      "CodeSnapSave",
      "CodeSnapSaveHighlight",
      "CodeSnapASCII",
    },
    keys = {
      { "<leader>us", ":CodeSnap<CR>", desc = "CodeSnap (clipboard)", mode = "x", silent = true },
      { "<leader>uS", ":CodeSnapSave<CR>", desc = "CodeSnap (~/codesnap)", mode = "x", silent = true },
      { "<leader>up", ":CodeSnapHighlight<CR>", desc = "CodeSnap Highlight (clipboard)", mode = "x", silent = true },
      { "<leader>uP", ":CodeSnapSaveHighlight<CR>", desc = "CodeSnap Highlight (~/codesnap)", mode = "x", silent = true },
      { "<leader>ua", ":CodeSnapASCII<CR>", desc = "CodeSnap ASCII", mode = "x", silent = true },
    },
    opts = {
      snapshot_config = { watermark = { content = "" } },
    },
  },
}
