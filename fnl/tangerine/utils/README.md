# diff.fnl
> Contains diffing algorithm used by compiler.

Works by creating marker that looks like `-- :fennel:<UTC>`,
compares UTC in marker to ftime(source).

**EXPORTS**
```fennel
:diff Error detected while processing command line:
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

# env.fnl
> Stores environment used by rest of tangerine

Provides getter and setter so that multiple modules can have shared configurations.

**EXPORTS**
```fennel
:env Error detected while processing command line:
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

# fs.fnl
> Basic utils around file system handlers.

**EXPORTS**
```fennel
:fs Error detected while processing command line:
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

# path.fnl
> Provides path manipulation and indexing functions

**DEPENDS:**
```
utils[env]
```

**EXPORTS**
```fennel
:path Error detected while processing command line:
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

# window.fnl
> Contains functions to create and control floating windows.

**DEPENDS:**
```
utils[env]
```

**EXPORTS**
```fennel
:window Error detected while processing command line:
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

