local env = require("tangerine.utils.env")
local p = {}
p.shortname = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/path.fnl:9")
  return (path:match(".+/fnl/(.+)") or path:match(".+/lua/(.+)") or path:match(".+/(.+/.+)"))
end
p.resolve = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/path.fnl:15")
  return vim.fn.resolve(vim.fn.expand(path))
end
p["resolve-rtpdir"] = function(dir)
  _G.assert((nil ~= dir), "Missing argument dir on fnl/tangerine/utils/path.fnl:19")
  local path = p.resolve(dir)
  if vim.startswith(path, "/") then
    return path
  elseif "else" then
    return (vim.fn.stdpath("config") .. "/" .. dir)
  else
    return nil
  end
end
local vimrc_out = (env.get("target") .. "tangerine_vimrc.lua")
p["from-x-to-y"] = function(path, _2_, _4_)
  local _arg_3_ = _2_
  local from = _arg_3_[1]
  local ext1 = _arg_3_[2]
  local _arg_5_ = _4_
  local to = _arg_5_[1]
  local ext2 = _arg_5_[2]
  _G.assert((nil ~= ext2), "Missing argument ext2 on fnl/tangerine/utils/path.fnl:32")
  _G.assert((nil ~= to), "Missing argument to on fnl/tangerine/utils/path.fnl:32")
  _G.assert((nil ~= ext1), "Missing argument ext1 on fnl/tangerine/utils/path.fnl:32")
  _G.assert((nil ~= from), "Missing argument from on fnl/tangerine/utils/path.fnl:32")
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/path.fnl:32")
  local from0 = env.get(from)
  local to0 = env.get(to)
  local path0 = path:gsub((ext1 .. "$"), ext2)
  if vim.startswith(path0, from0) then
    return path0:gsub(from0, to0)
  elseif "else" then
    return path0:gsub(("/" .. ext1 .. "/"), ("/" .. ext2 .. "/"))
  else
    return nil
  end
end
p.target = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/path.fnl:42")
  local vimrc = env.get("vimrc")
  if (path == vimrc) then
    return vimrc_out
  elseif "else" then
    return p["from-x-to-y"](path, {"source", "fnl"}, {"target", "lua"})
  else
    return nil
  end
end
p.source = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/path.fnl:50")
  local vimrc = env.get("vimrc")
  if (path == vimrc_out) then
    return vimrc
  elseif "else" then
    return p["from-x-to-y"](path, {"target", "lua"}, {"source", "fnl"})
  else
    return nil
  end
end
p["goto-output"] = function()
  local target = p.target(vim.fn.expand("%:p"))
  vim.cmd(("badd" .. target))
  return vim.cmd(("b" .. target))
end
p.wildcard = function(dir, pat)
  _G.assert((nil ~= pat), "Missing argument pat on fnl/tangerine/utils/path.fnl:70")
  _G.assert((nil ~= dir), "Missing argument dir on fnl/tangerine/utils/path.fnl:70")
  return vim.fn.glob((dir .. pat), 0, 1)
end
p["list-fnl-files"] = function()
  local source = env.get("source")
  local out = p.wildcard(source, "**/*.fnl")
  return out
end
p["list-lua-files"] = function()
  local target = env.get("target")
  local out = p.wildcard(target, "**/*.lua")
  return out
end
return p
