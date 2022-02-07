local df = {}
df["create-marker"] = function(source)
  _G.assert((nil ~= source), "Missing argument source on fnl/tangerine/utils/diff.fnl:3")
  local base = "-- :fennel:"
  local meta = vim.fn.getftime(source)
  return (base .. meta)
end
df["read-marker"] = function(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/utils/diff.fnl:9")
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
    local bytes = file:read(21)
    local marker = string.match((bytes or ""), "fennel:(.*)")
    if not (marker and bytes) then
      return false
    else
      return tonumber(marker)
    end
  end
  return close_handlers_8_auto(_G.xpcall(_2_, (package.loaded.fennel or debug).traceback))
end
df["stale?"] = function(source, target)
  _G.assert((nil ~= target), "Missing argument target on fnl/tangerine/utils/diff.fnl:18")
  _G.assert((nil ~= source), "Missing argument source on fnl/tangerine/utils/diff.fnl:18")
  if (1 == vim.fn.filereadable(target)) then
    local source_time = vim.fn.getftime(source)
    local target_marker = df["read-marker"](target)
    return (source_time ~= target_marker)
  else
    return true
  end
end
return df
