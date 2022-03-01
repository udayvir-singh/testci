local _local_1_ = require("tangerine.utils")
local p = _local_1_["p"]
local fs = _local_1_["fs"]
local df = _local_1_["df"]
local env = _local_1_["env"]
local _local_2_ = require("tangerine.output")
local log = _local_2_["log"]
local clean = {}
clean.target = function(target, _3fopts)
  _G.assert((nil ~= target), "Missing argument target on fnl/tangerine/api/clean.fnl:23")
  local opts = (_3fopts or {})
  local target0 = p.resolve(target)
  local marker_3f = df["read-marker"](target0)
  local source_3f = fs["readable?"](p.source(target0))
  local force_3f = env.conf(opts, {"force"})
  if (marker_3f and (not source_3f or force_3f)) then
    return fs.remove(target0)
  elseif "else" then
    return false
  else
    return nil
  end
end
clean.orphaned = function(_3fopts)
  local opts = (_3fopts or {})
  local logs = {}
  for _, target in ipairs(p["list-lua-files"]()) do
    if clean.target(target, opts) then
      table.insert(logs, p.shortname(target))
    else
    end
  end
  return log.success("CLEANED", logs, opts)
end
return clean
