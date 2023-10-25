return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
    "chrisgrieser/cmp-nerdfont",
    { "mtoohey31/cmp-fish", ft = "fish" },
  },
  opts = function(_, opts)
    local cmp = require("cmp")

    cmp.setup({
      window = {
        -- completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })
    opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      { name = "fish" },
      { name = "emoji" },
      { name = "nerdfont" },
    }))
  end,
}
