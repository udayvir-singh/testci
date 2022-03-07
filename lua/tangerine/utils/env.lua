local config_dir = vim.fn.stdpath("config")
local function endswith(str, args)
  _G.assert((nil ~= args), "Missing argument args on fnl/tangerine/utils/env.fnl:11")
  _G.assert((nil ~= str), "Missing argument str on fnl/tangerine/utils/env.fnl:11")
  for i, v in pairs(args) do
    if vim.endswith(str, v) then
      return true
    else
    end
  end
  return nil
end
local function resolve(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/env.fnl:17")
  local out = vim.fn.resolve(vim.fn.expand(path))
  if endswith(out, {"/", ".fnl", ".lua"}) then
    return out
  else
    return (out .. "/")
  end
end
local function rtpdirs(dirs)
  _G.assert((nil ~= dirs), "Missing argument dirs on fnl/tangerine/utils/env.fnl:24")
  local tbl_15_auto = {}
  local i_16_auto = #tbl_15_auto
  for _, dir in pairs(dirs) do
    local val_17_auto
    do
      local path = resolve(dir)
      if vim.startswith(path, "/") then
        val_17_auto = path
      else
        val_17_auto = (config_dir .. "/" .. path)
      end
    end
    if (nil ~= val_17_auto) then
      i_16_auto = (i_16_auto + 1)
      do end (tbl_15_auto)[i_16_auto] = val_17_auto
    else
    end
  end
  return tbl_15_auto
end
local function get_type(x)
  _G.assert((nil ~= x), "Missing argument x on fnl/tangerine/utils/env.fnl:32")
  if vim.tbl_islist(x) then
    return "list"
  else
    return type(x)
  end
end
local function table_3f(tbl, scm)
  _G.assert((nil ~= scm), "Missing argument scm on fnl/tangerine/utils/env.fnl:38")
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:38")
  return (("table" == type(tbl)) and not vim.tbl_islist(scm))
end
local function deepcopy(tbl1, tbl2)
  _G.assert((nil ~= tbl2), "Missing argument tbl2 on fnl/tangerine/utils/env.fnl:43")
  _G.assert((nil ~= tbl1), "Missing argument tbl1 on fnl/tangerine/utils/env.fnl:43")
  for key, val in pairs(tbl1) do
    if table_3f(val, (tbl2)[key]) then
      deepcopy(val, (tbl2)[key])
    elseif "else" then
      tbl2[key] = val
    else
    end
  end
  return nil
end
local pre_schema = {source = resolve, target = resolve, vimrc = resolve, rtpdirs = rtpdirs, compiler = nil, diagnostic = nil, eval = nil, highlight = nil, keymaps = nil}
local schema = {source = "string", target = "string", vimrc = "string", rtpdirs = "list", compiler = {float = "boolean", clean = "boolean", force = "boolean", verbose = "boolean", globals = "list", version = {"oneof", {"latest", "1-0-0", "0-10-0", "0-9-2"}}, hooks = {"array", {"onsave", "onload", "oninit"}}}, diagnostic = {float = "boolean", virtual = "boolean", timeout = "number"}, eval = {float = "boolean", luafmt = "function"}, keymaps = {PeakBuffer = "string", EvalBuffer = "string", GotoOutput = "string", Float = {Next = "string", Prev = "string", Close = "string", KillAll = "string", ResizeI = "string", ResizeD = "string"}}, highlight = {float = "string", success = "string", errors = "string"}}
local ENV
local function _7_()
  return {vim.fn.expand("~/.luarocks/bin/lua-format"), "--spaces-inside-table-braces", "--column-table-limit", 50, "--column-limit", vim.api.nvim_win_get_width(0)}
end
ENV = {vimrc = resolve((config_dir .. "/init.fnl")), source = resolve((config_dir .. "/fnl/")), target = resolve((config_dir .. "/lua/")), rtpdirs = {}, compiler = {float = true, clean = true, force = false, verbose = true, globals = vim.tbl_keys(_G), version = "latest", hooks = {}}, diagnostic = {float = true, virtual = true, timeout = 10}, eval = {float = true, luafmt = _7_}, keymaps = {PeakBuffer = "gL", EvalBuffer = "gE", GotoOutput = "gO", Float = {Next = "<C-K>", Prev = "<C-J>", Close = "<Enter>", KillAll = "<Esc>", ResizeI = "<C-W>=", ResizeD = "<C-W>-"}}, highlight = {float = "Normal", success = "String", errors = "DiagnosticError"}}
local function validate_err(key, msg, ...)
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/utils/env.fnl:165")
  _G.assert((nil ~= key), "Missing argument key on fnl/tangerine/utils/env.fnl:165")
  return error(("[tangerine]: bad argument to 'setup()' in :" .. key .. ", " .. table.concat({msg, ...}, " ") .. "."))
end
local function validate_type(key, val, scm)
  _G.assert((nil ~= scm), "Missing argument scm on fnl/tangerine/utils/env.fnl:171")
  _G.assert((nil ~= val), "Missing argument val on fnl/tangerine/utils/env.fnl:171")
  _G.assert((nil ~= key), "Missing argument key on fnl/tangerine/utils/env.fnl:171")
  local type_2a = get_type(val)
  if (scm ~= type_2a) then
    return validate_err(key, scm, "expected", "got", type_2a)
  else
    return nil
  end
end
local function validate_oneof(key, val, scm)
  _G.assert((nil ~= scm), "Missing argument scm on fnl/tangerine/utils/env.fnl:178")
  _G.assert((nil ~= val), "Missing argument val on fnl/tangerine/utils/env.fnl:178")
  _G.assert((nil ~= key), "Missing argument key on fnl/tangerine/utils/env.fnl:178")
  local expected = vim.inspect(scm)
  if not vim.tbl_contains(scm, val) then
    return validate_err(key, "expected to be one of", expected, "got", vim.inspect(val))
  else
    return nil
  end
end
local function validate_array(key, array, scm)
  _G.assert((nil ~= scm), "Missing argument scm on fnl/tangerine/utils/env.fnl:185")
  _G.assert((nil ~= array), "Missing argument array on fnl/tangerine/utils/env.fnl:185")
  _G.assert((nil ~= key), "Missing argument key on fnl/tangerine/utils/env.fnl:185")
  validate_type(key, array, "list")
  for _, val in pairs(array) do
    validate_oneof(key, val, scm)
  end
  return nil
end
local function validate(tbl, schema0)
  _G.assert((nil ~= schema0), "Missing argument schema on fnl/tangerine/utils/env.fnl:192")
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:192")
  for key, val in pairs(tbl) do
    local scm = (schema0)[key]
    if not scm then
      validate_err(key, "invalid", "key")
    else
    end
    local _11_ = {get_type(scm), scm[1]}
    if ((_G.type(_11_) == "table") and ((_11_)[1] == "string") and ((_11_)[2] == nil)) then
      validate_type(key, val, scm)
    elseif ((_G.type(_11_) == "table") and ((_11_)[1] == "table") and ((_11_)[2] == nil)) then
      validate(val, scm)
    elseif ((_G.type(_11_) == "table") and ((_11_)[1] == "list") and ((_11_)[2] == "oneof")) then
      validate_oneof(key, val, scm[2])
    elseif ((_G.type(_11_) == "table") and ((_11_)[1] == "list") and ((_11_)[2] == "array")) then
      validate_array(key, val, scm[2])
    else
    end
  end
  return nil
end
local function pre_process(tbl, schema0)
  _G.assert((nil ~= schema0), "Missing argument schema on fnl/tangerine/utils/env.fnl:205")
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:205")
  for key, val in pairs(tbl) do
    local pre = (schema0)[key]
    local _13_ = type(pre)
    if (_13_ == "table") then
      pre_process(val, pre)
    elseif (_13_ == "function") then
      tbl[key] = pre(val)
    else
    end
  end
  return tbl
end
local function rget(tbl, args)
  _G.assert((nil ~= args), "Missing argument args on fnl/tangerine/utils/env.fnl:218")
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:218")
  if (0 == #args) then
    return tbl
  else
  end
  local rest = tbl[args[1]]
  table.remove(args, 1)
  if (nil ~= rest) then
    return rget(rest, args)
  else
    return nil
  end
end
local function env_get(...)
  return rget(ENV, {...})
end
local function env_get_conf(opts, args)
  _G.assert((nil ~= args), "Missing argument args on fnl/tangerine/utils/env.fnl:231")
  _G.assert((nil ~= opts), "Missing argument opts on fnl/tangerine/utils/env.fnl:231")
  local last = args[#args]
  if (nil ~= opts[last]) then
    return pre_process(opts, pre_schema)[last]
  else
    return rget(ENV, args)
  end
end
local function env_set(tbl)
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:242")
  validate(tbl, schema)
  return deepcopy(pre_process(tbl, pre_schema), ENV)
end
return {get = env_get, set = env_set, conf = env_get_conf}
