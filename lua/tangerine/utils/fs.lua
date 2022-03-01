local fs = {}
fs.dirname = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/fs.fnl:6")
  return path:match("(.*[/\\])")
end
fs.mkdir = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/fs.fnl:9")
  return vim.fn.mkdir(path, "p")
end
fs["dir-exists?"] = function(dirpath)
  _G.assert((nil ~= dirpath), "Missing argument dirpath on fnl/tangerine/utils/fs.fnl:12")
  return (1 == vim.fn.isdirectory(dirpath))
end
fs["readable?"] = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/fs.fnl:18")
  return (1 == vim.fn.filereadable(path))
end
fs.read = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/fs.fnl:21")
  local file = assert(io.open(path, "r"))
  local function close_handlers_8_auto(ok_9_auto, ...)
    file:close()
    if ok_9_auto then
      return ...
    else
      return error(..., 0)
    end
  end
  local function _2_()
    return file:read("*a")
  end
  return close_handlers_8_auto(_G.xpcall(_2_, (package.loaded.fennel or debug).traceback))
end
fs.write = function(path, content)
  _G.assert((nil ~= content), "Missing argument content on fnl/tangerine/utils/fs.fnl:25")
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/fs.fnl:25")
  local dir = fs.dirname(path)
  if not fs["dir-exists?"](dir) then
    fs.mkdir(dir)
  else
  end
  local file = assert(io.open(path, "w"))
  local function close_handlers_8_auto(ok_9_auto, ...)
    file:close()
    if ok_9_auto then
      return ...
    else
      return error(..., 0)
    end
  end
  local function _5_()
    return file:write(content)
  end
  return close_handlers_8_auto(_G.xpcall(_5_, (package.loaded.fennel or debug).traceback))
end
fs.remove = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/fs.fnl:32")
  return os.remove(path)
end
return fs
