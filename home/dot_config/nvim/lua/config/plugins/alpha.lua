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
    dashboard.button("<Leader>n", " " .. " New file", "<cmd>ene<cr>"),
    dashboard.button("<Leader><Space>", " " .. " Find file", "<cmd>Telescope find_files<cr>"),
    dashboard.button("<Leader>fg", " " .. " Find grep", "<cmd>Telescope live_grep<cr>"),
    dashboard.button("<Leader>fo", " " .. " Recent files", "<cmd>Telescope oldfiles<cr>"),
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
