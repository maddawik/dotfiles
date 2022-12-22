local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local dashboard = require "alpha.themes.dashboard"
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
  dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
  dashboard.button("g", " " .. " Find grep", ":Telescope live_grep <CR>"),
  dashboard.button("p", " " .. " Find project", ":Telescope projects<CR>"),
  dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("1", " " .. " Neovim", ":e $MYVIMRC <CR>"),
  dashboard.button("2", "🎣" .. " Fish", ":e ~/.config/fish/config.fish <CR>"),
  dashboard.button("3", " " .. " Tmux", ":e ~/.tmux.conf.local <CR>"),
  dashboard.button("q", " " .. " Quit", ":qa<CR>"),
}

dashboard.section.footer.opts.hl = "Type"
dashboard.section.footer.val = {
  [[                                                                       ]],
	[[                                                                       ]],
	[[                   Don't regret your past, learn from it               ]],
  [[                     Regrets just make a person weaker                 ]],
	[[                                                                       ]],
	[[                               Solid Snake                           ]],
}

dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)

-- Open Alpha Dashboard when all other buffers are closed
local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "BDeletePost*",
  group = alpha_on_empty,

  callback = function(event)
    local fallback_name = vim.api.nvim_buf_get_name(event.buf)
    local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
    local fallback_on_empty = fallback_name == "" and fallback_ft == ""
    if fallback_on_empty then
      local ok, _ = pcall(require, "neo-tree")

      if not ok then
        vim.cmd("packadd neo-tree")
        -- Use the latest recommended approach to handle Neotree. See the docs for info:
        -- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/ab8ca9fac52949d7a741b538c5d9c3898cd0f45a/doc/neo-tree.txt#L140
        vim.cmd("Neotree close")
      end

      vim.cmd("Alpha")
      vim.cmd(event.buf .. "bwipeout")
    end
  end,
})
