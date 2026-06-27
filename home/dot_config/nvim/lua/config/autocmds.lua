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
    end
    -- Neovim 0.11+ ships global gr* default maps (grn/gra/grr/gri/grt/grx),
    -- which turn `gr` into a prefix and add a timeoutlen delay. Remove them so
    -- `gr` can map directly to references below.
    for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
      pcall(vim.keymap.del, "n", lhs)
    end
    set("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, "Go to definition")
    set("n", "gD", function()
      Snacks.picker.lsp_declarations()
    end, "Go to declaration")
    set("n", "gr", function()
      Snacks.picker.lsp_references()
    end, "References")
    set("n", "gI", function()
      Snacks.picker.lsp_implementations()
    end, "Go to implementation")
    set("n", "gy", function()
      Snacks.picker.lsp_type_definitions()
    end, "Go to type definition")
    set("n", "<leader>ss", function()
      Snacks.picker.lsp_symbols()
    end, "Document symbols")
    set("n", "K", vim.lsp.buf.hover, "Hover docs")
    set("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    set("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
  end,
})
