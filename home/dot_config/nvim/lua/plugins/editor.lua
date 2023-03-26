-- Editor settings not related to LSP, completion, etc.
local Util = require("lazyvim.util")

return {
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
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      return dashboard
    end,
    keys = {
      { "<leader>d", "<cmd>Alpha<cr>", desc = "Dashboard" }
    },
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

  -- Smart scrollbar
  {
    "lewis6991/satellite.nvim",
    opts = {
      winblend = 10,
      excluded_filetypes = {
        "lazy",
        "alpha",
        "mason",
        "neo-tree",
      },
    },
    event = "VeryLazy",
  },

  -- Noice
  {
    "folke/noice.nvim",
    opts = {
      format = {
        spinner = {
          name = "moon"
        }
      }
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
          lualine_a = {
            {
              -- mode component
              function()
                return ''
              end,
              padding = { left = 2, right = 2 },
            }
          },
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
            "%=",
            {
              -- Lsp server name .
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
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = fg("Constant"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Statement") },
            { "encoding", },
            { "fileformat", },
          },
          lualine_z = {
            function()
              local time = os.date("%I:%M %p")
              return " " .. time
            end,
          },
        }
      }
    end,
  },

  -- Zettelkasten
  {
    'renerocksai/telekasten.nvim',
    dependencies = {
      {
        "renerocksai/calendar-vim",
        event = "VeryLazy"
      }
    },
    keys = {
      { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>",     desc = "Show Backlinks" },
      { "<leader>zc", "<cmd>Telekasten show_calendar<CR>",      desc = "Show Calendar" },
      { "<leader>zC", "<cmd>CalendarT<CR>",                     desc = "Full Calendar" },
      { "<leader>zd", "<cmd>Telekasten goto_today<CR>",         desc = "Todays Note" },
      { "<leader>zf", "<cmd>Telekasten find_notes<CR>",         desc = "Find Notes" },
      { "<leader>zF", "<cmd>Telekasten find_friend_notes<CR>",  desc = "Friend Notes" },
      { "<leader>zg", "<cmd>Telekasten search_notes<CR>",       desc = "Grep Notes" },
      { "<leader>zi", "<cmd>Telekasten insert_link<CR>",        desc = "Insert Link" },
      { "<leader>zn", "<cmd>Telekasten new_note<CR>",           desc = "New Note" },
      { "<leader>zN", "<cmd>Telekasten new_templated_note<CR>", desc = "Templated Note" },
      { "<leader>zp", "<cmd>Telekasten panel<CR>",              desc = "Command Palette" },
      { "<leader>zr", "<cmd>Telekasten rename_note<CR>",        desc = "Rename Note" },
      { "<leader>zt", "<cmd>Telekasten toggle_todo<CR>",        desc = "Toggle Todo" },
      { "<leader>zw", "<cmd>Telekasten goto_thisweek<CR>",      desc = "Weeks Note" },
      { "<leader>zy", "<cmd>Telekasten yank_link_to_note<CR>",  desc = "Yank Link" },
      { "<leader>zz", "<cmd>Telekasten follow_link<CR>",        desc = "Follow Link" },
    },
    init = function()
      require("which-key").register({ z = { name = "+zettelkasten", }, }, { prefix = "<leader>" })
    end,
    opts = {
      home = vim.fn.expand("~/zettelkasten"),
      template_new_note = vim.fn.expand("~/zettelkasten/templates/basenote.md"),
      template_new_daily = vim.fn.expand("~/zettelkasten/templates/daily.md"),
      template_new_weekly = vim.fn.expand("~/zettelkasten/templates/weekly.md"),
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

  -- Smart cursor column
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      disabled_filetypes = {
        "lazy",
        "alpha",
        "help",
        "markdown",
        "mason",
        "md",
        "neo-tree",
        "text",
      },
    },
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
}
