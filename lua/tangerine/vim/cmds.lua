local prefix = "lua tangerine.api."
local function odd_3f(int)
  _G.assert((nil ~= int), "Missing argument int on fnl/tangerine/vim/cmds.fnl:8")
  return (0 ~= (int % 2))
end
local function parse_opts(opts)
  _G.assert((nil ~= opts), "Missing argument opts on fnl/tangerine/vim/cmds.fnl:11")
  local out = ""
  for idx, val in ipairs(opts) do
    if odd_3f(idx) then
      out = (out .. "-" .. val)
    elseif "else" then
      out = (out .. "=" .. val .. " ")
    else
    end
  end
  return out
end
local function command_21(name, cmd, opts)
  _G.assert((nil ~= opts), "Missing argument opts on fnl/tangerine/vim/cmds.fnl:20")
  _G.assert((nil ~= cmd), "Missing argument cmd on fnl/tangerine/vim/cmds.fnl:20")
  _G.assert((nil ~= name), "Missing argument name on fnl/tangerine/vim/cmds.fnl:20")
  local opts0 = parse_opts(opts)
  return vim.cmd(("command!" .. " " .. opts0 .. " " .. name .. " " .. prefix .. cmd))
end
local bang_opts = "{ force=(('<bang>' == '!') or nil) }"
command_21("FnlCompileBuffer", "compile.buffer()", {})
command_21("FnlCompile", ("compile.all" .. bang_opts), {"bang", nil})
command_21("FnlClean", ("clean.orphaned" .. bang_opts), {"bang", nil})
command_21("Fnl", "eval.string(<q-args>)", {"nargs", "*"})
command_21("FnlFile", "eval.file(<q-args>)", {"nargs", 1, "complete", "file"})
command_21("FnlBuffer", "eval.buffer(<line1>, <line2>)", {"range", "%"})
command_21("FnlPeak", "eval.peak(<line1>, <line2>)", {"range", "%"})
command_21("FnlWinNext", "win.next(<args>)", {"nargs", "?"})
command_21("FnlWinPrev", "win.prev(<args>)", {"nargs", "?"})
command_21("FnlWinKill", "win.killall()", {})
command_21("FnlWinClose", "win.close()", {})
command_21("FnlGotoOutput", "goto_output()", {})
return {true}
