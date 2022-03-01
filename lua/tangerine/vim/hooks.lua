local env = require("tangerine.utils.env")
local function exec(...)
  return vim.cmd(table.concat({...}, " "))
end
local function parse_autocmd(cmds)
  _G.assert((nil ~= cmds), "Missing argument cmds on fnl/tangerine/vim/hooks.fnl:12")
  local groups = table.concat(cmds[1], " ")
  table.remove(cmds, 1)
  return "au", groups, table.concat(cmds, " ")
end
local function augroup(name, ...)
  _G.assert((nil ~= name), "Missing argument name on fnl/tangerine/vim/hooks.fnl:17")
  exec("augroup", name)
  exec("au!")
  for idx, val in ipairs({...}) do
    exec(parse_autocmd(val))
  end
  exec("augroup", "END")
  return true
end
local source = env.get("source")
local vimrc = env.get("vimrc")
local pat = (source .. "*.fnl" .. "," .. vimrc)
local function run_hooks()
  local clean_3f = env.get("compiler", "clean")
  if clean_3f then
    _G.tangerine.api.clean.orphaned()
  else
  end
  return _G.tangerine.api.compile.all()
end
local lua_run_hooks = "lua :require 'tangerine.vim.hooks'.run()"
local function _2_()
  return augroup("tangerine-onload", {{"VimEnter", "*"}}, lua_run_hooks)
end
local function _3_()
  return augroup("tangerine-onsave", {{"BufWritePost", pat}}, lua_run_hooks)
end
local function _4_()
  return run_hooks()
end
return {onload = _2_, onsave = _3_, oninit = _4_, run = run_hooks}
