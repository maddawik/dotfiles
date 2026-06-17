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
    set("n", "gd", vim.lsp.buf.definition, "Go to definition")
    set("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    set("n", "gr", vim.lsp.buf.references, "References")
    set("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
    set("n", "K", vim.lsp.buf.hover, "Hover docs")
    set("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    set("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
  end,
})
