return {
  "neovim/nvim-lspconfig",
  ---@class pluginlspopts
  opts = {
    ---@type lspconfig.options
    servers = {
      ansiblels = {},
      bashls = {},
      -- gdscript = {
      --   on_attach = function(client)
      --     local _notify = client.notify
      --     client.notify = function(method, params)
      --       if method == "didchangeconfiguration" then
      --         return
      --       end
      --       _notify(method, params)
      --     end
      --   end,
      -- },
    },
  },
}
