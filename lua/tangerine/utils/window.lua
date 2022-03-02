local env = require("tangerine.utils.env")
local win = {}
local win_stack = {total = 0}
local function insert_stack(win_2a)
  _G.assert((nil ~= win_2a), "Missing argument win* on fnl/tangerine/utils/window.fnl:17")
  return table.insert(win_stack, {win_2a, vim.api.nvim_win_get_config(win_2a)})
end
local function remove_stack(idx_2a, conf_2a)
  _G.assert((nil ~= conf_2a), "Missing argument conf* on fnl/tangerine/utils/window.fnl:21")
  _G.assert((nil ~= idx_2a), "Missing argument idx* on fnl/tangerine/utils/window.fnl:21")
  for idx, _1_ in ipairs(win_stack) do
    local _each_2_ = _1_
    local win0 = _each_2_[1]
    local conf = _each_2_[2]
    if ((idx_2a < idx) and vim.api.nvim_win_is_valid(win0)) then
      conf["row"][false] = (conf.row[false] + conf_2a.height + 2)
      vim.api.nvim_win_set_config(win0, conf)
    else
    end
  end
  return table.remove(win_stack, idx_2a)
end
local function normalize_parent(win_2a)
  _G.assert((nil ~= win_2a), "Missing argument win* on fnl/tangerine/utils/window.fnl:29")
  for idx, _4_ in ipairs(win_stack) do
    local _each_5_ = _4_
    local win0 = _each_5_[1]
    local conf = _each_5_[2]
    if (win0 == win_2a) then
      vim.api.nvim_set_current_win(conf.win)
    else
    end
  end
  return nil
end
local function update_stack()
  local total = 0
  for idx, _7_ in ipairs(win_stack) do
    local _each_8_ = _7_
    local win0 = _each_8_[1]
    local conf = _each_8_[2]
    if vim.api.nvim_win_is_valid(win0) then
      total = (total + conf.height + 2)
    elseif "else" then
      remove_stack(idx, conf)
    else
    end
  end
  win_stack["total"] = total
  return true
end
do
  local _let_10_ = {timer = vim.loop.new_timer()}
  local timer = _let_10_["timer"]
  timer:start(200, 200, vim.schedule_wrap(update_stack))
end
local function move_stack(start, steps)
  _G.assert((nil ~= steps), "Missing argument steps on fnl/tangerine/utils/window.fnl:55")
  _G.assert((nil ~= start), "Missing argument start on fnl/tangerine/utils/window.fnl:55")
  local index = start
  for idx, _11_ in ipairs(win_stack) do
    local _each_12_ = _11_
    local win0 = _each_12_[1]
    local conf = _each_12_[2]
    local idx_2a = (idx + steps)
    if ((win0 == vim.fn.win_getid()) and win_stack[idx_2a]) then
      index = idx_2a
    else
    end
  end
  if win_stack[index] then
    return vim.api.nvim_set_current_win(win_stack[index][1])
  else
    return nil
  end
end
win.next = function(_3fsteps)
  return move_stack(1, (_3fsteps or 1))
end
win.prev = function(_3fsteps)
  return move_stack(#win_stack, (-1 * (_3fsteps or 1)))
end
win.close = function()
  local current = vim.fn.win_getid()
  for idx, _15_ in ipairs(win_stack) do
    local _each_16_ = _15_
    local win0 = _each_16_[1]
    local conf = _each_16_[2]
    if (win0 == current) then
      vim.api.nvim_win_close(win0, true)
      update_stack()
      local _17_
      if win_stack[idx] then
        _17_ = idx
      elseif win_stack[(idx + 1)] then
        _17_ = (idx + 1)
      else
        _17_ = (idx - 1)
      end
      move_stack(_17_, 0)
    else
    end
  end
  return nil
end
win.killall = function()
  for idx = 1, #win_stack do
    vim.api.nvim_win_close(win_stack[idx][1], true)
    do end (win_stack)[idx] = nil
  end
  win_stack["total"] = 0
  return nil
end
local function lineheight(lines)
  _G.assert((nil ~= lines), "Missing argument lines on fnl/tangerine/utils/window.fnl:97")
  local height = 0
  local width = vim.api.nvim_win_get_width(0)
  for _, line in ipairs(lines) do
    height = (math.max(math.ceil(((#line + 2) / width), 1), 1) + height)
  end
  return height
end
local function nmap_21(buffer, lhs, rhs)
  _G.assert((nil ~= rhs), "Missing argument rhs on fnl/tangerine/utils/window.fnl:109")
  _G.assert((nil ~= lhs), "Missing argument lhs on fnl/tangerine/utils/window.fnl:109")
  _G.assert((nil ~= buffer), "Missing argument buffer on fnl/tangerine/utils/window.fnl:109")
  return vim.api.nvim_buf_set_keymap(buffer, "n", lhs, ("<cmd>" .. rhs .. "<CR>"), {silent = true, noremap = true})
end
local function setup_mappings(buffer)
  _G.assert((nil ~= buffer), "Missing argument buffer on fnl/tangerine/utils/window.fnl:113")
  local _local_20_ = env.get("mapping")
  local WinNext = _local_20_["WinNext"]
  local WinPrev = _local_20_["WinPrev"]
  local WinClose = _local_20_["WinClose"]
  local WinKill = _local_20_["WinKill"]
  nmap_21(buffer, WinNext, "FnlWinNext")
  nmap_21(buffer, WinPrev, "FnlWinPrev")
  nmap_21(buffer, WinKill, "FnlWinKill")
  return nmap_21(buffer, WinClose, "FnlWinClose")
end
win["create-float"] = function(lineheight0, filetype, highlight)
  _G.assert((nil ~= highlight), "Missing argument highlight on fnl/tangerine/utils/window.fnl:125")
  _G.assert((nil ~= filetype), "Missing argument filetype on fnl/tangerine/utils/window.fnl:125")
  _G.assert((nil ~= lineheight0), "Missing argument lineheight on fnl/tangerine/utils/window.fnl:125")
  normalize_parent(vim.fn.win_getid())
  local buffer = vim.api.nvim_create_buf(false, true)
  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)
  local bordersize = 2
  local width = (win_width - bordersize)
  local height = math.max(1, math.floor(math.min((win_height / 1.5), lineheight0)))
  vim.api.nvim_open_win(buffer, true, {width = width, height = height, col = 0, row = (win_height - bordersize - height - win_stack.total), style = "minimal", anchor = "NW", border = "single", relative = "win"})
  insert_stack(vim.fn.win_getid())
  update_stack()
  vim.api.nvim_buf_set_option(buffer, "ft", filetype)
  vim.api.nvim_win_set_option(0, "winhl", ("Normal:" .. highlight))
  setup_mappings(buffer)
  return buffer
end
win["set-float"] = function(lines, filetype, highlight)
  _G.assert((nil ~= highlight), "Missing argument highlight on fnl/tangerine/utils/window.fnl:154")
  _G.assert((nil ~= filetype), "Missing argument filetype on fnl/tangerine/utils/window.fnl:154")
  _G.assert((nil ~= lines), "Missing argument lines on fnl/tangerine/utils/window.fnl:154")
  local lines0 = vim.split(lines, "\n")
  local nlines = lineheight(lines0)
  local buffer = win["create-float"](nlines, filetype, highlight)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, true, lines0)
  return true
end
return win
