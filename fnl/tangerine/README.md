# fennel.fnl
> Configures fennel and provides functions to load fennel bins.

**DEPENDS:**
```
fennel[*]
utils[env]
```

**EXPORTS**
```clojure
:fennel {
  :load <function 1>
  :patch-path <function 2>
}
```

# api/
| MODULE                                   | DESCRIPTION                                                  |
| ---------------------------------------- | ------------------------------------------------------------ |
|     [clean.fnl](./api/clean.fnl)         | Provides functions to clean stale lua files in build dirs.   |
|   [compile.fnl](./api/compile.fnl)       | Provides functions to diff/compile fennel code.              |
|      [eval.fnl](./api/eval.fnl)          | Provides functions for interactive fennel evaluation.        |

# output/
| MODULE                                   | DESCRIPTION                                                  |
| ---------------------------------------- | ------------------------------------------------------------ |
|   [display.fnl](./output/display.fnl)    | [none]                                                       |
|     [error.fnl](./output/error.fnl)      | [none]                                                       |
|    [logger.fnl](./output/logger.fnl)     | [none]                                                       |

# utils/
| MODULE                                   | DESCRIPTION                                                  |
| ---------------------------------------- | ------------------------------------------------------------ |
|      [diff.fnl](./utils/diff.fnl)        | Contains diffing algorithm used by compiler.                 |
|       [env.fnl](./utils/env.fnl)         | Stores environment used by rest of tangerine                 |
|        [fs.fnl](./utils/fs.fnl)          | Basic utils around file system handlers.                     |
|      [path.fnl](./utils/path.fnl)        | Provides path manipulation and indexing functions            |
|    [window.fnl](./utils/window.fnl)      | Contains functions to create and control floating windows.   |

# vim/
| MODULE                                   | DESCRIPTION                                                  |
| ---------------------------------------- | ------------------------------------------------------------ |
|      [cmds.fnl](./vim/cmds.fnl)          | [none]                                                       |
|     [hooks.fnl](./vim/hooks.fnl)         | [none]                                                       |
|      [maps.fnl](./vim/maps.fnl)          | [none]                                                       |

