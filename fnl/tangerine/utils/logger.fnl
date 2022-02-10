; DEPENDS:
; (disable?) tangerine.utils.env
(local env (require :tangerine.utils.env))
(local log {})

;; -------------------- ;;
;;       Window         ;;
;; -------------------- ;;
(lambda create-float [lineno filetype]
  (let [buffer     (vim.api.nvim_create_buf true true)
        win-width  (vim.api.nvim_win_get_width 0)
        win-height (vim.api.nvim_win_get_height 0)
        bordersize 2
        width      (- win-width bordersize)
        height     (math.floor (math.min (/ win-height 1.5) lineno))]
  (vim.api.nvim_open_win buffer true {
    : width 
    : height
    :col 0
    :row (- win-height bordersize height)
    :style "minimal"
    :anchor "NW"
    :border "single"
    :relative "win"
  })
  ; set options
  (vim.api.nvim_buf_set_option buffer :ft filetype)
  (vim.api.nvim_win_set_option 0      :winhl "Normal:TangerineFloat")
  ; set keymaps
  (vim.api.nvim_buf_set_keymap buffer :n "<Esc>"   ":bd<CR>" {:silent true :noremap true})
  (vim.api.nvim_buf_set_keymap buffer :n "<Enter>" ":bd<CR>" {:silent true :noremap true})
  :return buffer))

(lambda log.infloat [msg filetype]
  (let [lines  (vim.split msg "\n")
        lineno (length lines)
        buffer (create-float lineno filetype)]
    (vim.api.nvim_buf_set_lines buffer 0 -1 true lines)))

;; -------------------- ;;
;;        Utils         ;;
;; -------------------- ;;
(lambda get-sep [arr]
  (if (> 5 (# arr)) " "
      :else "\n=> "))

(lambda print-array [arr title]
  (let [sep (get-sep arr)
        out (table.concat arr sep)]
       (print (.. title sep out))
       arr))

(lambda disable? [?verbose]
  (local env-verbose (env.get :compiler :verbose))
  (if (= true ?verbose)  false
      (= false ?verbose) true
      (= false env-verbose) true))

;; -------------------- ;;
;;     Compile Msgs     ;;
;; -------------------- ;;
(lambda log.compiled [files ?verbose]
  "prints compiled message for arr:'files'."
  (if (or (disable? ?verbose) (= 0 (# files)))
      (lua :return))
  (vim.cmd :redraw)
  (print-array files "COMPILED:"))

(lambda log.compiled-buffer [?verbose]
  (if (disable? ?verbose)
      (lua :return))
  (let [bufname (vim.fn.expand :%)
        qt "\""]
       (vim.cmd :redraw)
       (print (.. qt bufname qt " compiled" ))))


;; -------------------- ;;
;;     Cleaned Msgs     ;;
;; -------------------- ;;
(lambda log.cleaned [files ?verbose]
  "prints cleaned message for arr:'files'."
  (if (or (disable? ?verbose) (= 0 (# files)))
      (lua :return))
  (print-array files "CLEANED:"))


;; -------------------- ;;
;;      Eval Msgs       ;;
;; -------------------- ;;
(lambda serialize [tbl]
  "pretty print lua table in fennel form."
  (local out (-> (vim.inspect tbl)
                 ; escape single quotes
                 (string.gsub "= +'([^']+)'" #(.. "\"" (string.gsub $1 "\"" "\\\"") "\""))
                 ; remove "," and "= "
                 (string.gsub "," "")
                 (string.gsub "= " "")
                 ; convert ["key"] to key
                 (string.gsub "(\n -)%[\"(.-)\"%]" "%1%2")
                 ; append ":" in front of keys
                 (string.gsub "(\n -)[^<%w]([%w_-])" "%1 :%2")
                 ; convert {1, 2} to [1 2]
                 (string.gsub "(\n -)%{( .- )%}" "%1[%2]")
                 (string.gsub "^%{( .- )%}$" "[%1]")))
  out)

(set log.serialize serialize)

(fn log.value [val]
  (var out nil)
  (if (= val nil)
      (lua :return)
      (= :table (type val))
      (set out (.. ":return " (serialize val)))
      :else
      (set out (.. ":return " (vim.inspect val))))
  (if (env.get :eval :float)
      (log.infloat out :fennel)
      :else
      (print out)))

:return log
