local opt = vim.opt
opt.colorcolumn = "80"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 20
opt.foldmethod = "expr"
-- opt.listchars = {
--   space = ".",
--   eol = "↲",
--   nbsp = "␣",
--   trail = "·",
--   precedes = "←",
--   extends = "→",
--   tab = "¬ ",
--   conceal = "※",
-- }
