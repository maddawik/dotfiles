return {
  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".chezmoiignore"] = { glyph = "", hl = "MiniIconsGrey" },
        [".chezmoiremove"] = { glyph = "", hl = "MiniIconsGrey" },
        [".chezmoiroot"] = { glyph = "", hl = "MiniIconsGrey" },
        [".chezmoiversion"] = { glyph = "", hl = "MiniIconsGrey" },
        ["bash.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        ["fish.tmpl"] = { glyph = "󰈺", hl = "MiniIconsGrey" },
        ["json.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        ["sh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        ["toml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        ["yaml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  { "nvim-mini/mini.surround", event = "VeryLazy", opts = {} },
  { "nvim-mini/mini.pairs", event = "VeryLazy", opts = {} },
  { "nvim-mini/mini.ai", event = "VeryLazy", opts = {} },
  { "nvim-mini/mini.move", event = "VeryLazy", opts = {} },
  { "nvim-mini/mini.tabline", event = { "BufReadPost", "BufNewFile" }, opts = {} },
  { "nvim-mini/mini.hipatterns", event = "VeryLazy", opts = {} },
  {
    "nvim-mini/mini.diff",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
    },
    opts = {
      view = { style = "sign", signs = { add = "▎", change = "▎", delete = "" } },
    },
    config = function(_, opts)
      require("mini.diff").setup(opts)
      Snacks.toggle({
        name = "Mini Diff Signs",
        get = function()
          return vim.g.minidiff_disable ~= true
        end,
        set = function(state)
          vim.g.minidiff_disable = not state
          if state then
            require("mini.diff").enable(0)
          else
            require("mini.diff").disable(0)
          end
          -- HACK: redraw to update the signs
          vim.defer_fn(function()
            vim.cmd([[redraw!]])
          end, 200)
        end,
      }):map("<leader>uG")
    end,
  },

  {
    "nvim-mini/mini.files",
    lazy = false,
    keys = {
      {
        "\\",
        function()
          local MiniFiles = require("mini.files")
          if not MiniFiles.close() then
            MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
          end
        end,
        desc = "Open files (current buffer dir)",
      },
      {
        "<leader>e",
        function()
          local MiniFiles = require("mini.files")
          if not MiniFiles.close() then
            local root = vim.fs.root(0, { ".git", "go.mod", "Makefile" }) or vim.fn.getcwd()
            MiniFiles.open(root, true)
          end
        end,
        desc = "Open files (root dir)",
      },
      {
        "<leader>E",
        function()
          local MiniFiles = require("mini.files")
          if not MiniFiles.close() then
            MiniFiles.open(nil, false)
          end
        end,
        desc = "Open files (cwd)",
      },
    },
    opts = {
      mappings = { synchronize = "<CR>" },
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
      options = { use_as_default_explorer = true },
    },
    config = function(_, opts)
      local MiniFiles = require("mini.files")
      MiniFiles.setup(opts)

      local yank_path = function()
        local entry = MiniFiles.get_fs_entry()
        if not entry then
          return Snacks.notify.warn("Cursor is not on valid entry")
        end
        vim.fn.setreg(vim.v.register, entry.path)
        Snacks.notify.info("Copied path to clipboard")
      end

      local set_cwd = function()
        local entry = MiniFiles.get_fs_entry()
        if not entry then
          return Snacks.notify.warn("Cursor is not on valid entry")
        end
        local dir = vim.fs.dirname(entry.path)
        vim.fn.chdir(dir)
        Snacks.notify.info("cwd: " .. vim.fn.fnamemodify(dir, ":~"))
      end

      local grug_far_in_dir = function()
        local entry = MiniFiles.get_fs_entry()
        if not entry then
          return Snacks.notify.warn("Cursor is not on valid entry")
        end
        local grug_far = require("grug-far")
        local prefills = { paths = vim.fs.dirname(entry.path) }
        if not grug_far.has_instance("explorer") then
          grug_far.open({
            instanceName = "explorer",
            prefills = prefills,
            staticTitle = "Find and Replace from Explorer",
          })
        else
          grug_far.get_instance("explorer"):open()
          grug_far.get_instance("explorer"):update_input_values(prefills, false)
        end
      end

      local show_dotfiles = true
      local filter_show = function()
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        MiniFiles.refresh({ content = { filter = show_dotfiles and filter_show or filter_hide } })
      end

      local map_split = function(buf_id, lhs, direction, close_on_file)
        local rhs = function()
          local target = MiniFiles.get_explorer_state().target_window
          if target == nil then
            return
          end
          local new_target
          vim.api.nvim_win_call(target, function()
            vim.cmd("belowright " .. direction .. " split")
            new_target = vim.api.nvim_get_current_win()
          end)
          MiniFiles.set_target_window(new_target)
          MiniFiles.go_in({ close_on_file = close_on_file })
        end
        local desc = "Open in " .. direction .. " split" .. (close_on_file and " and close" or "")
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local b = args.data.buf_id
          vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
          vim.keymap.set("n", "gs", grug_far_in_dir, { buffer = b, desc = "Search in directory" })
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = b, desc = "Toggle hidden files" })
          vim.schedule(function()
            vim.keymap.set("n", "gc", set_cwd, { buffer = b, desc = "Set cwd" })
          end)
          map_split(b, "<C-w>s", "horizontal", false)
          map_split(b, "<C-w>v", "vertical", false)
          map_split(b, "<C-w>S", "horizontal", true)
          map_split(b, "<C-w>V", "vertical", true)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          if Snacks and Snacks.rename then
            Snacks.rename.on_rename_file(event.data.from, event.data.to)
          end
        end,
      })
    end,
  },
}
