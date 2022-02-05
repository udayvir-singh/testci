local fennel = require("tangerine.fennel")
local _local_1_ = require("tangerine.utils")
local p = _local_1_["p"]
local fs = _local_1_["fs"]
local df = _local_1_["df"]
local env = _local_1_["env"]
local log = _local_1_["log"]
local function compile_string(str, _3ffilename)
  _G.assert((nil ~= str), "Missing argument str on fnl/tangerine/api/compile.fnl:20")
  local fennel0 = fennel.load()
  return fennel0.compileString(str, {filename = _3ffilename})
end
local function compile_file(source, target)
  _G.assert((nil ~= target), "Missing argument target on fnl/tangerine/api/compile.fnl:25")
  _G.assert((nil ~= source), "Missing argument source on fnl/tangerine/api/compile.fnl:25")
  local source0 = p.resolve(source)
  local target0 = p.resolve(target)
  local sname = p.shortname(source0)
  if not fs["readable?"](source0) then
    error(("[tangerine]: source " .. sname .. " is not readable."))
  else
  end
  local output = compile_string(fs.read(source0), sname)
  local marker = df["create-marker"](source0)
  return fs.write(target0, (marker .. "\n" .. output))
end
local function compile_dir(sourcedir, targetdir, _3fopts)
  _G.assert((nil ~= targetdir), "Missing argument targetdir on fnl/tangerine/api/compile.fnl:37")
  _G.assert((nil ~= sourcedir), "Missing argument sourcedir on fnl/tangerine/api/compile.fnl:37")
  local opts = (_3fopts or {})
  local sources = p.wildcard(sourcedir, "**/*.fnl")
  local logs = {}
  for _, source in ipairs(sources) do
    local luafile = source:gsub(".fnl$", ".lua")
    local target = luafile:gsub(sourcedir, targetdir)
    local compile_3f = (opts.force or df["stale?"](source, target))
    if compile_3f then
      table.insert(logs, p.shortname(source))
      compile_file(source, target)
    else
    end
  end
  return log.compiled(logs, opts.verbose)
end
local function compile_buffer(opts)
  local opts0 = (opts or {})
  local bufname = vim.fn.expand("%:p")
  local target = p.target(bufname)
  compile_file(bufname, target)
  return log["compiled-buffer"](opts0.verbose)
end
local function compile_vimrc(opts)
  local opts0 = (opts or {})
  local vimrc = env.get("vimrc")
  local target = p.target(vimrc)
  local compile_3f = (opts0.force or df["stale?"](vimrc, target))
  if (compile_3f and fs["readable?"](vimrc) and "compile" and compile_file(vimrc, target)) then
    log.compiled({p.shortname(vimrc)}, opts0.verbose)
    return true
  else
    return nil
  end
end
local function compile_all(opts)
  local opts0 = (opts or {})
  local logs = {}
  if compile_vimrc(opts0) then
    table.insert(logs, p.shortname(env.get("vimrc")))
  else
  end
  for _, source in ipairs(p["list-fnl-files"]()) do
    local target = p.target(source)
    local compile_3f = (opts0.force or df["stale?"](source, target))
    if compile_3f then
      table.insert(logs, p.shortname(source))
      compile_file(source, target)
    else
    end
  end
  return log.compiled(logs, opts0.verbose)
end
return {string = compile_string, file = compile_file, dir = compile_dir, buffer = compile_buffer, vimrc = compile_vimrc, all = compile_all}