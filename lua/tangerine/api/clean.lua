local _local_1_ = require("tangerine.utils")
local p = _local_1_["p"]
local fs = _local_1_["fs"]
local df = _local_1_["df"]
local log = _local_1_["log"]
local function clean_target(target, _3fforce)
  _G.assert((nil ~= target), "Missing argument target on fnl/tangerine/api/clean.fnl:13")
  local target0 = p.resolve(target)
  local marker_3f = df["read-marker"](target0)
  local source_3f = fs["readable?"](p.source(target0))
  if (marker_3f and (not source_3f or (_3fforce == true))) then
    return fs.remove(target0)
  elseif "else" then
    return false
  else
    return nil
  end
end
local function clean_orphaned(_3fopts)
  local opts = (_3fopts or {})
  local logs = {}
  for _, target in ipairs(p["list-lua-files"]()) do
    if clean_target(target, opts.force) then
      table.insert(logs, p.shortname(target))
    else
    end
  end
  return log.cleaned(logs)
end
return {target = clean_target, orphaned = clean_orphaned}
