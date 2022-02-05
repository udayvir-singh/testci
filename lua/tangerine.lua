local fennel = require("tangerine.fennel")
local _local_1_ = require("tangerine.utils")
local env = _local_1_["env"]
local fs = _local_1_["fs"]
local require_api
local function _2_()
  return require("tangerine.api")
end
require_api = _2_
local require_cmds
local function _3_()
  return require("tangerine.vim.cmds")
end
require_cmds = _3_
local require_hooks
local function _4_()
  return require("tangerine.vim.hooks")
end
require_hooks = _4_
local vimrc_module = "tangerine_vimrc"
local function safe_require(module)
  _G.assert((nil ~= module), "Missing argument module on fnl/tangerine.fnl:20")
  local ok_3f, out = pcall(require, module)
  if not ok_3f then
    return print(out)
  elseif "else" then
    return out
  else
    return nil
  end
end
local function load_vimrc()
  local target = env.get("target")
  local path = (target .. vimrc_module .. ".lua")
  if fs["readable?"](path) then
    return safe_require(vimrc_module)
  else
    return nil
  end
end
local function load_api()
  local api = require_api()
  tangerine = {api = api, fennel = fennel.load}
  return nil
end
local function load_cmds()
  return require_cmds()
end
local function load_hooks()
  local hooks = require_hooks()
  for _, hook in ipairs(env.get("compiler", "hooks")) do
    hooks[hook]()
  end
  return nil
end
local function setup(config)
  _G.assert((nil ~= config), "Missing argument config on fnl/tangerine.fnl:50")
  env.set(config)
  fennel["patch-package-path"]()
  load_api()
  load_cmds()
  load_hooks()
  load_vimrc()
  return true
end
return {setup = setup}
