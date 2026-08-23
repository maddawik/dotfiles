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

return M
