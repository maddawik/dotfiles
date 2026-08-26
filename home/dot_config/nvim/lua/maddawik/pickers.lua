-- Custom mini.pick sources for things Snacks.picker had that mini.extra doesn't.
local M = {}

local function show_with_icons(buf_id, items, query)
  require("mini.pick").default_show(buf_id, items, query, { show_icons = true })
end

--- Git status (working tree changes) as a picker. Choosing opens the file.
function M.git_status()
  local MiniPick = require("mini.pick")
  local root = vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
  local lines = vim.fn.systemlist({ "git", "-C", root, "status", "--porcelain=v1", "--untracked-files=all" })
  if vim.v.shell_error ~= 0 then
    return vim.notify("git status failed (not a git repo?)", vim.log.levels.ERROR)
  end
  if #lines == 0 then
    return vim.notify("Git status clean", vim.log.levels.INFO)
  end

  local items = {}
  for _, line in ipairs(lines) do
    local status, rest = line:sub(1, 2), line:sub(4)
    local _, renamed_to = rest:match("^(.-) %-> (.+)$")
    local path = renamed_to or rest
    table.insert(items, {
      path = root .. "/" .. path,
      status = status,
      text = string.format("%s %s", status, path),
    })
  end

  MiniPick.start({
    source = {
      items = items,
      name = "Git status",
      cwd = root,
      show = show_with_icons,
      preview = function(buf_id, item)
        local has_parser, parser = pcall(vim.treesitter.get_parser, buf_id, "git", { error = false })
        has_parser = has_parser and parser ~= nil
        if has_parser then
          has_parser = pcall(vim.treesitter.start, buf_id, "git")
        end
        if not has_parser then
          vim.bo[buf_id].syntax = "git"
        end

        local cmd
        if item.status == "??" then
          cmd = { "git", "-C", root, "diff", "--no-index", "--", "/dev/null", item.path }
        elseif item.status:sub(1, 1) ~= " " then
          cmd = { "git", "-C", root, "diff", "--cached", "--", item.path }
        else
          cmd = { "git", "-C", root, "diff", "--", item.path }
        end
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, vim.fn.systemlist(cmd))
      end,
    },
  })
end

--- Git stash list as a picker. Preview shows the stash diff; choosing prints
--- the stash ref (deliberately non-destructive — no auto-apply/pop).
function M.git_stash()
  local MiniPick = require("mini.pick")
  local root = vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
  local lines = vim.fn.systemlist({ "git", "-C", root, "stash", "list" })
  if vim.v.shell_error ~= 0 then
    return vim.notify("git stash list failed (not a git repo?)", vim.log.levels.ERROR)
  end
  if #lines == 0 then
    return vim.notify("No stashes", vim.log.levels.INFO)
  end

  local items = {}
  for _, line in ipairs(lines) do
    table.insert(items, { text = line, ref = line:match("^(stash@{%d+})") })
  end

  MiniPick.start({
    source = {
      items = items,
      name = "Git stash",
      preview = function(buf_id, item)
        local has_parser, parser = pcall(vim.treesitter.get_parser, buf_id, "git", { error = false })
        has_parser = has_parser and parser ~= nil
        if has_parser then
          has_parser = pcall(vim.treesitter.start, buf_id, "git")
        end
        if not has_parser then
          vim.bo[buf_id].syntax = "git"
        end
        local diff = vim.fn.systemlist({ "git", "-C", root, "stash", "show", "-p", item.ref })
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, diff)
      end,
      choose = function(item)
        if not item then
          return
        end
        vim.notify(item.ref .. " — use `git stash apply/pop " .. item.ref .. "` to act on it", vim.log.levels.INFO)
      end,
    },
  })
end

--- Git history for the line under the cursor (like Snacks.picker.git_log_line,
--- i.e. `git log -L`). Preview shows each commit's diff for that line; choosing
--- just prints the hash (non-destructive, matches the git_stash picker style).
function M.git_log_line()
  local MiniPick = require("mini.pick")
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return vim.notify("No file in current buffer", vim.log.levels.WARN)
  end
  local root = vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
  local rel = vim.fn.fnamemodify(file, ":~:.")
  local line = vim.api.nvim_win_get_cursor(0)[1]

  local output = vim.fn.systemlist({
    "git",
    "-C",
    root,
    "log",
    "-L",
    string.format("%d,%d:%s", line, line, file),
  })
  if vim.v.shell_error ~= 0 then
    return vim.notify("git log -L failed: " .. table.concat(output, " "), vim.log.levels.ERROR)
  end

  local chunks, current = {}, nil
  for _, l in ipairs(output) do
    local hash = l:match("^commit (%x+)")
    if hash then
      if current then
        table.insert(chunks, current)
      end
      current = { hash = hash, lines = { l } }
    elseif current then
      table.insert(current.lines, l)
      if not current.subject and l:match("^    %S") then
        current.subject = l:gsub("^%s+", "")
      end
    end
  end
  if current then
    table.insert(chunks, current)
  end
  if #chunks == 0 then
    return vim.notify("No history for this line", vim.log.levels.INFO)
  end

  local items = {}
  for _, c in ipairs(chunks) do
    table.insert(items, { text = string.format("%s %s", c.hash:sub(1, 8), c.subject or ""), chunk = c })
  end

  MiniPick.start({
    source = {
      items = items,
      name = string.format("Git log -L %d:%s", line, rel),
      preview = function(buf_id, item)
        local has_parser, parser = pcall(vim.treesitter.get_parser, buf_id, "git", { error = false })
        has_parser = has_parser and parser ~= nil
        if has_parser then
          has_parser = pcall(vim.treesitter.start, buf_id, "git")
        end
        if not has_parser then
          vim.bo[buf_id].syntax = "git"
        end
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, item.chunk.lines)
      end,
      choose = function(item)
        if item then
          vim.notify(item.chunk.hash, vim.log.levels.INFO)
        end
      end,
    },
  })
end

--- Browse lazy.nvim-managed plugins; jumps to where each one is *declared in
--- your own config* (like Snacks.picker.lazy()) — not the plugin's own repo.
function M.lazy_plugins()
  local MiniPick = require("mini.pick")
  local ok, lazy_config = pcall(require, "lazy.core.config")
  if not ok then
    return vim.notify("lazy.nvim not available", vim.log.levels.ERROR)
  end
  local Util = require("lazy.core.util")
  local spec = lazy_config.spec

  local paths = {}
  for _, import in ipairs(spec.modules) do
    Util.lsmod(import, function(_, modpath)
      table.insert(paths, modpath)
    end)
  end

  local names = {}
  for _, frag in pairs(spec.meta.fragments.fragments) do
    local name = frag.spec[1] or frag.name
    if name and not vim.tbl_contains(names, name) then
      table.insert(names, name)
    end
  end

  -- \M = very nomagic, so names need no escaping even with "." or "-".
  local regex = "\\M\\['\"]\\(" .. table.concat(names, "\\|") .. "\\)\\['\"]"
  local re = vim.regex(regex)

  local items = {}
  for _, path in ipairs(paths) do
    for lnum, line in ipairs(vim.fn.readfile(path)) do
      if re:match_str(line) then
        table.insert(items, {
          text = string.format("%s:%d  │  %s", vim.fn.fnamemodify(path, ":~:."), lnum, vim.trim(line)),
          path = path,
          lnum = lnum,
        })
      end
    end
  end

  MiniPick.start({ source = { items = items, name = "Lazy plugins" } })
end

--- Grep for common comment markers (TODO/FIXME/HACK/...) via mini.pick's grep.
function M.todo_comments()
  require("mini.pick").builtin.grep({ pattern = [[\b(TODO|FIXME|HACK|NOTE|WARNING|PERF|TEST)\b]] })
end

-- `<C-Space>` (built-in `refine`) permanently swaps `source.match` away from
-- whatever custom matcher a picker was using to plain fuzzy matching over the
-- frozen result set — mini.pick's own documented way to "revert to regular
-- matching". Once that's happened, no further `rg` invocation can affect the
-- result set, so toggles that only make sense while still live should warn
-- instead of silently doing nothing. Left untouched otherwise — no attempt
-- to rewrite mini.pick's own "(Refine N)" title text.
local function make_refine_guard(match)
  return function(func)
    return function()
      local opts = require("mini.pick").get_picker_opts()
      if opts == nil or opts.source.match ~= match then
        return vim.notify("Picker was refined (<C-Space>) — no longer live, toggle has no effect", vim.log.levels.WARN)
      end
      func()
    end
  end
end

local function hidden_ignore_mappings(state, refresh)
  return {
    toggle_hidden = {
      char = "<M-h>",
      func = function()
        state.hidden = not state.hidden
        refresh()
      end,
    },
    toggle_ignored = {
      char = "<M-i>",
      func = function()
        state.no_ignore = not state.no_ignore
        refresh()
      end,
    },
  }
end

-- `--hidden` shows `.git` too (it's not covered by `.gitignore`, just normal
-- dotfile skipping) — exclude it explicitly, matching Snacks.picker's behavior.
local function append_hidden_glob(cmd, state)
  if state.hidden then
    table.insert(cmd, "--glob=!.git")
  end
end

-- Mirrors upstream `H.user_input`: prefers `MiniInput.get()` (shown in the
-- picker's winbar) and falls back to plain `vim.fn.input()` otherwise.
-- `scope` must be one of mini.input's allowed scopes ("window", "editor", ...)
-- — NOT a completion method; `completion` (e.g. "file") is the separate field.
local function user_input(prompt, completion, scope)
  prompt = "(pickers) " .. prompt
  if _G.MiniInput ~= nil then
    return MiniInput.get({
      prompt = prompt,
      completion = completion,
      scope = scope,
      -- "winbar" (not the default "statusline") so it renders as a line
      -- inside the picker's own floating window, not the underlying split.
      handlers = { view = MiniInput.gen_view.uiline({ style = "winbar" }) },
    })
  end
  vim.cmd("echohl Question")
  local ok, res = pcall(vim.fn.input, { prompt = prompt .. ": ", completion = completion })
  vim.cmd('echohl None | echo "" | redraw')
  return ok and res or nil
end

local function hidden_ignore_name(prefix, tool, state)
  local flags = {}
  if state.hidden then
    table.insert(flags, "hidden")
  end
  if state.no_ignore then
    table.insert(flags, "no-ignore")
  end
  return string.format("%s (%s%s)", prefix, tool, #flags > 0 and (" " .. table.concat(flags, " ")) or "")
end

--- Find files, with <M-h>/<M-i> to toggle hidden/gitignored files (needs `rg`;
--- falls back to the plain builtin picker, without the toggles, otherwise).
function M.files(local_opts, opts)
  local MiniPick = require("mini.pick")
  if vim.fn.executable("rg") ~= 1 then
    return MiniPick.builtin.files(local_opts, opts)
  end

  local cwd = ((opts or {}).source or {}).cwd or vim.fn.getcwd()
  local state = { hidden = false, no_ignore = false }
  local get_name = function()
    return hidden_ignore_name("Files", "rg", state)
  end

  local build_command = function()
    local cmd = { "rg", "--files", "--color=never" }
    if state.hidden then
      table.insert(cmd, "--hidden")
    end
    if state.no_ignore then
      table.insert(cmd, "--no-ignore")
    end
    append_hidden_glob(cmd, state)
    return cmd
  end
  local spawn = function()
    MiniPick.set_picker_items_from_cli(build_command(), { spawn_opts = { cwd = cwd } })
  end
  local refresh = function()
    MiniPick.set_picker_opts({ source = { name = get_name() } })
    spawn()
  end

  local default_opts = {
    source = {
      name = get_name(),
      cwd = cwd,
      show = show_with_icons,
      items = vim.schedule_wrap(spawn),
    },
    mappings = hidden_ignore_mappings(state, refresh),
  }
  return MiniPick.start(vim.tbl_deep_extend("force", default_opts, opts or {}))
end

--- Live grep, with <M-h>/<M-i> to toggle hidden/gitignored files (needs `rg`;
--- falls back to the plain builtin picker, without the toggles, otherwise).
function M.grep_live(local_opts, opts)
  local MiniPick = require("mini.pick")
  if vim.fn.executable("rg") ~= 1 then
    return MiniPick.builtin.grep_live(local_opts, opts)
  end

  local cwd = ((opts or {}).source or {}).cwd or vim.fn.getcwd()
  local state = { hidden = false, no_ignore = false, method = "󰑑 ", globs = {} }

  local get_name = function()
    local parts = { "rg", state.method }
    if #state.globs > 0 then
      table.insert(parts, table.concat(state.globs, ", "))
    end
    if state.hidden then
      table.insert(parts, "hidden")
    end
    if state.no_ignore then
      table.insert(parts, "no-ignore")
    end
    return string.format("Grep live (%s)", table.concat(parts, " | "))
  end

  local build_command = function(pattern)
    local cmd = {
      "rg",
      "--column",
      "--line-number",
      "--no-heading",
      "--field-match-separator",
      "\\x00",
      "--color=never",
    }
    table.insert(cmd, state.method == "󰑑 " and "--no-fixed-strings" or "--fixed-strings")
    if state.hidden then
      table.insert(cmd, "--hidden")
    end
    if state.no_ignore then
      table.insert(cmd, "--no-ignore")
    end
    append_hidden_glob(cmd, state)
    for _, g in ipairs(state.globs) do
      table.insert(cmd, "--glob")
      table.insert(cmd, g)
    end
    local case = vim.o.ignorecase and (vim.o.smartcase and "smart-case" or "ignore-case") or "case-sensitive"
    vim.list_extend(cmd, { "--" .. case, "--", pattern })
    return cmd
  end

  -- Mirrors upstream `grep_live`'s own guard (querytick check) so toggling
  -- doesn't respawn `rg` on every no-op keypress, only on real query/state changes.
  local sys = { kill = function() end }
  local set_items_opts = { do_match = false, querytick = MiniPick.get_querytick() }
  local match = function(_, _, query)
    sys:kill()
    if MiniPick.get_querytick() == set_items_opts.querytick then
      return
    end
    if #query == 0 then
      sys = { kill = function() end }
      return MiniPick.set_picker_items({}, set_items_opts)
    end
    set_items_opts.querytick = MiniPick.get_querytick()
    sys = MiniPick.set_picker_items_from_cli(
      build_command(table.concat(query)),
      { set_items_opts = set_items_opts, spawn_opts = { cwd = cwd } }
    )
  end

  local refresh = function()
    MiniPick.set_picker_opts({ source = { name = get_name() } })
    MiniPick.set_picker_query(MiniPick.get_picker_query())
  end

  local guard_refined = make_refine_guard(match)
  local mappings = hidden_ignore_mappings(state, refresh)
  mappings.toggle_hidden.func = guard_refined(mappings.toggle_hidden.func)
  mappings.toggle_ignored.func = guard_refined(mappings.toggle_ignored.func)
  mappings.add_glob = {
    char = "<C-o>",
    func = guard_refined(function()
      local glob = user_input("Glob pattern", "file", "window")
      if glob == nil or glob == "" then
        return
      end
      table.insert(state.globs, glob)
      refresh()
    end),
  }
  -- Not guarded: regex/plain stays switchable even once refined. It won't
  -- respawn `rg` at that point (same as the other toggles), but flips the
  -- state/label for if you start a fresh grep_live later.
  mappings.switch_method = {
    char = "<C-e>",
    func = function()
      state.method = state.method == "󰑑 " and " " or "󰑑 "
      refresh()
    end,
  }

  local default_opts = {
    source = {
      name = get_name(),
      cwd = cwd,
      items = {},
      match = match,
      show = show_with_icons,
    },
    mappings = mappings,
  }
  return MiniPick.start(vim.tbl_deep_extend("force", default_opts, opts or {}))
end

--- List all autocmds (like Snacks.picker.autocmds).
function M.autocmds()
  local MiniPick = require("mini.pick")
  local items = {}
  for _, au in ipairs(vim.api.nvim_get_autocmds({})) do
    local pattern = au.pattern or (au.buflocal and ("<buffer=" .. au.buffer .. ">") or "*")
    local desc = au.desc or au.command or ""
    table.insert(items, {
      text = string.format("%-14s │ %-20s │ %s", au.event, pattern, desc),
      autocmd = au,
    })
  end

  MiniPick.start({
    source = {
      items = items,
      name = "Autocmds",
      choose = function(item)
        if item then
          vim.notify(vim.inspect(item.autocmd))
        end
      end,
    },
  })
end

--- Yanky.nvim history as a picker (yanky ships telescope/snacks sources only,
--- no mini.pick one). Choosing pastes the entry after cursor, like `p`.
function M.yanky()
  local MiniPick = require("mini.pick")
  local regtype_names = { v = "charwise", V = "linewise", [""] = "blockwise" }

  local items = {}
  for index, entry in pairs(require("yanky.history").all()) do
    entry.history_index = index
    local kind = regtype_names[entry.regtype] or "blockwise"
    local preview = tostring(entry.regcontents):gsub("\n", "⏎ ")
    table.insert(items, { text = string.format("[%d] (%s) %s", index, kind, preview), entry = entry })
  end
  table.sort(items, function(a, b)
    return a.entry.history_index < b.entry.history_index
  end)

  MiniPick.start({
    source = {
      items = items,
      name = "Yank history",
      preview = function(buf_id, item)
        local lines = vim.split(tostring(item.entry.regcontents), "\n")
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
        if item.entry.filetype then
          vim.bo[buf_id].filetype = item.entry.filetype
        end
      end,
      choose = function(item)
        if not item then
          return
        end
        local win_target = MiniPick.get_picker_state().windows.target
        vim.api.nvim_win_call(win_target, function()
          require("yanky.picker").actions.put("p", false)(item.entry)
        end)
      end,
    },
  })
end

-- Mirrors mini.extra's private `H.pick_prepend_position`, so the multi-result
-- picker still shows "path│line│col│ text" like `pickers.lsp` does.
local function lsp_prepend_position(item)
  local path = item.path
  if path == nil and item.bufnr and vim.api.nvim_buf_is_valid(item.bufnr) then
    local name = vim.api.nvim_buf_get_name(item.bufnr)
    path = name == "" and ("Buffer_" .. item.bufnr) or name
  end
  if path == nil then
    return item
  end
  path = vim.fn.fnamemodify(path, ":p:.")
  local text = item.text or ""
  local suffix = text == "" and "" or ("│ " .. text)
  item.text = string.format("%s│%s│%s%s", path, item.lnum or 1, item.col or 1, suffix)
  return item
end

--- LSP goto-* picker (definition/declaration/references/implementation/
--- type_definition) that jumps straight to the target when there's exactly
--- one location, and only opens a picker when there's more than one.
--- `mini.extra.pickers.lsp` always opens the picker, even for a single hit,
--- because it always supplies its own `on_list` (which preempts the
--- built-in single-result auto-jump `vim.lsp.buf.*` normally does).
function M.lsp_goto(scope)
  return function()
    local MiniPick = require("mini.pick")
    local on_list = function(data)
      local items = {}
      for _, item in ipairs(data.items) do
        item.text, item.path = item.text or "", item.filename or nil
        table.insert(items, lsp_prepend_position(item))
      end

      if #items == 0 then
        return vim.notify("No " .. scope:gsub("_", " ") .. " found", vim.log.levels.WARN)
      end
      if #items == 1 then
        return MiniPick.default_choose(items[1])
      end

      MiniPick.start({
        source = { items = items, name = string.format("LSP (%s)", scope), show = show_with_icons },
      })
    end

    if scope == "references" then
      vim.lsp.buf.references(nil, { on_list = on_list })
    else
      vim.lsp.buf[scope]({ on_list = on_list })
    end
  end
end

return M
