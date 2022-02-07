local prefix = "tangerine."
local function lazy(module, func)
  _G.assert((nil ~= func), "Missing argument func on fnl/tangerine/api/init.fnl:10")
  _G.assert((nil ~= module), "Missing argument module on fnl/tangerine/api/init.fnl:10")
  local function _1_(...)
    return require((prefix .. module))[func](...)
  end
  return _1_
end
return {eval = {string = lazy("api.eval", "string"), file = lazy("api.eval", "file"), range = lazy("api.eval", "range"), buffer = lazy("api.eval", "buffer")}, compile = {string = lazy("api.compile", "string"), file = lazy("api.compile", "file"), dir = lazy("api.compile", "dir"), buffer = lazy("api.compile", "buffer"), vimrc = lazy("api.compile", "vimrc"), rtp = lazy("api.compile", "rtp"), all = lazy("api.compile", "all")}, clean = {target = lazy("api.clean", "target"), orphaned = lazy("api.clean", "orphaned")}, goto_output = lazy("utils.path", "goto-output"), serialize = lazy("utils.logger", "serialize")}
