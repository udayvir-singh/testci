local env = require("tangerine.utils.env")
local function format_path(path, ext, _3fmacro)
  _G.assert((nil ~= ext), "Missing argument ext on fnl/tangerine/fennel.fnl:9")
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/fennel.fnl:9")
  local function _1_()
    if _3fmacro then
      return (";" .. path .. "?/init-macros.fnl")
    else
      return ""
    end
  end
  return (path .. "?." .. ext .. ";" .. path .. "?/init." .. ext .. _1_())
end
local function get_rtp(ext, _3fmacro)
  _G.assert((nil ~= ext), "Missing argument ext on fnl/tangerine/fennel.fnl:14")
  local out = {format_path(env.get("source"), ext, _3fmacro)}
  do
    local rtp = (vim.o.runtimepath .. ",")
    for entry in rtp:gmatch("(.-),") do
      local path = (entry .. "/fnl/")
      if (1 == vim.fn.isdirectory(path)) then
        table.insert(out, format_path(path, ext, _3fmacro))
      else
      end
    end
  end
  return table.concat(out, ";")
end
local function load_fennel(version)
  local version0 = (version or env.get("compiler", "version"))
  local fennel = require(("tangerine.fennel." .. version0))
  fennel.path = get_rtp("fnl", false)
  fennel["macro-path"] = get_rtp("fnl", true)
  return fennel
end
local original_path = {package.path}
local function patch_package_path()
  local path = get_rtp("lua")
  local target = format_path(env.get("target"), "lua")
  package.path = (target .. ";" .. path .. ";" .. original_path[1])
  return true
end
return {load = load_fennel, ["patch-package-path"] = patch_package_path}
