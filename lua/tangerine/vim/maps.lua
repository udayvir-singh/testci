local env = require("tangerine.utils.env")
local _local_1_ = env.get("keymaps")
local PeakBuffer = _local_1_["PeakBuffer"]
local EvalBuffer = _local_1_["EvalBuffer"]
local GotoOutput = _local_1_["GotoOutput"]
local function nmap_21(lhs, rhs)
  _G.assert((nil ~= rhs), "Missing argument rhs on fnl/tangerine/vim/maps.fnl:18")
  _G.assert((nil ~= lhs), "Missing argument lhs on fnl/tangerine/vim/maps.fnl:18")
  return vim.api.nvim_set_keymap("n", lhs, (":" .. rhs .. "<CR>"), {noremap = true, silent = true})
end
local function vmap_21(lhs, rhs)
  _G.assert((nil ~= rhs), "Missing argument rhs on fnl/tangerine/vim/maps.fnl:21")
  _G.assert((nil ~= lhs), "Missing argument lhs on fnl/tangerine/vim/maps.fnl:21")
  return vim.api.nvim_set_keymap("v", lhs, (":'<,'>" .. rhs .. "<CR>"), {noremap = true, silent = true})
end
nmap_21(PeakBuffer, "FnlPeak")
vmap_21(PeakBuffer, "FnlPeak")
nmap_21(EvalBuffer, "FnlBuffer")
vmap_21(EvalBuffer, "FnlBuffer")
nmap_21(GotoOutput, "FnlGotoOutput")
return {true}
