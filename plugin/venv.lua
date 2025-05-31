local uv = vim.loop

local function realpath(path)
  -- canonical path, resolving symlinks etc.
  return uv.fs_realpath(path) or path
end

local function split(path)
  local parts = {}
  for part in string.gmatch(path, "[^/]+") do
    table.insert(parts, part)
  end
  return parts
end

local function relative_path(from, to)
  from = realpath(from)
  to = realpath(to)

  local from_parts = split(from)
  local to_parts = split(to)

  -- Find common prefix
  local i = 1
  while i <= #from_parts and i <= #to_parts and from_parts[i] == to_parts[i] do
    i = i + 1
  end

  local up = {}
  for _ = i, #from_parts do
    table.insert(up, "..")
  end

  local down = {}
  for j = i, #to_parts do
    table.insert(down, to_parts[j])
  end

  local rel_parts = vim.list_extend(up, down)
  return #rel_parts > 0 and table.concat(rel_parts, "/") or "."
end

local function find_current_python()
  local handle = io.popen("which python")
  if handle == nil then return nil end
  local result = handle:read("*a")
  handle:close()

  -- Trim any trailing newline
  result = result:gsub("%s+$", "")
  return result
end

M = {
  current_python = find_current_python()
}

function M.find_venvs(start_path)
  local candidates = {}
  local seen = {}
  local seen_paths = {}

  local function is_venv(path)
    return vim.fn.executable(path .. "/bin/python") == 1
        or vim.fn.executable(path .. "/Scripts/python.exe") == 1
  end

  local function dirname(p)
    return vim.fn.fnamemodify(p, ":h")
  end

  local function walk_up(path)
    path = vim.fn.fnamemodify(path, ":p")
    while path and not seen[path] do
      seen[path] = true
      for _, folder in ipairs({ ".venv", "venv", ".env" }) do
        local raw_candidate = path .. "/" .. folder
        local candidate = vim.fn.resolve(vim.fn.fnamemodify(raw_candidate, ":p"))

        if vim.fn.isdirectory(candidate) == 1 and is_venv(candidate) then
          if not seen_paths[candidate] then
            table.insert(candidates, { label = candidate, path = candidate })
            seen_paths[candidate] = true
          end
        end
      end
      local parent = dirname(path)
      if parent == path then break end
      path = parent
    end
  end

  local function walk_down(root_path, max_depth)
    max_depth = max_depth or 4
    local function recurse(path, depth)
      if depth > max_depth then return end

      local handle = uv.fs_scandir(path)
      if not handle then return end

      while true do
        local name, typ = uv.fs_scandir_next(handle)
        if not name then break end

        local child_path = path .. "/" .. name

        if typ == "directory" then
          local candidate = vim.fn.resolve(vim.fn.fnamemodify(child_path, ":p"))
          if (name == ".venv" or name == "venv" or name == ".env")
              and vim.fn.isdirectory(candidate) == 1
              and is_venv(candidate)
              and not seen_paths[candidate] then
            table.insert(candidates, { label = candidate, path = candidate })
            seen_paths[candidate] = true
          end

          recurse(child_path, depth + 1)
        end
      end
    end

    recurse(root_path, 0)
  end

  -- Perform both searches
  walk_up(start_path)
  walk_down(vim.fn.getcwd(), 4)

  return candidates
end

function M.set_venv(venv_path)
  local old_venv_bin_folder = vim.fn.fnamemodify(M.current_python, ":p:h")

  -- REMOVE CURRENT PYTHON FROM PATH
  local path = vim.fn.getenv("PATH")
  local pathSeparator = package.config:sub(1, 1) == "\\" and ";" or ":"
  local paths = {}
  for p in string.gmatch(path, "[^" .. pathSeparator .. "]+") do
    if p ~= old_venv_bin_folder then
      table.insert(paths, p)
    else
      local new_venv_bin_folder = venv_path .. "/bin"
      -- ... By not inserting old venv bin folder, instead inserting the new one!
      table.insert(paths, new_venv_bin_folder)
    end
  end

  -- SET THE NEW PYTHON TO PATH AND VIRTUAL_ENV
  local updatedPath = table.concat(paths, pathSeparator)
  vim.fn.setenv("PATH", updatedPath)
  vim.env.VIRTUAL_ENV = venv_path
  M.current_python = venv_path .. "/bin/python"

  -- Updating LSP client and notifying it about changed configuration
  local client = vim.lsp.get_clients({ name = "pyright" })[1]
  if not client then
    -- print("pyright lsp client was not found, could not switch venv")
    -- Pyright LSP not found, could not switch venv
    return
  else
    if client.settings then
      client.settings = vim.tbl_deep_extend("force", client.settings, {
        python = {
          pythonPath = venv_path .. "/bin/python",
        },
      })
    else
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
        python = {
          pythonPath = venv_path .. "/bin/python",
        },
      })
    end
    client.notify("workspace/didChangeConfiguration", { settings = nil })
  end
  vim.api.nvim_echo({ { "\nActivated venv: " .. venv_path, "Normal" } }, false, {})
end

vim.api.nvim_create_user_command("Py", function()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local is_oil = vim.bo.filetype == "oil"
  local start_path

  if is_oil and buf_path:match("^oil://") then
    -- Remove oil:// and normalize
    start_path = vim.fn.fnamemodify(buf_path:gsub("^oil://", ""), ":p")
  elseif buf_path ~= "" then
    start_path = vim.fn.fnamemodify(buf_path, ":p:h")
  else
    start_path = vim.fn.getcwd()
  end

  local venvs = M.find_venvs(start_path)

  if #venvs == 0 then
    print("No venvs found from " .. start_path)
    return
  end

  local labels = vim.tbl_map(function(v)
    local abs_path = vim.fn.fnamemodify(v.path, ":p"):gsub("/$", "")
    return string.format("%s", "./" .. relative_path(start_path, abs_path))
  end, venvs)

  vim.ui.select(labels, { prompt = "Select venv from " .. vim.fn.fnamemodify(start_path, ":~") }, function(_, idx)
    if idx then
      local selected = venvs[idx]
      M.set_venv(selected.path)
    end
  end)
end, {})

return M
