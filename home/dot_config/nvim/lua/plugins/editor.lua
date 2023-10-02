-- Editor settings not related to LSP, completion, etc.
local Util = require("lazyvim.util")

return {
  -- Custom dashboard
  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local doom = [[
=================     ===============     ===============   ========  ========
\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
||   .=='    _-'          `-__\._-'         `-_./__-'         `' |. /|  |   ||
||.=='    _-'                                                     `' |  /==.||
=='    _-'                                                            \/   `==
\   _-'                                                                `-_   /
 `''                                                                      ``'
      ]]

      local neovim = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

      dashboard.section.header.val = vim.split(neovim, "\n")
      -- dashboard.section.buttons.val = {
      --   dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
      --   dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
      --   dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
      --   dashboard.button("r", "󰗚 " .. " Projects", ":Telescope projects <CR>"),
      --   dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
      --   dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
      --   dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
      --   dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
      --   dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      -- }
      return dashboard
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    opts = {
      options = {
        show_buffer_close_icons = false,
        always_show_bufferline = true,
      },
    },
  },

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

  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
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
      layout = { align = "center", },
      show_help = false,
    },
  },

  -- Diffview
  {
    "sindrets/diffview.nvim",
    config = true,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" }
    },
  },

  -- Symbol outline
  {
    "simrat39/symbols-outline.nvim",
    keys = {
      { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" }
    },
    config = true,
  },

  -- Noice
  {
    "folke/noice.nvim",
    opts = {
      format = {
        spinner = {
          name = "moon"
        }
      },
    },
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
      -- level = vim.log.levels.WARN, -- help vim.log.levels
      render = "simple",
      stages = "static",
    },
  },

  -- Git good
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = "<author> <abbrev_sha> (<author_time:%Y-%m-%d>) <summary>"
    },
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("lazyvim.config").icons

      local function fg(name)
        return function()
          ---@diagnostic disable-next-line: undefined-field
          local hl = vim.api.nvim_get_hl_by_name(name, true)
          return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
        end
      end

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
          component_separators = '',
          -- section_separators = '',
        },
        extensions = { "neo-tree", "man", "symbols-outline" },
        sections = {
          -- lualine_a = {
          --   {
          --     -- mode component
          --     function()
          --       return ''
          --     end,
          --     padding = { left = 2, right = 2 },
          --   }
          -- },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
            {
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
            },
            "%=",
            {
              -- Lsp server name
              function()
                local msg = ''
                local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                  return msg
                end
                for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                  end
                end
                return msg
              end,
              icon = '  LSP:',
              color = fg("Special"),
            },
          },
          lualine_x = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_y = {
            { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            {
              "fileformat",
              padding = { left = 2, right = 2 },
            },
          },
        }
      }
    end,
  },

  -- Zettelkasten
  {
    'renerocksai/telekasten.nvim',
    keys = {
      { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>",     desc = "Show Backlinks" },
      { "<leader>zd", "<cmd>Telekasten goto_today<CR>",         desc = "Todays Note" },
      { "<leader>zf", "<cmd>Telekasten find_notes<CR>",         desc = "Find Notes" },
      { "<leader>zF", "<cmd>Telekasten find_friend_notes<CR>",  desc = "Friend Notes" },
      { "<leader>zg", "<cmd>Telekasten search_notes<CR>",       desc = "Grep Notes" },
      { "<leader>zi", "<cmd>Telekasten insert_link<CR>",        desc = "Insert Link" },
      { "<leader>zn", "<cmd>Telekasten new_note<CR>",           desc = "New Note" },
      { "<leader>zN", "<cmd>Telekasten new_templated_note<CR>", desc = "Templated Note" },
      { "<leader>zp", "<cmd>Telekasten panel<CR>",              desc = "Command Palette" },
      { "<leader>zr", "<cmd>Telekasten rename_note<CR>",        desc = "Rename Note" },
      { "<leader>zw", "<cmd>Telekasten goto_thisweek<CR>",      desc = "Weeks Note" },
      { "<leader>zy", "<cmd>Telekasten yank_link_to_note<CR>",  desc = "Yank Link" },
      { "<leader>zz", "<cmd>Telekasten follow_link<CR>",        desc = "Follow Link" },
    },
    init = function()
      require("which-key").register({ z = { name = "+zettelkasten", }, }, { prefix = "<leader>" })
    end,
    opts = {
      home = vim.fn.expand("~/.nb/zettelkasten"),
      template_new_note = vim.fn.expand("~/.nb/zettelkasten/templates/basenote.md"),
      template_new_daily = vim.fn.expand("~/.nb/zettelkasten/templates/daily.md"),
      template_new_weekly = vim.fn.expand("~/.nb/zettelkasten/templates/weekly.md"),
    },
  },

  -- Winbar
  {
    "utilyre/barbecue.nvim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    opts = {},
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
      { "<leader>S", "<esc><cmd>Sort<cr>",   desc = "Sort",        mode = "v" },
      { "<leader>U", "<esc><cmd>Sort u<cr>", desc = "Unique Sort", mode = "v" },
    },
  },

  -- Split/Join blocks of code
  {
    "Wansmer/treesj",
    keys = {
      { "gS", "<esc><cmd>TSJSplit<cr>", desc = "Split node under cursor" },
      { "gJ", "<esc><cmd>TSJJoin<cr>",  desc = "Join node under cursor", },
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
      require("which-key").register({ m = { name = "+markdown", }, }, { prefix = "<leader>" })
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<esc><cmd>MarkdownPreview<cr>",       desc = "Preview" },
      { "<leader>mt", "<esc><cmd>MarkdownPreviewToggle<cr>", desc = "Toggle" },
      { "<leader>ms", "<esc><cmd>MarkdownPreviewStop<cr>",   desc = "Stop" },
    },
  },

  -- Code Map
  {
    "gorbit99/codewindow.nvim",
    config = true,
    keys = {
      { "<leader>um", "<esc><cmd>lua require(\"codewindow\").toggle_minimap()<cr>", desc = "Toggle Minimap" },
    },
    opts = {
      window_border = "none",
      minimap_width = 15,
      show_cursor = false,
      screen_bounds = "background",
    },
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
        desc = "Search Worktrees"
      },
      {
        "<leader>gT",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "Search Worktrees"
      },
    },
  },

  {
    "nvim-telescope/telescope-symbols.nvim",
    keys = {
      { "<leader>se", "<cmd>Telescope symbols<cr>", desc = "Emojis" }
    },
  },

  -- Flash
  {
    "folke/flash.nvim",
    opts = {
      label = {
        rainbow = {
          enabled = true
        }
      }
    }
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
      }
    }
  },
}
