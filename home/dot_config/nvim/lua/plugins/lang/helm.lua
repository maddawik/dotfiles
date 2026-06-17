if vim.fn.executable("helm") ~= 1 then
  return {}
end

return {
  -- Auto-detect helm filetype on chart templates so yamlls doesn't attach
  -- (helm_ls handles them instead, configured in plugins/lsp.lua).
  { "qvalentin/helm-ls.nvim", ft = "helm", opts = {} },
}