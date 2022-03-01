;; -------------------- ;;
;;        Utils         ;;
;; -------------------- ;;
(local config-dir (vim.fn.stdpath :config))

(lambda endswith [str args]
  "checks if 'str' endswith one of arr::'args'."
  (each [i v (pairs args)]
        (if (vim.endswith str v)
            (lua "return true"))))

(lambda resolve [path]
  "resolves 'path' to POSIX complaint path."
  (let [out (vim.fn.resolve (vim.fn.expand path))]
       (if (endswith out ["/" ".fnl" ".lua"])
           out
           (.. out "/"))))

(lambda table? [tbl]
  "checks if 'tbl' is a valid table."
  (and (= :table (type tbl))
       (not (vim.tbl_islist tbl))))

(lambda deepcopy [tbl1 tbl2 ?nested]
  "deep copy 'tbl1' onto 'tbl2'."
  (local nested (or ?nested false))
  (each [key val (pairs tbl1)]
        (if (and (vim.tbl_isempty val) (not nested))
            (do :skip) ;; skip empty tables
            (table? val)
            (deepcopy val (. tbl2 key) true)
            :else
            (tset tbl2 key val))))


;; -------------------- ;;
;;        Schema        ;;
;; -------------------- ;;
(local schema {
  :source  "string"
  :target  "string"
  :vimrc   "string"
  :rtpdirs "list"
  :compiler {
    :float   "boolean"
    :clean   "boolean"
    :force   "boolean"
    :verbose "boolean"
    :globals "list"
    :version [:oneof ["latest" "1-0-0" "0-10-0" "0-9-2"]]
    :hooks   [:array ["onsave" "onload" "oninit"]]
  }
  :diagnostic {
    :float   "boolean"
    :virtual "boolean"
    :timeout "number"
  }
  :eval {
    :float "boolean"
  }
  :mapping {
    :PeakBuffer "string"
    :EvalBuffer "string"
    :GotoOutput "string"
    :FloatNext  "string"
    :FloatPrev  "string"
    :FloatKill  "string"
    :FloatClose "string"
  }
  :highlight {
    :float   "string"
    :success "string"
    :errors  "string"
    :virtual "string"
  }
})

(local pre-schema {
  :source resolve
  :target resolve
  :vimrc  resolve
  :rtpdirs nil
  :compiler nil
  :diagnostic nil
  :eval nil
  :mapping nil
  :highlight nil
})

(local ENV {
  :vimrc  (resolve (.. config-dir "/init.fnl"))
  :source (resolve (.. config-dir "/fnl/"))
  :target (resolve (.. config-dir "/lua/"))
  :rtpdirs []
  :compiler {
    :float   true
    :clean   true
    :force   false
    :verbose true
    :globals (vim.tbl_keys _G)
    :version "latest"           
    :hooks   []
  }
  :diagnostic {
    :float   true
    :virtual true
    :timeout 10
  }
  :eval {
    :float true
  }
  :mapping {
    :PeakBuffer "gL"
    :EvalBuffer "gE"
    :GotoOutput "gO"
    :WinPrev    "<C-J>"
    :WinNext    "<C-K>"
    :WinKill    "<Esc>"
    :WinClose   "<Enter>"
  }
  :highlight {
    :float   "TangerineFloat"
    :success "String"
    :errors  "DiagnosticError"
    :virtual "DiagnosticVirtualTextError"
  }
})


;; -------------------- ;;
;;      Validation      ;;
;; -------------------- ;;
(lambda validate-type [name val scm]
  "checks if 'scm' == typeof 'val', else throws an error."
  (fn fail []
    (error 
      (.. "[tangerine]: bad argument in 'setup()' to " name ", " scm " expected got " (type val) ".")))
  (if (= scm :list)
      (or (vim.tbl_islist val) 
          (fail))
      :else
      (or (= (type val) scm)
          (fail))))

(lambda validate-oneof [name val scm]
  "checks if 'val' is member of 'scm', else throws error."
  (validate-type name val :string)
  (when (not (vim.tbl_contains scm val))
        (local tbl (table.concat scm "' '"))
        (error
          (.. "[tangerine]: bad argument in 'setup()' to " name " expected to be one-of ['" tbl "']."))))

(lambda validate-array [name array scm]
  "checks if members of 'array' are present in 'scm'."
  (validate-type name array :table)
  (each [_ val (ipairs array)]
        (validate-oneof name val scm)))

(lambda validate [tbl schema]
  (each [key val (pairs tbl)]
        (local scm (. schema key))
        (if (not (. schema key))
            (error (.. "[tangerine]: invalid key " key)))
        (if 
            (= :string (type scm)) (validate-type  key val scm)
            (= :oneof  (?. scm 1)) (validate-oneof key val (. scm 2))
            (= :array  (?. scm 1)) (validate-array key val (. scm 2))
        ; recursive validation
        (= :table  (type scm))
        (validate val scm))))

(lambda pre-process [tbl schema]
  (each [key val (pairs tbl)]
        (local pre (. schema key))
        (if (= (type pre) :table)
            (pre-process val pre)
            (not= (type pre) :nil)
            (tset tbl key (pre val))))
  tbl)


;; -------------------- ;;
;;        Getters       ;;
;; -------------------- ;;
(lambda rget [tbl args]
  "recursively gets value in 'tbl' from list of args."
  (if (= 0 (# args)) tbl
  :else
  (let [current (?. tbl (. args 1))]
       (table.remove args 1)
       (if current
           (rget current args)))))

(lambda env-get [...]
  "getter for table ENV."
  (rget ENV [...]))

(lambda env-get-config [opts args]
  "getter for 'opts', returns value of last key in 'args' fallbacks to ENV."
  (let [key (. args (# args))]
    (if (not= nil (. opts key))
        (. opts key)
        :else
        (rget ENV args))))


;; -------------------- ;;
;;        Setters       ;;
;; -------------------- ;;
(lambda env-set [tbl]
  "setter for table ENV."
  (validate tbl schema)
  (pre-process tbl pre-schema)
  (deepcopy tbl ENV))


:return {
  :get  env-get
  :set  env-set
  :conf env-get-config
}
