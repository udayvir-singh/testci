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
local function table_3f(tbl, scm)
  _G.assert((nil ~= scm), "Missing argument scm on fnl/tangerine/utils/env.fnl:24")
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:24")
  return (("table" == type(tbl)) and not vim.tbl_islist(scm))
end
local function deepcopy(tbl1, tbl2)
  _G.assert((nil ~= tbl2), "Missing argument tbl2 on fnl/tangerine/utils/env.fnl:29")
  _G.assert((nil ~= tbl1), "Missing argument tbl1 on fnl/tangerine/utils/env.fnl:29")
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
local schema = {source = "string", target = "string", vimrc = "string", rtpdirs = "list", compiler = {float = "boolean", clean = "boolean", force = "boolean", verbose = "boolean", globals = "list", version = {"oneof", {"latest", "1-0-0", "0-10-0", "0-9-2"}}, hooks = {"array", {"onsave", "onload", "oninit"}}}, diagnostic = {float = "boolean", virtual = "boolean", timeout = "number"}, eval = {float = "boolean"}, keymaps = {PeakBuffer = "string", EvalBuffer = "string", GotoOutput = "string", Float = {Next = "string", Prev = "string", Close = "string", KillAll = "string", ResizeI = "string", ResizeD = "string"}}, highlight = {float = "string", success = "string", errors = "string", virtual = "string"}}
local pre_schema = {source = resolve, target = resolve, vimrc = resolve, rtpdirs = nil, compiler = nil, diagnostic = nil, eval = nil, keymaps = nil, highlight = nil}
local ENV = {vimrc = resolve((config_dir .. "/init.fnl")), source = resolve((config_dir .. "/fnl/")), target = resolve((config_dir .. "/lua/")), rtpdirs = {}, compiler = {float = true, clean = true, force = false, verbose = true, globals = vim.tbl_keys(_G), version = "latest", hooks = {}}, diagnostic = {float = true, virtual = true, timeout = 10}, eval = {float = true}, keymaps = {PeakBuffer = "gL", EvalBuffer = "gE", GotoOutput = "gO", Float = {Next = "<C-K>", Prev = "<C-J>", Close = "<Enter>", KillAll = "<Esc>", ResizeI = "<C-W>=", ResizeD = "<C-W>-"}}, highlight = {float = "Normal", success = "String", errors = "DiagnosticError", virtual = "DiagnosticVirtualTextError"}}
local function validate_type(name, val, scm)
  _G.assert((nil ~= scm), "Missing argument scm on fnl/tangerine/utils/env.fnl:143")
  _G.assert((nil ~= val), "Missing argument val on fnl/tangerine/utils/env.fnl:143")
  _G.assert((nil ~= name), "Missing argument name on fnl/tangerine/utils/env.fnl:143")
  local function fail()
    return error(("[tangerine]: bad argument in 'setup()' :" .. name .. ", " .. scm .. " expected got " .. type(val) .. "."))
  end
  if (scm == "list") then
    return (vim.tbl_islist(val) or fail())
  elseif "else" then
    return ((type(val) == scm) or fail())
  else
    return nil
  end
end
local function validate_oneof(name, val, scm)
  _G.assert((nil ~= scm), "Missing argument scm on fnl/tangerine/utils/env.fnl:152")
  _G.assert((nil ~= val), "Missing argument val on fnl/tangerine/utils/env.fnl:152")
  _G.assert((nil ~= name), "Missing argument name on fnl/tangerine/utils/env.fnl:152")
  validate_type(name, val, "string")
  if not vim.tbl_contains(scm, val) then
    local tbl = table.concat(scm, "' '")
    return error(("[tangerine]: bad argument in 'setup()' :" .. name .. " expected to be one-of ('" .. tbl .. "') got '" .. val .. "'."))
  else
    return nil
  end
end
local function validate_array(name, array, scm)
  _G.assert((nil ~= scm), "Missing argument scm on fnl/tangerine/utils/env.fnl:160")
  _G.assert((nil ~= array), "Missing argument array on fnl/tangerine/utils/env.fnl:160")
  _G.assert((nil ~= name), "Missing argument name on fnl/tangerine/utils/env.fnl:160")
  validate_type(name, array, "table")
  for _, val in ipairs(array) do
    validate_oneof(name, val, scm)
  end
  return nil
end
local function validate(tbl, schema0)
  _G.assert((nil ~= schema0), "Missing argument schema on fnl/tangerine/utils/env.fnl:166")
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:166")
  for key, val in pairs(tbl) do
    local scm = (schema0)[key]
    if not (schema0)[key] then
      error(("[tangerine]: invalid key " .. key))
    else
    end
    if ("string" == type(scm)) then
      validate_type(key, val, scm)
    else
      local _8_
      do
        local t_7_ = scm
        if (nil ~= t_7_) then
          t_7_ = (t_7_)[1]
        else
        end
        _8_ = t_7_
      end
      if ("oneof" == _8_) then
        validate_oneof(key, val, scm[2])
      else
        local _11_
        do
          local t_10_ = scm
          if (nil ~= t_10_) then
            t_10_ = (t_10_)[1]
          else
          end
          _11_ = t_10_
        end
        if ("array" == _11_) then
          validate_array(key, val, scm[2])
        elseif ("table" == type(scm)) then
          validate(val, scm)
        else
        end
      end
    end
  end
  return nil
end
local function pre_process(tbl, schema0)
  _G.assert((nil ~= schema0), "Missing argument schema on fnl/tangerine/utils/env.fnl:180")
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:180")
  for key, val in pairs(tbl) do
    local pre = (schema0)[key]
    if (type(pre) == "table") then
      pre_process(val, pre)
    elseif (type(pre) ~= "nil") then
      tbl[key] = pre(val)
    else
    end
  end
  return tbl
end
local function rget(tbl, args)
  _G.assert((nil ~= args), "Missing argument args on fnl/tangerine/utils/env.fnl:194")
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:194")
  if (0 == #args) then
    return tbl
  elseif "else" then
    local current
    do
      local t_15_ = tbl
      if (nil ~= t_15_) then
        t_15_ = (t_15_)[args[1]]
      else
      end
      current = t_15_
    end
    table.remove(args, 1)
    if current then
      return rget(current, args)
    else
      return nil
    end
  else
    return nil
  end
end
local function env_get(...)
  return rget(ENV, {...})
end
local function env_get_config(opts, args)
  _G.assert((nil ~= args), "Missing argument args on fnl/tangerine/utils/env.fnl:207")
  _G.assert((nil ~= opts), "Missing argument opts on fnl/tangerine/utils/env.fnl:207")
  local key = args[#args]
  if (nil ~= opts[key]) then
    return opts[key]
  elseif "else" then
    return rget(ENV, args)
  else
    return nil
  end
end
local function env_set(tbl)
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/env.fnl:219")
  validate(tbl, schema)
  pre_process(tbl, pre_schema)
  return deepcopy(tbl, ENV)
end
return {get = env_get, set = env_set, conf = env_get_config}
