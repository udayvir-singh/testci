# clean.fnl
> Functions to clean stale lua files in target dirs.

**DEPENDS:**
```
output[logger]
utils[diff]
utils[env]
utils[fs]
utils[path]
```

**EXPORTS**
```fennel
:clean Error detected while processing command line:
E5108: Error executing lua ...rine/start/tangerine.nvim/lua/tangerine/output/error.lua:30: attempt to index field 'diagnostic' (a nil value)
```

# compile.fnl
> Functions to diff compile fennel files.

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
```fennel
:compile Error detected while processing command line:
E5108: Error executing lua ...rine/start/tangerine.nvim/lua/tangerine/output/error.lua:30: attempt to index field 'diagnostic' (a nil value)
```

# eval.fnl
> Functions for interactive fennel evaluation.

**DEPENDS:**
```
fennel
output[display]
output[error]
utils[fs]
utils[path]
```

**EXPORTS**
```fennel
:eval Error detected while processing command line:
E5108: Error executing lua ...rine/start/tangerine.nvim/lua/tangerine/output/error.lua:30: attempt to index field 'diagnostic' (a nil value)
```

