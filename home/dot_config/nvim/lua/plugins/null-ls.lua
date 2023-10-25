return {
--   "nvimtools/none-ls.nvim",
--   opts = function()
--     local nls = require("null-ls")
--     return {
--       sources = {
--         nls.builtins.diagnostics.actionlint,
--         nls.builtins.diagnostics.fish,
--         nls.builtins.formatting.fish_indent,
--         nls.builtins.diagnostics.gdlint.with({
--           command = vim.fn.expand("~/.pyenv/shims/gdlint"),
--         }),
--         nls.builtins.formatting.gdformat.with({
--           command = vim.fn.expand("~/.pyenv/shims/gdformat"),
--           extra_args = { "--line-length", "80" },
--         }),
--       },
--     }
--   end,
}
