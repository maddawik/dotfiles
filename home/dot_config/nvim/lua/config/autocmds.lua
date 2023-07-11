local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_config_" .. name, { clear = true })
end
local create_autocmd = vim.api.nvim_create_autocmd

create_autocmd("FileType", {
  group = augroup("comment_string"),
  pattern = { "gdscript" },
  callback = function()
    vim.b.commentstring = "# %s"
  end,
  desc = "Change commentstring for gdscript files",
})

create_autocmd("FileType", {
  group = augroup("indent"),
  pattern = { "fish" },
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = true
  end,
  desc = "Change indenting for fish files",
})

local set_toggle = augroup("set_toggle")
create_autocmd("InsertEnter", {
  callback = function()
    if vim.bo.filetype ~= "alpha"
        and vim.bo.filetype ~= "neo-tree"
        and vim.bo.filetype ~= "TelescopePrompt"
        and vim.bo.filetype ~= "mason"
        and vim.bo.filetype ~= "help"
        and vim.bo.filetype ~= "Trouble"
        and vim.bo.filetype ~= "SidebarNvim" then
      vim.opt.relativenumber = true
      vim.opt.list = true
    end
  end,
  group = set_toggle,
})

create_autocmd({ "VimEnter", "BufEnter", "InsertLeave" }, {
  callback = function()
    if vim.bo.filetype ~= "alpha"
        and vim.bo.filetype ~= "neo-tree"
        and vim.bo.filetype ~= "TelescopePrompt"
        and vim.bo.filetype ~= "mason"
        and vim.bo.filetype ~= "help"
        and vim.bo.filetype ~= "Trouble"
        and vim.bo.filetype ~= "SidebarNvim" then
      vim.opt.relativenumber = false
      vim.opt.list = false
    end
  end,
  group = set_toggle,
})
