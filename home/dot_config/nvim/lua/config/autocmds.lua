-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_config_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("commentstring"),
  pattern = { "gd", "gdscript" },
  callback = function()
    vim.b.commentstring = "# %s"
  end,
  desc = "Change commentstring for gdscript files",
})
