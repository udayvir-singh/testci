# clean.fnl
> Provides functions to clean stale lua files in build dirs.

**DEPENDS:**
```
output[logger]
utils[diff]
utils[env]
utils[fs]
utils[path]
```

**EXPORTS**
```clojure
:clean {
  :orphaned <function 1>
  :target <function 2>
}
```

# compile.fnl
> Provides functions to diff/compile fennel code.

**DEPENDS:**
```
fennel
output[err]
output[log]
utils[diff]
utils[env]
utils[fs]
utils[path]
```

**EXPORTS**
```clojure
:compile {
  :all <function 1>
  :buffer <function 2>
  :dir <function 3>
  :file <function 4>
  :rtp <function 5>
  :string <function 6>
  :vimrc <function 7>
}
```

# eval.fnl
> Provides functions for interactive fennel evaluation.

**DEPENDS:**
```
fennel
output[display]
output[error]
utils[fs]
utils[path]
```

**EXPORTS**
```clojure
:eval {
  :buffer <function 1>
  :file <function 2>
  :peak <function 3>
  :string <function 4>
}
```

