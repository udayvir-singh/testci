# fennel.fnl
> Configures fennel and provides functions to load fennel bins.

**DEPENDS:**
```
fennel[*]
utils[env]
```

**EXPORTS**
```fennel
:fennel Error detected while processing command line:
E5108: Error executing lua .../tangerine/start/tangerine.nvim/lua/tangerine/fennel.lua:34: module 'tangerine.fennel.latest' not found:
	no field package.preload['tangerine.fennel.latest']
	no file './tangerine/fennel/latest.lua'
	no file '/usr/share/luajit-2.1.0-beta3/tangerine/fennel/latest.lua'
	no file '/usr/local/share/lua/5.1/tangerine/fennel/latest.lua'
	no file '/usr/local/share/lua/5.1/tangerine/fennel/latest/init.lua'
	no file '/usr/share/lua/5.1/tangerine/fennel/latest.lua'
	no file '/usr/share/lua/5.1/tangerine/fennel/latest/init.lua'
	no file '/usr/share/lua/common/tangerine/fennel/latest.lua'
	no file '/usr/share/lua/common/tangerine/fennel/latest/init.lua'
	no file './tangerine/fennel/latest.so'
	no file '/usr/local/lib/lua/5.1/tangerine/fennel/latest.so'
	no file '/usr/lib/lua/5.1/tangerine/fennel/latest.so'
	no file '/usr/local/lib/lua/5.1/loadall.so'
	no file './tangerine.so'
	no file '/usr/local/lib/lua/5.1/tangerine.so'
	no file '/usr/lib/lua/5.1/tangerine.so'
	no file '/usr/local/lib/lua/5.1/loadall.so'
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

