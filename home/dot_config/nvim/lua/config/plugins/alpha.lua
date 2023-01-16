local M = {
  "goolord/alpha-nvim",
  lazy = false,
}

function M.config()
  local dashboard = require("alpha.themes.dashboard")

  dashboard.section.header.val = {
    [[                                                                       ]],
    [[  ██████   █████                   █████   █████  ███                  ]],
    [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
    [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
    [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
    [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
    [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
    [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
    [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
    [[                                                                       ]],
  }
  dashboard.section.buttons.val = {
    dashboard.button("<Leader>n", " " .. " New file", ":ene <CR>"),
    dashboard.button("<Leader><Space>", " " .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("<Leader>fg", " " .. " Find grep", ":Telescope live_grep <CR>"),
    dashboard.button("<Leader>fp", " " .. " Find project", ":Telescope projects<CR>"),
    dashboard.button("<Leader>fo", " " .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("q", " " .. " Quit", ":qa<CR>"),
  }

  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.footer.val = {
    [[                                                                       ]],
    [[                                                                       ]],
    [[                  Don't regret your past, learn from it                ]],
    [[                    Regrets just make a person weaker                  ]],
    [[                                                                       ]],
    [[                              Solid Snake                            ]],
  }

  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"

  dashboard.opts.opts.noautocmd = true

  require("alpha").setup(dashboard.opts)
end

return M
