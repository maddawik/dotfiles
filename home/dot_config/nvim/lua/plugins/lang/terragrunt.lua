return {
  {
    "gruntwork-io/terragrunt-ls",
    ft = "hcl",
    config = function()
      local ok, terragrunt_ls = pcall(require, "terragrunt-ls")
      if not ok then
        return
      end
      terragrunt_ls.setup({})
      if terragrunt_ls.client then
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "hcl",
          callback = function()
            vim.lsp.buf_attach_client(0, terragrunt_ls.client)
          end,
        })
      end
    end,
  },
}
