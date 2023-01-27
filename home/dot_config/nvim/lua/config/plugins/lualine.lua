local M = {
  "nvim-lualine/lualine.nvim",
  lazy = false,
}

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn", "hint", "info" },
  symbols = { error = " ", warn = " ", hint = " ", info = " " },
  colored = true,
  always_visible = false,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

local filetype = {
  "filetype",
  icons_enabled = true,
}

local location = {
  "location",
  padding = 0,
}

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

function M.config()
  require("lualine").setup({
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = "auto",
      disabled_filetypes = {
        "alpha",
        "dashboard",
        "lazy",
        "mason",
        "neo-tree",
        "neo-tree-popup",
        "toggleterm",
        "TelescopePrompt",
      },
      always_divide_middle = false,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { diagnostics },
      lualine_x = { diff, spaces, filetype },
      lualine_y = { location },
      lualine_z = { "progress" },
    },
  })
end

return M
