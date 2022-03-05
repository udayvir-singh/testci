; ABOUT:
;   Serializes evaluation results and pretty prints them.
;
; DEPENDS:
; (show) utils[env]
; (show) utils[window]
(local env (require :tangerine.utils.env))
(local win (require :tangerine.utils.window))
(local dp {})

;; -------------------- ;;
;;      Serialize       ;;
;; -------------------- ;; 
(lambda escape-quotes [str]
  "shell escapes double quotes in 'str'."
  (let [qt  "\"" esc "\\\""]
       (.. qt (str:gsub qt esc) qt)))

(lambda serialize-tbl [tbl]
  "converts 'tbl' into readable fennel table."
  (-> (vim.inspect tbl)
      ;; escape single quotes
      (string.gsub "= +'([^']+)'" escape-quotes)
      ;; remove "," and "= "
      (string.gsub "," "")
      (string.gsub "= " "")
      ;; append ":" in front of keys
      (string.gsub "(\n -)[^<[%w]([%w_-])" "%1 :%2")
      ;; convert [key] to :key
      (string.gsub "(\n -)%[\"(.-)\"%]" "%1:%2")
      (string.gsub "(\n -)%[(.-)%]" "%1%2")
      ;; convert {1, 2} to [1 2]
      (string.gsub "^%{ (.+)%}" "[ %1]")
      (string.gsub "%{( [^{}]+ )%}" "[%1]") ; ignore brackets in nested lists
      (string.gsub "%{( [^{}]+ )%}" "[%1]")))

(fn dp.serialize [xs return?]
  "converts 'xs' into human readable form."
  (var out "")
  (if (= (type xs) :table)
      (set out (serialize-tbl xs))
      :else
      (set out (vim.inspect xs)))
  (.. (if return? ":return " "") out))


;; -------------------- ;;
;;        Output        ;;
;; -------------------- ;;
(lambda dp.show [?val opts]
  "serializes 'val' and displays inside float if opts.float = true."
  ;; opts { :float boolean }
  (if (= ?val nil) (lua :return))
  (let [out (dp.serialize ?val true)]
    (if (env.conf opts [:eval :float])
        (win.set-float out :fennel (env.get :highlight :float))
        :else
        (print out)))
  :return true)

(lambda dp.show-lua [code opts]
  "show lua 'code' inside float if opts.float = true."
  ;; opts { :float boolean }
  (if (env.conf opts [:eval :float])
      (win.set-float code :lua (env.get :highlight :float))
      :else
      (print code))
  :return true)

; EXAMPLES:
; (local example {
;   2 [1 [2] 3]        
;   :foo "baz \""
; })
; (dp.show example {:float true})
; (dp.show-lua "print('example')" {:float true})


:return dp
