local group = vim.api.nvim_create_augroup("user", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Close transient/utility windows with `q` (help, qf, checkhealth, notify, etc.)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dap-float",
    "fugitive",
    "git",
    "grug-far",
    "help",
    "mininotify-history",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "snacks_win",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("man_unlisted", { clear = true }),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local set = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
      -- which-key doesn't reliably pick up <leader>-prefixed buffer-local maps
      -- created this late (inside LspAttach, well after its own VeryLazy setup
      -- and initial group-spec registration) — register them explicitly too.
      if lhs:match("^<[Ll]eader>") and package.loaded["which-key"] then
        require("which-key").add({ lhs, mode = mode, buffer = ev.buf, desc = desc })
      end
    end
    -- Neovim 0.11+ ships global gr* default maps (grn/gra/grr/gri/grt/grx),
    -- which turn `gr` into a prefix and add a timeoutlen delay. Remove them so
    -- `gr` can map directly to references below.
    for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
      pcall(vim.keymap.del, "n", lhs)
    end
    set("n", "gd", require("maddawik.pickers").lsp_goto("definition"), "Go to definition")
    set("n", "gD", require("maddawik.pickers").lsp_goto("declaration"), "Go to declaration")
    set("n", "gr", require("maddawik.pickers").lsp_goto("references"), "References")
    set("n", "gI", require("maddawik.pickers").lsp_goto("implementation"), "Go to implementation")
    set("n", "gy", require("maddawik.pickers").lsp_goto("type_definition"), "Go to type definition")
    set("n", "<leader>ss", function()
      require("mini.extra").pickers.lsp({ scope = "document_symbol" })
    end, "Document symbols")
    set("n", "<leader>sS", function()
      require("mini.extra").pickers.lsp({ scope = "workspace_symbol_live" })
    end, "Workspace symbols")
    set("n", "K", vim.lsp.buf.hover, "Hover docs")
    set("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    set("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
  end,
})
