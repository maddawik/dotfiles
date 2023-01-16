local M = {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPre",
}

function M.setup()
  local nls = require("null-ls")
  nls.setup({
    debounce = 150,
    save_after_format = false,
    sources = {
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.fish_indent,
      nls.builtins.formatting.shfmt,
      nls.builtins.diagnostics.markdownlint,
    },
  })
end

function M.has_formatter(ft)
  local sources = require("null-ls.sources")
  local available = sources.get_available(ft, "NULL_LS_FORMATTING")
  return #available > 0
end

return M
