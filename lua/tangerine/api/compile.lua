local fennel = require("tangerine.fennel")
local _local_1_ = require("tangerine.utils")
local p = _local_1_["p"]
local fs = _local_1_["fs"]
local df = _local_1_["df"]
local env = _local_1_["env"]
local log = _local_1_["log"]
local function force_3f(opts)
  _G.assert((nil ~= opts), "Missing argument opts on fnl/tangerine/api/compile.fnl:20")
  if (opts.force ~= nil) then
    return opts.force
  else
    return env.get("compiler", "force")
  end
end
local function compile_3f(source, target, opts)
  _G.assert((nil ~= opts), "Missing argument opts on fnl/tangerine/api/compile.fnl:26")
  _G.assert((nil ~= target), "Missing argument target on fnl/tangerine/api/compile.fnl:26")
  _G.assert((nil ~= source), "Missing argument source on fnl/tangerine/api/compile.fnl:26")
  return (force_3f(opts) or df["stale?"](source, target))
end
local function merge(_3flist1, list2)
  _G.assert((nil ~= list2), "Missing argument list2 on fnl/tangerine/api/compile.fnl:31")
  for i, v in ipairs((_3flist1 or {})) do
    table.insert(list2, v)
  end
  return list2
end
local function compile_string(str, _3ffilename)
  _G.assert((nil ~= str), "Missing argument str on fnl/tangerine/api/compile.fnl:40")
  local fennel0 = fennel.load()
  return fennel0.compileString(str, {filename = _3ffilename})
end
local function compile_file(source, target)
  _G.assert((nil ~= target), "Missing argument target on fnl/tangerine/api/compile.fnl:45")
  _G.assert((nil ~= source), "Missing argument source on fnl/tangerine/api/compile.fnl:45")
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
  _G.assert((nil ~= targetdir), "Missing argument targetdir on fnl/tangerine/api/compile.fnl:59")
  _G.assert((nil ~= sourcedir), "Missing argument sourcedir on fnl/tangerine/api/compile.fnl:59")
  local opts = (_3fopts or {})
  local logs = {}
  local sources = p.wildcard(sourcedir, "**/*.fnl")
  for _, source in ipairs(sources) do
    local luafile = source:gsub(".fnl$", ".lua")
    local target = luafile:gsub(sourcedir, targetdir)
    local compile_3f0 = compile_3f(source, target, opts)
    if compile_3f0 then
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
  local compile_3f0 = compile_3f(vimrc, target, opts0)
  if (compile_3f0 and fs["readable?"](vimrc)) then
    compile_file(vimrc, target)
    return log.compiled({p.shortname(vimrc)}, opts0.verbose)
  else
    return nil
  end
end
local function compile_rtp(opts)
  local opts0 = (opts or {})
  local logs = {}
  local dirs = vim.tbl_map(p["resolve-rtpdir"], merge(env.get("rtpdirs"), (opts0.rtpdirs or {})))
  for _, dir in ipairs(dirs) do
    merge(compile_dir(dir, dir, opts0), logs)
  end
  return logs
end
local function compile_all(opts)
  local opts0 = (opts or {})
  local logs = {}
  merge(compile_vimrc(opts0), logs)
  merge(compile_rtp(opts0), logs)
  for _, source in ipairs(p["list-fnl-files"]()) do
    local target = p.target(source)
    local compile_3f0 = compile_3f(source, target, opts0)
    if compile_3f0 then
      table.insert(logs, p.shortname(source))
      compile_file(source, target)
    else
    end
  end
  return log.compiled(logs, opts0.verbose)
end
return {string = compile_string, file = compile_file, dir = compile_dir, buffer = compile_buffer, vimrc = compile_vimrc, rtp = compile_rtp, all = compile_all}
