; ABOUT:
;   Functions to clean stale lua files in target dirs.
;
; DEPENDS:
; (-target)           utils[fs]
; (-target)           utils[env]
; (-target)           utils[diff]
; (-target -orphaned) utils[path]
; (-target -orphaned) output[logger]
(local {
  : p
  : fs
  : df
  : env
} (require :tangerine.utils))

(local { 
  : log
} (require :tangerine.output))

(local clean {})

;; -------------------- ;;
;;         MAIN         ;;
;; -------------------- ;;
(lambda clean.target [target ?opts]
  "checks if lua:'target' is Marked and has a readable fnl:source, 
   if not then it deletes 'target'."
  ;; opts { :force boolean }
  (local opts (or ?opts {}))
  (let [target  (p.resolve target)
        marker? (df.read-marker target)
        source? (fs.readable? (p.source target))
        force?  (env.conf opts [:force])]
    (if (and marker? (or (not source?) force?))
        (fs.remove target)
        :else false)))

(lambda clean.orphaned [?opts]
  "delete orphaned lua:files present in ENV.target dir."
  ;; opts { :verbose boolean :force boolean :float boolean }
  (local opts (or ?opts {}))
  (local logs [])
  (each [_ target (ipairs (p.list-lua-files))]
        (if (clean.target target opts) 
            (table.insert logs (p.shortname target))))
  :logger (log.success "CLEANED" logs opts))

; EXAMPLES:
; (pcall tangerine.api.compile.all {:verbose false}) ;; setup
; (clean-orphaned {:verbose true :force true :float true})


:return clean
