local env = require("tangerine.utils.env")
local win = require("tangerine.utils.window")
local err = {}
local hl_errors = env.get("highlight", "errors")
local hl_virtual = env.get("highlight", "virtual")
local function number_3f(int)
  return (type(int) == "number")
end
local function toboolean(x)
  if x then
    return true
  else
    return false
  end
end
err["compile?"] = function(msg)
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/output/error.fnl:22")
  return toboolean((msg:match("^Parse error.*:([0-9]+)") or msg:match("^Compile error.*:([0-9]+)")))
end
err.parse = function(msg, offset)
  _G.assert((nil ~= offset), "Missing argument offset on fnl/tangerine/output/error.fnl:28")
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/output/error.fnl:28")
  local lines = vim.split(msg, "\n")
  local line = string.match(lines[1], ".*:([0-9]+)")
  local msg0 = string.gsub(lines[2], "^ +", "")
  return (tonumber(line) + offset), msg0
end
local timer = {t = vim.loop.new_timer()}
err.clear = function()
  local namespace = vim.api.nvim_create_namespace("tangerine")
  return vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end
err.send = function(line, msg)
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/output/error.fnl:46")
  _G.assert((nil ~= line), "Missing argument line on fnl/tangerine/output/error.fnl:46")
  local line0 = (line - 1)
  local msg0 = (";; " .. msg)
  local timeout = env.get("diagnostic", "timeout")
  local timer0 = timer.t
  local namespace = vim.api.nvim_create_namespace("tangerine")
  vim.api.nvim_buf_add_highlight(0, namespace, hl_errors, line0, 0, -1)
  vim.api.nvim_buf_set_extmark(0, namespace, line0, 0, {virt_text = {{msg0, hl_virtual}}})
  local function _2_()
    return vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
  end
  timer0:start((1000 * timeout), 0, vim.schedule_wrap(_2_))
  return true
end
err.soft = function(msg)
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/output/error.fnl:67")
  return vim.api.nvim_echo({{msg, hl_errors}}, false, {})
end
err.float = function(msg)
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/output/error.fnl:71")
  return win["set-float"](msg, "text", hl_errors)
end
err.handle = function(msg, opts)
  _G.assert((nil ~= opts), "Missing argument opts on fnl/tangerine/output/error.fnl:75")
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/output/error.fnl:75")
  if (env.conf(opts, {"diagnostic", "virtual"}) and err["compile?"](msg) and number_3f(opts.offset)) then
    err.send(err.parse(msg, opts.offset))
  else
  end
  if env.conf(opts, {"diagnostic", "float"}) then
    err.float(msg)
  else
    err.soft(msg)
  end
  return true
end
return err
