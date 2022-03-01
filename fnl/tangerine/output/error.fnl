; DEPENDS:
; (err.*) utils[env]
; (float) utils[window]
(local env (require :tangerine.utils.env))
(local win (require :tangerine.utils.window))
(local err {})

(local hl-errors  (env.get :highlight :errors))
(local hl-virtual (env.get :highlight :virtual))

;; -------------------- ;;
;;       Parsing        ;;
;; -------------------- ;;
(fn number? [int]
  "checks if 'int' is of number type."
  (= (type int) :number))

(fn toboolean [x]
  "converts 'x' to a boolean based on it truthiness."
  (if x true false))

(lambda err.compile? [msg]
  "checks if 'msg' is an compile-time error."
  (toboolean 
    (or (msg:match "^Parse error.*:([0-9]+)")
        (msg:match "^Compile error.*:([0-9]+)"))))

(lambda err.parse [msg offset]
  "parses raw error 'msg' to (line msg) values."
  (let [lines (vim.split msg "\n")
        line  (string.match (. lines 1) ".*:([0-9]+)")
        msg   (string.gsub  (. lines 2) "^ +" "")]
    (values (+ (tonumber line) offset) msg)))


;; -------------------- ;;
;;      Diagnostic      ;;
;; -------------------- ;;
(local timer {:t (vim.loop.new_timer)})

(lambda err.clear []
  "clears all errors in current namespace."
  (let [namespace  (vim.api.nvim_create_namespace :tangerine)]
       (vim.api.nvim_buf_clear_namespace 0 namespace 0 -1)))

(lambda err.send [line msg]
  "create diagnostic error on line-number 'line' with virtual text of 'msg'."
  (let [line       (- line 1)
        msg        (.. ";; " msg)
        timeout    (env.get :diagnostic :timeout)
        timer      timer.t
        namespace  (vim.api.nvim_create_namespace :tangerine)]
    (vim.api.nvim_buf_add_highlight 0 namespace hl-errors line 0 -1)

    (vim.api.nvim_buf_set_extmark 0 namespace line 0 {
        :virt_text [[msg hl-virtual]]
    })

    (timer:start (* 1000 timeout) 0
                 (vim.schedule_wrap #(vim.api.nvim_buf_clear_namespace 0 namespace 0 -1)))
    true))


;; -------------------- ;;
;;        Errors        ;;
;; -------------------- ;;
(lambda err.soft [msg]
  "echo 'msg' with Error highlight."
  (vim.api.nvim_echo [[msg hl-errors]] false {}))

(lambda err.float [msg]
  "creates floating buffer with Error highlighted 'msg'."
  (win.set-float msg :text hl-errors))

(lambda err.handle [msg opts]
  "handler for fennel errors, meant to be used with xpcall."
  ;; opts { :float boolean :virtual boolean :offset number }
  ;; handle diagnostic
  (if (and (env.conf opts [:diagnostic :virtual]) 
           (err.compile? msg) 
           (number? opts.offset))
      (err.send (err.parse msg opts.offset)))
  ;; display error
  (if (env.conf opts [:diagnostic :float])
      (err.float msg)
      (err.soft msg))
  :return true)

; EXAMPLES:
; (err.handle "Compile error:0\n  example message"
;             {:float true :virtual true :offset 90})


:return err
