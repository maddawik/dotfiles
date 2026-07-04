return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-mini/mini.icons" },
    opts = function()
      local icons = require("maddawik.icons")
      local root_dir = {
        function()
          local root = vim.fs.root(0, { ".git", "go.mod", "Makefile", ".luarc.json" })
          return root and (" " .. vim.fn.fnamemodify(root, ":t")) or ""
        end,
        cond = function()
          local root = vim.fs.root(0, { ".git", "go.mod", "Makefile", ".luarc.json" })
          return root ~= nil and vim.fs.normalize(root) ~= vim.fs.normalize(vim.fn.getcwd())
        end,
        color = function()
          return { fg = Snacks.util.color("Special") }
        end,
      }

      local term_apps = {
        { pat = "gh dash", icon = " ", name = "GitHub" },
        { pat = "claude", icon = " ", name = "Claude" },
        { pat = "lazygit", icon = "󰒲 ", name = "Lazygit" },
        { pat = "term", icon = " ", name = "Terminal" },
      }
      local function term_app()
        if vim.bo.buftype ~= "terminal" then
          return nil
        end
        local bufname = vim.api.nvim_buf_get_name(0)
        for _, app in ipairs(term_apps) do
          if bufname:match(app.pat) then
            return app
          end
        end
        return nil
      end

      -- Ported from LazyVim: lualine.utils.format_hl + pretty_path
      local function format_hl(component, text, hl_group)
        text = text:gsub("%%", "%%%%")
        if not hl_group or hl_group == "" then
          return text
        end
        component.hl_cache = component.hl_cache or {}
        local lualine_hl_group = component.hl_cache[hl_group]
        if not lualine_hl_group then
          local utils = require("lualine.utils.utils")
          local gui = vim.tbl_filter(function(x)
            return x
          end, {
            utils.extract_highlight_colors(hl_group, "bold") and "bold",
            utils.extract_highlight_colors(hl_group, "italic") and "italic",
          })
          lualine_hl_group = component:create_hl({
            fg = utils.extract_highlight_colors(hl_group, "fg"),
            gui = #gui > 0 and table.concat(gui, ",") or nil,
          }, "LV_" .. hl_group)
          component.hl_cache[hl_group] = lualine_hl_group
        end
        return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
      end

      local function pretty_path(self)
        local app = term_app()
        if app then
          return app.name
        end

        local path = vim.fn.expand("%:p") --[[@as string]]
        if path == "" then
          return ""
        end

        path = vim.fs.normalize(path)
        local root =
          vim.fs.normalize(vim.fs.root(0, { ".git", "go.mod", "Makefile", ".luarc.json" }) or vim.fn.getcwd())
        local cwd = vim.fs.normalize(vim.fn.getcwd())

        if path:find(cwd, 1, true) == 1 then
          path = path:sub(#cwd + 2)
        elseif path:find(root, 1, true) == 1 then
          path = path:sub(#root + 2)
        end

        local sep = package.config:sub(1, 1)
        local parts = vim.split(path, "[\\/]")

        if #parts > 3 then
          parts = { parts[1], "…", unpack(parts, #parts - 1, #parts) }
        end

        if vim.bo.modified then
          parts[#parts] = format_hl(self, parts[#parts] .. "", "MatchParen")
        else
          parts[#parts] = format_hl(self, parts[#parts], "Bold")
        end

        local dir = ""
        if #parts > 1 then
          dir = format_hl(self, table.concat({ unpack(parts, 1, #parts - 1) }, sep) .. sep, "")
        end

        return dir .. parts[#parts]
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
                if str:len() > 20 then
                  return str:sub(1, 20) .. "…"
                end
                return str
              end,
            },
          },
          lualine_c = {
            root_dir,
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              function()
                return term_app().icon
              end,
              cond = function()
                return term_app() ~= nil
              end,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            { pretty_path },
          },
          lualine_x = {
            {
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                  return ""
                end
                return " "
                  .. table.concat(
                    vim.tbl_map(function(c)
                      return c.name
                    end, clients),
                    " "
                  )
              end,
              cond = function()
                return #vim.lsp.get_clients({ bufnr = 0 }) > 0
              end,
              color = function()
                return { fg = Snacks.util.color("Special") }
              end,
            },
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
              source = function()
                local summary = vim.b.minidiff_summary
                return summary
                  and {
                    added = summary.add,
                    modified = summary.change,
                    removed = summary.delete,
                  }
              end,
            },
          },
          lualine_y = {
            {
              "fileformat",
              padding = { left = 1, right = 2 },
              cond = function()
                return vim.bo.fileformat ~= "unix"
              end,
            },
            {
              "encoding",
              padding = { left = 0, right = 1 },
              cond = function()
                return (vim.bo.fileencoding or vim.o.encoding) ~= "utf-8"
              end,
            },
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
