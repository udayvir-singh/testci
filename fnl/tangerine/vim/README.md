# cmds.fnl
> [none]

**DEPENDS:**
```
_G.tangerine.api
```

**EXPORTS**
```fennel
:cmds [ true ]
```

# hooks.fnl
> [none]

**DEPENDS:**
```
_G.tangerine.api
utils[env]
```

**EXPORTS**
```fennel
:hooks {
  :onit <function 1>
  :onload <function 2>
  :onsave <function 3>
  :run <function 4>
}
```

# maps.fnl
> [none]

**DEPENDS:**
```
utils[env]
vim[cmds]
```

**EXPORTS**
```fennel
:maps [ true ]
```

