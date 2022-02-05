local fennel = require("tangerine.fennel")
local _local_1_ = require("tangerine.utils")
local p = _local_1_["p"]
local m = _local_1_["m"]
local fs = _local_1_["fs"]
local log = _local_1_["log"]
local err = _local_1_["err"]
local function get_lines(start, _end)
  _G.assert((nil ~= _end), "Missing argument end on fnl/tangerine/api/eval.fnl:18")
  _G.assert((nil ~= start), "Missing argument start on fnl/tangerine/api/eval.fnl:18")
  return table.concat(vim.api.nvim_buf_get_lines(0, (start - 1), _end, true), "\n")
end
local function softerr(msg)
  _G.assert((nil ~= msg), "Missing argument msg on fnl/tangerine/api/eval.fnl:22")
  return vim.api.nvim_echo({{msg, "Error"}}, false, {})
end
local function eval_string(str, _3ffilename)
  _G.assert((nil ~= str), "Missing argument str on fnl/tangerine/api/eval.fnl:28")
  local fennel0 = fennel.load()
  local filename = (_3ffilename or "string")
  local result = fennel0.eval(str, {filename = filename})
  return log.value(result)
end
local function eval_file(path)
  _G.assert((nil ~= path), "Missing argument path on fnl/tangerine/api/eval.fnl:34")
  local path0 = p.resolve(path)
  local filename = p.shortname(path0)
  return eval_string(fs.read(path0), filename)
end
local function eval_range(start, _end, _3fcount)
  _G.assert((nil ~= _end), "Missing argument end on fnl/tangerine/api/eval.fnl:40")
  _G.assert((nil ~= start), "Missing argument start on fnl/tangerine/api/eval.fnl:40")
  if (_3fcount == 0) then
    softerr("[tangerine]: error in \"eval-range\", Missing argument {range}.")
    return
  else
  end
  local lines = get_lines(start, _end)
  local bufname = vim.fn.expand("%")
  err.clear()
  local ok_3f, res = nil, nil
  local function _3_()
    return eval_string(lines, bufname)
  end
  ok_3f, res = pcall(_3_)
  if ok_3f then
    return "skip"
  elseif err["compile?"](res) then
    return err.send(err.parse(res))
  elseif "else" then
    return softerr(res)
  else
    return nil
  end
end
local function eval_buffer()
  return eval_range(1, -1)
end
return {string = eval_string, file = eval_file, range = eval_range, buffer = eval_buffer}
