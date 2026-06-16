local map = vim.keymap.set

-- ── Editing basics ──────────────────────────────────────────────────────────
map("i", "jk", "<ESC>")
map("s", "<BS>", "<BS>i")

-- Better up/down (wrap-aware)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Clear search on Escape
map({ "i", "n", "s" }, "<Esc>", function()
  vim.cmd("noh")
  return "<Esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Save file
map({ "n", "i", "v", "s" }, "<C-s>", "<cmd>w<cr><Esc>", { desc = "Save file" })

-- Keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Better indenting (keep selection)
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Center cursor on search (skipped <C-d>/<C-u> centering — those remaps
-- register the keys in the which-key tree, breaking popup scroll at root)
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Commenting: add comment above/below
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- ── Move lines (Alt-j / Alt-k) ──────────────────────────────────────────────
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- ── Buffer navigation ───────────────────────────────────────────────────────
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- ── Diagnostic / quickfix navigation ────────────────────────────────────────
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Quickfix / location list toggles
map("n", "<leader>xl", function()
  local ok, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not ok and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })
map("n", "<leader>xq", function()
  local ok, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not ok and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })
-- [q / ]q are defined by trouble.nvim in plugins/editor.lua (smarter — uses trouble if open)

-- ── Scratch buffers ─────────────────────────────────────────────────────────
map("n", "<leader>.", function()
  Snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>S", function()
  Snacks.scratch.select()
end, { desc = "Select Scratch Buffer" })

-- ── Quit / Lazy / New file ──────────────────────────────────────────────────
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit All (force)" })
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- ── Code / LSP custom ───────────────────────────────────────────────────────
map({ "n", "x" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })

map("n", "<leader>cw", function()
  local orig = vim.lsp.handlers["textDocument/rename"]
  vim.lsp.handlers["textDocument/rename"] = function(...)
    orig(...)
    vim.cmd("silent! wall")
    vim.lsp.handlers["textDocument/rename"] = orig
  end
  vim.lsp.buf.rename()
end, { desc = "Rename (LSP) + save all" })

-- ── Find / files (Snacks picker) ────────────────────────────────────────────
map("n", "<leader><space>", function()
  Snacks.picker.smart()
end, { desc = "Smart find" })
map("n", "<leader>,", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>:", function()
  Snacks.picker.command_history()
end, { desc = "Command history" })
map("n", "<leader>n", function()
  Snacks.picker.notifications()
end, { desc = "Notifications" })

-- Dismiss notifications from both snacks notifier and noice
map("n", "<leader>un", function()
  Snacks.notifier.hide()
  if package.loaded["noice"] then
    require("noice").cmd("dismiss")
  end
end, { desc = "Dismiss All Notifications" })
map("n", "<leader>?", function()
  Snacks.picker.keymaps({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Keymaps for word" })

map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fF", function()
  Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Find files (buffer dir)" })
map("n", "<leader>fr", function()
  Snacks.picker.recent()
end, { desc = "Recent files" })
map("n", "<leader>fR", function()
  Snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Recent files (cwd)" })
map("n", "<leader>fc", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Config files" })
map("n", "<leader>fg", function()
  Snacks.picker.git_files()
end, { desc = "Git files" })
map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

-- ── Search (Snacks picker) ──────────────────────────────────────────────────
map("n", "<leader>/", function()
  Snacks.picker.grep_buffers()
end, { desc = "Grep open buffers" })

map("n", "<leader>sf", function()
  Snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>sG", function()
  Snacks.picker.grep({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Grep (buffer dir)" })
map({ "n", "x" }, "<leader>sw", function()
  Snacks.picker.grep_word()
end, { desc = "Grep word under cursor" })
map("n", "<leader>sb", function()
  Snacks.picker.lines()
end, { desc = "Buffer lines" })
map("n", "<leader>sB", function()
  Snacks.picker.grep_buffers()
end, { desc = "Grep open buffers" })
map("n", "<leader>sh", function()
  Snacks.picker.help()
end, { desc = "Help pages" })
map("n", "<leader>sH", function()
  Snacks.picker.highlights()
end, { desc = "Highlights" })
map("n", "<leader>sd", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>sD", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer diagnostics" })
map("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>sj", function()
  Snacks.picker.jumps()
end, { desc = "Jumps" })
map("n", "<leader>sm", function()
  Snacks.picker.marks()
end, { desc = "Marks" })
map("n", "<leader>sq", function()
  Snacks.picker.qflist()
end, { desc = "Quickfix list" })
map("n", "<leader>sl", function()
  Snacks.picker.loclist()
end, { desc = "Location list" })
map("n", "<leader>st", function()
  Snacks.picker.todo_comments()
end, { desc = "Todo comments" })
map("n", "<leader>sa", function()
  Snacks.picker.autocmds()
end, { desc = "Autocmds" })
map("n", "<leader>sc", function()
  Snacks.picker.command_history()
end, { desc = "Command history" })
map("n", "<leader>sC", function()
  Snacks.picker.commands()
end, { desc = "Commands" })
map("n", "<leader>sM", function()
  Snacks.picker.man()
end, { desc = "Man pages" })
map("n", "<leader>s/", function()
  Snacks.picker.search_history()
end, { desc = "Search history" })
map("n", '<leader>s"', function()
  Snacks.picker.registers()
end, { desc = "Registers" })
map("n", "<leader>si", function()
  Snacks.picker.icons()
end, { desc = "Icons" })
map("n", "<leader>sp", function()
  Snacks.picker.lazy()
end, { desc = "Search for Plugin Spec" })
map("n", "<leader>sP", function()
  Snacks.picker.files({ cwd = vim.fn.expand("~") .. "/.local/share/nvim/lazy/" })
end, { desc = "Search all plugin files" })
map("n", "<leader>sR", function()
  Snacks.picker.resume()
end, { desc = "Resume picker" })

-- ── Git ─────────────────────────────────────────────────────────────────────
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function()
    Snacks.lazygit({ cwd = vim.fs.root(0, { ".git" }) })
  end, { desc = "Lazygit (Root Dir)" })
  map("n", "<leader>gG", function()
    Snacks.lazygit()
  end, { desc = "Lazygit (cwd)" })
end
map("n", "<leader>gs", function()
  Snacks.picker.git_status()
end, { desc = "Git status" })
map("n", "<leader>gd", function()
  Snacks.picker.git_diff()
end, { desc = "Git diff (hunks)" })
map("n", "<leader>gl", function()
  Snacks.picker.git_log({ cwd = vim.fs.root(0, { ".git" }) })
end, { desc = "Git Log" })
map("n", "<leader>gL", function()
  Snacks.picker.git_log()
end, { desc = "Git Log (cwd)" })
map("n", "<leader>gb", function()
  Snacks.picker.git_log_line()
end, { desc = "Git Blame Line" })
map("n", "<leader>gf", function()
  Snacks.picker.git_log_file()
end, { desc = "Git Current File History" })
map({ "n", "x" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse (open)" })
map({ "n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({
    open = function(url)
      vim.fn.setreg("+", url)
    end,
    notify = false,
  })
end, { desc = "Git Browse (copy)" })
map("n", "<leader>gS", function()
  Snacks.picker.git_stash()
end, { desc = "Git stash" })
map("n", "<leader>gh", function()
  Snacks.picker.git_branches()
end, { desc = "Git branches" })
map("n", "<leader>gH", function()
  Snacks.terminal.open("gh dash")
end, { desc = "GitHub dashboard" })

-- ── Windows ─────────────────────────────────────────────────────────────────
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- ── Tabs ────────────────────────────────────────────────────────────────────
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- ── Floating terminal ───────────────────────────────────────────────────────
map("n", "<leader>fT", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })
map("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = vim.fs.root(0, { ".git" }) or vim.fn.getcwd() })
end, { desc = "Terminal (Root Dir)" })
map({ "n", "t" }, "<C-/>", function()
  Snacks.terminal.focus(nil, { cwd = vim.fs.root(0, { ".git" }) or vim.fn.getcwd() })
end, { desc = "Terminal (Root Dir)" })
map({ "n", "t" }, "<C-_>", function()
  Snacks.terminal.focus(nil, { cwd = vim.fs.root(0, { ".git" }) or vim.fn.getcwd() })
end, { desc = "which_key_ignore" })

-- ── UI toggles ──────────────────────────────────────────────────────────────
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })

-- Snacks toggles are registered in plugins/snacks.lua after Snacks.setup() runs.

-- ── Lua development ─────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(ev)
    vim.keymap.set({ "n", "x" }, "<leader>cR", function()
      Snacks.debug.run()
    end, { buffer = ev.buf, desc = "Run Lua" })
  end,
})
