return {
  "folke/persistence.nvim",
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      nested = true,
      once = true,
      callback = function()
        if vim.fn.argc() == 0 then
          require("persistence").load()
        end
      end,
    })
  end,
}