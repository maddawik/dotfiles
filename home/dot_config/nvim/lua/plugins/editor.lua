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
      home = vim.fn.expand("~/zettelkasten/"),
      template_new_note = vim.fn.expand("~/zettelkasten/templates/basenote.md"),
      template_new_daily = vim.fn.expand("~/zettelkasten/templates/daily.md"),
      template_new_weekly = vim.fn.expand("~/zettelkasten/templates/weekly.md"),
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
    end,
    keys = {
      { "<leader>d", "<cmd>Alpha<cr>", desc = "Dashboard" }
    },
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
      { "<leader>,",  false },
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
    },
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
      current_line_blame_formatter = "<abbrev_sha> (<author_time:%Y-%m-%d>) <summary>"
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
          ---@type {foreground?:number}?
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
          lualine_b = { "branch" },
          lualine_c = {
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = {
                left = 1, right = 0
              }
            },
            {
              "filename",
              symbols = {
                modified = "  ",
                readonly = " ",
                unnamed = ""
              }
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
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
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = fg("Constant"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Statement") },
            { "fileformat" },
          },
        }
      }
    end,
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
        "Lazy",
        "mason",
        "neo-tree",
        "alpha",
        "help",
        "text",
        "markdown",
        "md",
      },
    },
    event = {
      "BufReadPre",
      "BufNewFile",
    },
  },
}
