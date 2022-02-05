local env = require("tangerine.utils.env")
local log = {}
local function get_sep(arr)
  _G.assert((nil ~= arr), "Missing argument arr on fnl/tangerine/utils/logger.fnl:9")
  if (5 > #arr) then
    return " "
  elseif "else" then
    return "\n=> "
  else
    return nil
  end
end
local function print_array(arr, title)
  _G.assert((nil ~= title), "Missing argument title on fnl/tangerine/utils/logger.fnl:13")
  _G.assert((nil ~= arr), "Missing argument arr on fnl/tangerine/utils/logger.fnl:13")
  local sep = get_sep(arr)
  local out = table.concat(arr, sep)
  return print((title .. sep .. out))
end
local function disable_3f(_3fverbose)
  local env_verbose = env.get("compiler", "verbose")
  if (true == _3fverbose) then
    return false
  elseif (false == _3fverbose) then
    return true
  elseif (false == env_verbose) then
    return true
  else
    return nil
  end
end
log.compiled = function(files, _3fverbose)
  _G.assert((nil ~= files), "Missing argument files on fnl/tangerine/utils/logger.fnl:27")
  if (disable_3f(_3fverbose) or (0 == #files)) then
    return
  else
  end
  vim.cmd("redraw")
  return print_array(files, "COMPILED:")
end
log["compiled-buffer"] = function(_3fverbose)
  if disable_3f(_3fverbose) then
    return
  else
  end
  local bufname = vim.fn.expand("%")
  local qt = "\""
  vim.cmd("redraw")
  return print((qt .. bufname .. qt .. " compiled"))
end
log.cleaned = function(files, _3fverbose)
  _G.assert((nil ~= files), "Missing argument files on fnl/tangerine/utils/logger.fnl:46")
  if (disable_3f(_3fverbose) or (0 == #files)) then
    return
  else
  end
  return print_array(files, "CLEANED:")
end
local function serialize(tbl)
  _G.assert((nil ~= tbl), "Missing argument tbl on fnl/tangerine/utils/logger.fnl:56")
  local out = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(vim.inspect(tbl), ",", ""), "= ", ""), "(\n.-)%[\"(.-)\"%]", "%1%2"), "(\n.-)[^<%w*]([%w_-])", "%1 :%2"), "(\n.-)%{( .- )%}", "%1[%2]"), "^%{( .- )%}$", "[%1]")
  return out
end
log.serialize = serialize
log.value = function(val)
  if ("table" == type(val)) then
    return print(":return", serialize(val))
  elseif (val ~= nil) then
    return print(":return", vim.inspect(val))
  else
    return nil
  end
end
return log
