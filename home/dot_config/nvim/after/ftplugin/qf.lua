-- Easily delete quickfix items
local del_qf_item = function()
  local items = vim.fn.getqflist()
  local first = vim.fn.line("v")
  local last = vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  for _ = first, last do
    table.remove(items, first)
  end
  vim.fn.setqflist(items, "r")
  local new_line = math.min(first, #items)
  if new_line > 0 then
    vim.api.nvim_win_set_cursor(0, { new_line, 0 })
  end

  -- Exit visual mode after deletion
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
end

vim.keymap.set("n", "dd", del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })
vim.keymap.set("v", "d", del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })
