; ABOUT:
;   Defines mappings for vim[cmds] as described in ENV.
;
; DEPENDS:
; (nmap! vmap!) vim[cmds]
; (nmap! vmap!) utils[env]
(local env (require :tangerine.utils.env))

(local {
  : PeakBuffer
  : EvalBuffer
  : GotoOutput
} (env.get :keymaps))

;; -------------------- ;;
;;        Utils         ;;
;; -------------------- ;;
(lambda nmap! [lhs rhs]
  (vim.api.nvim_set_keymap :n lhs (.. ":" rhs "<CR>") {:noremap true :silent true}))

(lambda vmap! [lhs rhs]
  (vim.api.nvim_set_keymap :v lhs (.. ":'<,'>" rhs "<CR>") {:noremap true :silent true}))


;; -------------------- ;;
;;         MAPS         ;;
;; -------------------- ;;
(nmap! PeakBuffer :FnlPeak)
(vmap! PeakBuffer :FnlPeak)

(nmap! EvalBuffer :FnlBuffer)
(vmap! EvalBuffer :FnlBuffer)

(nmap! GotoOutput :FnlGotoOutput)


[true]
