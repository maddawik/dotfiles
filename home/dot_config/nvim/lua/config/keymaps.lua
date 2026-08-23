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
map("n", "<leader>uR", "<cmd>restart<cr>", { desc = "Restart Nvim" })
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- ── Code / LSP custom ───────────────────────────────────────────────────────
map({ "n", "x" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })
map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP info" })

-- ── Find / files (Snacks picker) ────────────────────────────────────────────
map("n", "<leader><space>", function()
  require("mini.pick").builtin.files({}, { source = { cwd = vim.fn.expand("%:p:h") } })
end, { desc = "Find files (buffer dir)" })
map("n", "<leader>,", function()
  require("mini.pick").builtin.buffers()
end, { desc = "Buffers" })
map("n", "<leader>:", function()
  require("mini.extra").pickers.history({ scope = "cmd" })
end, { desc = "Command history" })
map("n", "<leader>n", function()
  require("mini.notify").show_history()
end, { desc = "Notifications" })

map("n", "<leader>un", function()
  require("mini.notify").clear()
  if package.loaded["noice"] then
    require("noice").cmd("dismiss")
  end
end, { desc = "Dismiss All Notifications" })
map("n", "<leader>?", function()
  require("mini.extra").pickers.keymaps()
end, { desc = "Keymaps for word" })

map("n", "<leader>ff", function()
  require("mini.pick").builtin.files()
end, { desc = "Find files" })
map("n", "<leader>fF", function()
  require("mini.pick").builtin.files({}, { source = { cwd = vim.fn.expand("%:p:h") } })
end, { desc = "Find files (buffer dir)" })
map("n", "<leader>fr", function()
  require("mini.extra").pickers.oldfiles()
end, { desc = "Recent files" })
map("n", "<leader>fR", function()
  require("mini.extra").pickers.oldfiles({ current_dir = true })
end, { desc = "Recent files (cwd)" })
map("n", "<leader>fc", function()
  require("mini.pick").builtin.files({}, { source = { cwd = vim.fn.stdpath("config") } })
end, { desc = "Config files" })
map("n", "<leader>fg", function()
  require("mini.extra").pickers.git_files()
end, { desc = "Git files" })

-- ── Search (Snacks picker) ──────────────────────────────────────────────────
map("n", "<leader>/", function()
  require("mini.extra").pickers.buf_lines({ scope = "all" })
end, { desc = "Grep open buffers" })
map("n", "<leader>sg", function()
  require("mini.pick").builtin.grep_live()
end, { desc = "Grep" })
map("n", "<leader>sG", function()
  require("mini.pick").builtin.grep_live({}, { source = { cwd = vim.fn.expand("%:p:h") } })
end, { desc = "Grep (buffer dir)" })
map({ "n", "x" }, "<leader>sw", function()
  require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Grep word under cursor" })
map("n", "<leader>sb", function()
  require("mini.extra").pickers.buf_lines({ scope = "current" })
end, { desc = "Buffer lines" })
map("n", "<leader>sB", function()
  require("mini.extra").pickers.buf_lines({ scope = "all" })
end, { desc = "Grep open buffers" })
map("n", "<leader>sh", function()
  require("mini.pick").builtin.help()
end, { desc = "Help pages" })
map("n", "<leader>sH", function()
  require("mini.extra").pickers.hl_groups()
end, { desc = "Highlights" })
map("n", "<leader>sd", function()
  require("mini.extra").pickers.diagnostic({ scope = "all" })
end, { desc = "Diagnostics" })
map("n", "<leader>sD", function()
  require("mini.extra").pickers.diagnostic({ scope = "current" })
end, { desc = "Buffer diagnostics" })
map("n", "<leader>sk", function()
  require("mini.extra").pickers.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>sj", function()
  require("mini.extra").pickers.list({ scope = "jump" })
end, { desc = "Jumps" })
map("n", "<leader>sm", function()
  require("mini.extra").pickers.marks()
end, { desc = "Marks" })
map("n", "<leader>sq", function()
  require("mini.extra").pickers.list({ scope = "quickfix" })
end, { desc = "Quickfix list" })
map("n", "<leader>sl", function()
  require("mini.extra").pickers.list({ scope = "location" })
end, { desc = "Location list" })
map("n", "<leader>st", function()
  require("maddawik.pickers").todo_comments()
end, { desc = "Todo comments" })
map("n", "<leader>sa", function()
  require("maddawik.pickers").autocmds()
end, { desc = "Autocmds" })
map("n", "<leader>sC", function()
  require("mini.extra").pickers.commands()
end, { desc = "Commands" })
map("n", "<leader>sM", function()
  require("mini.extra").pickers.manpages()
end, { desc = "Man pages" })
map("n", "<leader>s/", function()
  require("mini.extra").pickers.history({ scope = "search" })
end, { desc = "Search history" })
map("n", '<leader>s"', function()
  require("mini.extra").pickers.registers()
end, { desc = "Registers" })
map("n", "<leader>si", function()
  Snacks.picker.icons()
end, { desc = "Icons" })
map("n", "<leader>sp", function()
  require("maddawik.pickers").lazy_plugins()
end, { desc = "Search for Plugin Spec" })
map("n", "<leader>sP", function()
  require("mini.pick").builtin.files({}, { source = { cwd = vim.fn.expand("~") .. "/.local/share/nvim/lazy/" } })
end, { desc = "Search all plugin files" })
map("n", "<leader>sR", function()
  require("mini.pick").builtin.resume()
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
  require("maddawik.pickers").git_status()
end, { desc = "Git status" })
map("n", "<leader>gd", function()
  require("mini.extra").pickers.git_hunks()
end, { desc = "Git diff (hunks)" })
map("n", "<leader>gl", function()
  require("mini.extra").pickers.git_commits({ path = vim.fs.root(0, { ".git" }) })
end, { desc = "Git Log" })
map("n", "<leader>gL", function()
  require("mini.extra").pickers.git_commits()
end, { desc = "Git Log (cwd)" })
map("n", "<leader>gb", function()
  require("maddawik.pickers").git_log_line()
end, { desc = "Git Blame Line" })
map("n", "<leader>gf", function()
  require("mini.extra").pickers.git_commits({ path = vim.api.nvim_buf_get_name(0) })
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
  require("maddawik.pickers").git_stash()
end, { desc = "Git stash" })
map("n", "<leader>gh", function()
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

-- ── Terminal ───────────────────────────────────────────────────────
map({ "n", "t" }, "<C-/>", function()
  Snacks.terminal.focus(nil, { cwd = vim.fs.root(0, { ".git" }) or vim.fn.getcwd() })
end, { desc = "Terminal (Root Dir)" })

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
