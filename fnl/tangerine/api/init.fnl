; DEPENDS:
; :return api[*]
; :return utils[path]
; :return utils[logger]
; :return utils[window]
(local prefix "tangerine.")

;; -------------------- ;;
;;         Utils        ;;
;; -------------------- ;;
(lambda lazy [module func]
  "lazy require 'module' and call 'func' from it."
  (fn [...]
      ((-> (require (.. prefix module)) 
           (. func)) ...)))


;; -------------------- ;;
;;         API          ;;
;; -------------------- ;;
:return
{
  :eval {
    :string (lazy :api.eval "string")
    :file   (lazy :api.eval "file")
    :buffer (lazy :api.eval "buffer")
    :peak   (lazy :api.eval "peak")
  }
  :compile {
    :string (lazy :api.compile "string")
    :file   (lazy :api.compile "file")
    :dir    (lazy :api.compile "dir")
    :buffer (lazy :api.compile "buffer")
    :vimrc  (lazy :api.compile "vimrc")
    :rtp    (lazy :api.compile "rtp")
    :all    (lazy :api.compile "all")
  }
  :clean {
    :target   (lazy :api.clean "target")
    :orphaned (lazy :api.clean "orphaned")
  }
  :win {
    :next    (lazy :utils.window "next")
    :prev    (lazy :utils.window "prev")
    :close   (lazy :utils.window "close")
    :resize  (lazy :utils.window "resize")
    :killall (lazy :utils.window "killall")
  }
  :goto_output (lazy :utils.path "goto-output")
  :serialize   (lazy :utils.logger "serialize")
}
