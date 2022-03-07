# diff.fnl
> Contains diffing algorithm used by compiler.

Works by creating marker that looks like `-- :fennel:<UTC>`,
compares UTC in marker to ftime(source).

**EXPORTS**
```fennel
:diff Error detected while processing command line:
E5108: Error executing lua ...rine/start/tangerine.nvim/lua/tangerine/output/error.lua:30: attempt to index field 'diagnostic' (a nil value)
```

# env.fnl
> Stores environment used by rest of tangerine

Provides getter and setter so that multiple modules can have shared configurations.

**EXPORTS**
```fennel
:env Error detected while processing command line:
E5108: Error executing lua ...rine/start/tangerine.nvim/lua/tangerine/output/error.lua:30: attempt to index field 'diagnostic' (a nil value)
```

# fs.fnl
> Basic utils around file system handlers.

**EXPORTS**
```fennel
:fs Error detected while processing command line:
E5108: Error executing lua ...rine/start/tangerine.nvim/lua/tangerine/output/error.lua:30: attempt to index field 'diagnostic' (a nil value)
```

# path.fnl
> Provides path manipulation and indexing functions

**DEPENDS:**
```
utils[env]
```

**EXPORTS**
```fennel
:path Error detected while processing command line:
E5108: Error executing lua ...rine/start/tangerine.nvim/lua/tangerine/output/error.lua:30: attempt to index field 'diagnostic' (a nil value)
```

# window.fnl
> Contains functions to create and control floating windows.

**DEPENDS:**
```
utils[env]
```

**EXPORTS**
```fennel
:window Error detected while processing command line:
E5108: Error executing lua ...rine/start/tangerine.nvim/lua/tangerine/output/error.lua:30: attempt to index field 'diagnostic' (a nil value)
```

