; DEPENDS:
; (command!) api[init] - _G.tangerine.api
(local prefix "lua tangerine.api.")

;; -------------------- ;;
;;        Utils         ;;
;; -------------------- ;;
(lambda odd? [int]
  (not= 0 (% int 2)))

(lambda parse-opts [opts]
  (var out "")
  (each [idx val (ipairs opts)]
        (if (odd? idx)
            (set out (.. out "-" val))
            :else 
            (set out (.. out "=" val " "))))
  out)

(lambda command! [name cmd opts]
  (let [opts (parse-opts opts)]
       (vim.cmd (.. :command! " " opts " " name " " prefix cmd))))


;; -------------------- ;;
;;         CMDS         ;;
;; -------------------- ;;
(local bang-opts "{ force=(('<bang>' == '!') or nil) }")

(command! :FnlCompileBuffer "compile.buffer()"              [])
(command! :FnlCompile       (.. "compile.all"    bang-opts) [:bang nil])
(command! :FnlClean         (.. "clean.orphaned" bang-opts) [:bang nil])

(command! :Fnl       "eval.string(<q-args>)"         [:nargs "*"])
(command! :FnlFile   "eval.file(<q-args>)"           [:nargs 1 :complete "file"])
(command! :FnlBuffer "eval.buffer(<line1>, <line2>)" [:range "%"])
(command! :FnlPeak   "eval.peak(<line1>, <line2>)"   [:range "%"])

(command! :FnlWinNext  "win.next(<args>)" [:nargs "?"])
(command! :FnlWinPrev  "win.prev(<args>)" [:nargs "?"])
(command! :FnlWinKill  "win.killall()"    [])
(command! :FnlWinClose "win.close()"      [])

(command! :FnlGotoOutput "goto_output()" [])


[true]
