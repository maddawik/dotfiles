local mini = {
  "echasnovski/mini.nvim",
  event = "VeryLazy",
}

local specs = { mini, "JoosepAlviste/nvim-ts-context-commentstring" }

function mini.animate()
  require("mini.animate").setup({
    cursor = {
      enable = false,
    },
    resize = {
      enable = false,
    },
    open = {
      enable = false,
    },
    close = {
      enable = false,
    },
  })
end

function mini.pairs()
  require("mini.pairs").setup({})
end

function mini.comment()
  require("mini.comment").setup({
    hooks = {
      pre = function()
        require("ts_context_commentstring.internal").update_commentstring({})
      end,
    },
  })
end

function mini.config()
  mini.pairs()
  mini.comment()
  mini.animate()
end

return specs
