-- Colors
return {
  { "ellisonleao/gruvbox.nvim",         event = "VeryLazy" },
  { "overcache/neosolarized",           event = "VeryLazy" },
  { "rebelot/kanagawa.nvim",            event = "VeryLazy" },
  { "catppuccin/nvim",                  event = "VeryLazy" },
  { "nyoom-engineering/oxocarbon.nvim", event = "VeryLazy" },
  { "whatyouhide/vim-gotham",           event = "VeryLazy" },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  -- set default colors
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-moon",
    },
  },
}
