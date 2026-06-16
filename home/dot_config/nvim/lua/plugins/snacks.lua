return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      animate = { enabled = false },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      indent = {
        enabled = true,
        animate = { enabled = false },
        filter = function(buf, win)
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
            and not vim.w[win].snacks_picker_preview
        end,
      },
      scroll = { enabled = false },
      dim = { animate = { enabled = false } },
      input = {
        enabled = true,
      },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      notifier = {
        margin = { top = 1 },
        style = "compact",
      },
      terminal = {
        win = { wo = { winbar = "" } },
      },
      picker = {
        previewers = {
          diff = { native = true },
          git = { native = true },
        },
        win = {
          input = {
            keys = {
              ["<c-e>"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["<c-y>"] = { "preview_scroll_right", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<c-e>"] = "preview_scroll_left",
              ["<c-y>"] = "preview_scroll_right",
            },
          },
        },
      },
      zen = {
        win = { backdrop = { transparent = false } },
      },
      image = { enabled = true },
      dashboard = {
        preset = {
          header = false,
          keys = {
            { icon = " ", key = "d", desc = "Daily Note", action = ":Obsidian dailies" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            {
              icon = " ",
              key = "z",
              desc = "Chezmoi",
              action = function()
                local src = vim.fn.system({ "chezmoi", "source-path" }):gsub("%s+$", "")
                Snacks.dashboard.pick("files", { cwd = src })
              end,
            },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        width = 30,
        sections = {
          { section = "keys", gap = 0, padding = 1 },
          { text = { require("maddawik.dashboard").get_quote(), hl = "Comment", align = "center" } },
          { section = "startup" },
        },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Snacks toggles need to run AFTER Snacks.setup()
      Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.line_number():map("<leader>ul")
      Snacks.toggle
        .option("conceallevel", {
          off = 0,
          on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
          name = "Conceal Level",
        })
        :map("<leader>uc")
      Snacks.toggle
        .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
        :map("<leader>uA")
      Snacks.toggle.treesitter():map("<leader>uT")
      Snacks.toggle({
        name = "Treesitter Context",
        get = function()
          return require("treesitter-context").enabled()
        end,
        set = function(state)
          if state then
            require("treesitter-context").enable()
          else
            require("treesitter-context").disable()
          end
        end,
      }):map("<leader>ut")
      Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
      Snacks.toggle.dim():map("<leader>uD")
      Snacks.toggle.indent():map("<leader>ug")
      Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
      Snacks.toggle.zen():map("<leader>uz")
      if vim.lsp.inlay_hint then
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end
      Snacks.toggle({
        name = "Auto Format",
        get = function()
          return not vim.g.disable_autoformat
        end,
        set = function(state)
          vim.g.disable_autoformat = not state
        end,
      }):map("<leader>uf")
      vim.keymap.set("n", "<leader>uC", function()
        Snacks.picker.colorschemes()
      end, { desc = "Colorscheme" })
    end,
  },
}
