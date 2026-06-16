return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-mini/mini.icons" },
    opts = function()
      local icons = require("maddawik.icons")
      local function root_dir()
        local root = vim.fs.root(0, { ".git", "go.mod", "Makefile", ".luarc.json" })
        if root then
          return vim.fn.fnamemodify(root, ":t")
        end
        return ""
      end

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function()
                return "󰽯 "
              end,
            },
          },
          lualine_b = {
            {
              "branch",
              fmt = function(str)
                if str:len() > 6 then
                  return str:sub(1, 6) .. "…"
                end
                return str
              end,
            },
          },
          lualine_c = {
            { root_dir },
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
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1 },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.mode.get():gsub("recording", " ")
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = function()
                return { fg = Snacks.util.color("Constant") }
              end,
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = function()
                return { fg = Snacks.util.color("Debug") }
              end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
            { "filesize", padding = { left = 0, right = 1 } },
          },
          lualine_y = {
            { "fileformat", padding = { left = 1, right = 2 } },
            { "encoding", padding = { left = 0, right = 1 } },
          },
          lualine_z = { "location" },
        },
        extensions = { "lazy" },
      }
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<leader>snt",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = { enabled = false },
      },
      cmdline = { view = "cmdline" },
      format = {
        spinner = { name = "moon" },
      },
      presets = {
        command_palette = false,
        long_message_to_split = true,
      },
      views = {
        mini = { size = { max_height = 8 } },
      },
      routes = {
        {
          filter = { event = "msg_show", find = "written" },
          view = "mini",
        },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        -- Groups which-key auto-detects icons for (don't override):
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "test" },
        { "<leader>u", group = "ui" },
        { "<leader>a", group = "ai", mode = { "n", "v" } },
        { "<leader>sn", group = "noice" },

        -- Groups which-key does NOT auto-resolve; explicit icons via \u{} escape:
        { "<leader>o", group = "notes", icon = { icon = " ", color = "purple" }, mode = { "n", "v" } },
        { "<leader>w", group = "windows", proxy = "<c-w>" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader><tab>", group = "tabs" },

        { "<leader>S", icon = " ", mode = "v" },
        { "<leader>U", icon = "󱎅 ", mode = "v" },
      },
    },
  },
}
