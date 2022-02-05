local env = require("tangerine.utils.env")
local err = {}
err["compile?"] = function(msg)
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/utils/error.fnl:10")
  if (msg:match("^Parse error.*:([0-9]+)") or msg:match("^Compile error.*:([0-9]+)")) then
    return true
  else
    return false
  end
end
err.parse = function(msg)
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/utils/error.fnl:15")
  local lines = vim.split(msg, "\n")
  local line = string.match(lines[1], ".*:([0-9]+)")
  local msg0 = string.gsub(lines[2], "^ +", "")
  return tonumber(line), msg0
end
local timer = {t = vim.loop.new_timer()}
err.clear = function()
  local namespace = vim.api.nvim_create_namespace("tangerine")
  return vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end
err.send = function(line, msg)
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/utils/error.fnl:31")
  _G.assert((nil ~= line), "Missing argument line on fnl/tangerine/utils/error.fnl:31")
  local line0 = (line - 1)
  local msg0 = (";; " .. msg)
  local hi_normal = env.get("diagnostic", "hi_normal")
  local hi_virtual = env.get("diagnostic", "hi_virtual")
  local timeout = env.get("diagnostic", "timeout")
  local timer0 = timer.t
  local namespace = vim.api.nvim_create_namespace("tangerine")
  vim.api.nvim_buf_add_highlight(0, namespace, hi_normal, line0, 0, -1)
  vim.api.nvim_buf_set_extmark(0, namespace, line0, 0, {virt_text = {{msg0, hi_virtual}}})
  local function _2_()
    return vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
  end
  timer0:start((1000 * timeout), 0, vim.schedule_wrap(_2_))
  return true
end
return err
