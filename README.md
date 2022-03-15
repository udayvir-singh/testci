<!--
-- DEPENDS: FIXME
-- Install     | setup
-- API         | api[*]
-- Command     | vim[cmds]
-- Setup, FAQ  | utils[env]
-- API,   FAQ  | fennel
-- Build       | Makefile
-->

<!-- ignore-start -->
<div align="center">

# :tangerine: Tangerine :tangerine:

![Neovim version](https://img.shields.io/badge/Neovim-0.5-57A143?style=flat-square&logo=neovim)
![GNU Neovim version](https://img.shields.io/badge/Neovim%20In%20Emacs-0.5-dac?style=flat-square&logo=gnuemacs&logoColor=daf)

[About](#introduction) • [Installation](#installation) • [Setup](#setup) • [Commands](#commands) • [API](#api)

<p align="center">
	<img width="700" src="https://raw.githubusercontent.com/udayvir-singh/testci/master/demo/demo.svg">
</p>


</div>
<!-- ignore-end -->

# Introduction
Tangerine provides a painless way to add fennel to your neovim config, without adding to your load times.

It prioritizes speed, transparency and minimalism and It's lightning fast thanks to it diffing algorithm.

## Features
- *BLAZING* fast, compiles files in milliseconds
- 200% support for interactive evaluation 
- Transparent, doesn't create stupid abstractions
- Natively loads `nvim/init.fnl`

## Comparison to other plugins
#### HOTPOT
- Abstracts too much away from user.
- Hooks onto lua package searchers to compile [harder to debug]

#### ANISEED
- Excessively feature rich to be used for dotfiles.
- Blindly compiles all files that it founds, resulting in slow load times.

## Installation
1. create file `plugin/tangerine.lua` in your config dir

2. add these lines to automatically bootstrap tangerine
```lua
-- ~/.config/nvim/plugin/tangerine.lua

-- pick your plugin manager, default [standalone]
local pack = "tangerine" or "packer" or "paq"

local remote = "https://github.com/udayvir-singh/tangerine.nvim"
local tangerine_path = vim.fn.stdpath "data" .. "/site/pack/" .. pack .. "/start/tangerine.nvim"

if vim.fn.empty(vim.fn.glob(tangerine_path)) > 0 then
	print [[tangerine.nvim: installing in data dir... ]]
	vim.fn.system {"git", "clone", remote, tangerine_path}
	vim.cmd [[redraw]]
	print [[tangerine.nvim: finished installing ]]
end
```
3. call setup() function
```lua
-- ~/.config/nvim/plugin/tangerine.lua

local tangerine = require [[tangerine]]

tangerine.setup {}
```

4. invoke `:FnlCompile` to run tangerine manually or add [hooks](#setup) in your config.

5. create `~/.config/nvim/init.fnl`, and let tangerine do its magic.

---
You can use a plugin manager to manage tangerine afterwards.

#### Packer
```fennel
(local packer (require :packer))

(packer.startup (fn []
	(use :udayvir-singh/tangerine.nvim)))
```

#### Paq
```fennel
(local paq (require :paq))

(paq {
	:udayvir-singh/tangerine.nvim
})
```

# Setup
Tangerine comes with sane defaults so that you can get going without having to add much to your config.
#### Default config
```lua
local config = vim.stdpath [[config]]

{
	vimrc   = config .. "/init.fnl",
	source  = config .. "/fnl",
	target  = config .. "/lua",
	rtpdirs = {},

	compiler = {
		float   = true,     -- show output in floating window
		clean   = true,     -- delete stale lua files
		force   = false,    -- disable diffing (not recommended)
		verbose = true,     -- enable messages showing compiled files

		globals = {...},    -- list of alowedGlobals
		version = "latest", -- version of fennel to use, [ latest, 1-0-0, 0-10-0, 0-9-2 ]

		-- hooks for tangerine to compile on:
		-- "onsave" run every time you save fennel file in {source} dir.
		-- "onload" run on VimEnter event
		-- "oninit" run before sourcing init.fnl [recommended than onload]
		hooks   = []
	},

	eval = {
		float  = true,      -- show results in floating window
		luafmt = function() -- function that returns formater for peaked lua
			return {"lua-format"}
		end,

		diagnostic = { 
			virtual = true,  -- show errors in virtual text
			timeout = 10     -- how long should the error persist
		}
	},

	keymaps = {
		eval_buffer = "gE",
		peak_buffer = "gL",
		goto_output = "gO",
		float = {
			next    = "<C-K>",
			prev    = "<C-J>",
			kill    = "<Esc>",
			close   = "<Enter>",
			resizef = "<C-W>=",
			resizeb = "<C-W>-"
		}
	},

	highlight = {
		float   = "Normal",
		success = "String",
		errors  = "DiagnosticError"
	},
}
```

#### Example Config
Here is config that I use in my dotfiles
```lua
{
	-- save fnl output in a separate dir, it gets automatically added to package.path
	target = vim.fn.stdpath [[data]] .. "/tangerine",

	-- compile files in &rtp
	rtpdirs = {
		"plugin",
		"colors",
		"$HOME/mydir" -- absolute paths are also supported
	},

	compiler = {
		-- compile every time changed are made to fennel files or on entering vim
		hooks = ["onsave", "oninit"]
	}
}
```

That's It now get writing your vim config in fennel

# Commands
<!-- doc=:FnlCompileBuffer -->
#### :FnlCompileBuffer
Compiles current active fennel buffer

<!-- doc=:FnlCompile -->
#### :FnlCompile[!]
Diff compiles fennel files in `source` dir to `target` dir

If bang! is present then forcefully compiles all `source` files

<!-- doc=:FnlClean -->
#### :FnlClean[!]
Deletes stale or orphaned lua files in `target` dir

If bang! is present then it deletes all lua files.

<hr>

<!-- doc=:Fnl -->
#### :Fnl {expr}
Executes and Evalutate {expr} of fennel
```fennel
:Fnl (print "Hello World")
  -> Hello World

:Fnl (values some_var)
  -> :return [ 1 2 3 4 ]
```

<!-- doc=:FnlFile -->
#### :FnlFile {file}
Evaluates {file} of fennel and outputs the result

```fennel
:FnlFile path/source.fnl

:FnlFile % ;; not recomended
```

<!-- doc=:FnlBuffer -->
#### :[range]FnlBuffer
Evaluates all lines or [range] in current fennel buffer

> mapped to `gE` by default.

<hr>

<!-- doc=:FnlPeak -->
#### :[range]FnlPeak
Peak lua output for [range] in current fennel buffer

> mapped to `gL` by default.

<!-- doc=:FnlGotoOutput -->
#### :FnlGotoOutput
Open lua output of current fennel buffer in a new buffer

> mapped to `gO` by default.

<hr>

<!-- doc=:FnlWinNext -->
#### :FnlWinNext [N]
Jump to [N]th next floating window created by tangerine

> mapped to `CTRL-K` in floats by default.

<!-- doc=:FnlWinPrev -->
#### :FnlWinPrev [N]
Jump to [N]th previous floating window created by tangerine

> mapped to `CTRL-J` in floats by default.

<!-- doc=:FnlWinResize -->
#### :FnlWinResize [N]
Increase or Decrease floating window height by [N] factor

> mapped to `CTRL-W =` to increase and `CTRL-W -` decrease by default.

<!-- doc=:FnlWinClose -->
#### :FnlWinClose
Closes current floating window under cursor

> mapped to `ENTER` in floats by default.

<!-- doc=:FnlWinKill -->
#### :FnlWinKill
Closes all floating windows made by tangerine

> mapped to `ESC` in floats by default.

# FAQ and Tricks
##### Q: How to make tangerine compile automatically when you open vim
Ans: add hooks in config of `setup()` function:
```lua
-- if you want to compile before loading init.fnl (recommended)
hooks = ["oninit"]

-- if you only want after VimEnter event has fired
hooks = ["onenter"]
```

##### Q: How to tuck away compiled output in a separate directory
Ans: change source in config
```lua
source = "/path/to/your/dir"
```

##### Get underlying fennel used by tangerine
Call `(tangerine.fennel {version})`, see fennel [api](#fennel-api)
```fennel
(tangerine.fennel (or :latest :1-0-0 :0-10-0 :0-9-2))
```

# Api
By default tangerine provides the following api 
```fennel
:Fnl tangerine.api

> :return {
    :compile {
      :all    <function 0>
      :buffer <function 1>
      :dir    <function 2>
      :file   <function 3>
      :rtp    <function 4>
      :string <function 5>
      :vimrc  <function 6>
    }
    :clean {
      :rtp      <function 7>
      :target   <function 8>
      :orphaned <function 9>
    }
    :eval {
      :buffer <function 10>
      :file   <function 11>
      :peak   <function 12>
      :string <function 13>
    }
    :win {
      :next    <function 14>
      :prev    <function 15>
      :close   <function 16>
      :killall <function 17>
      :resize  <function 18>
    }
    :goto_output <function 19>
    :serialize   <function 20>
  }
```

## Compiler Api
This section describes function for `tangerine.api.compile.{func}`

<!-- doc=tangerine.api.compile.string() -->
#### compile-string
<pre lang="fennel"><code> (compile.string {str})
</pre></code>

Compiles string {str} of fennel, returns string of lua

> `[can throw errors]`

<!-- doc=tangerine.api.compile.file() -->
#### compile-file
<pre lang="fennel"><code> (compile.file {source} {target})
</pre></code>

Compiles fennel {source} and writes output to {target}

> `[can throw errors]`

<!-- doc=tangerine.api.compile.dir() -->
#### compile-dir
<pre lang="fennel"><code> (compile-dir {source} {target} {opts})
</pre></code>

Compiles fennel in files {source} dir to {target} dir

{opts} can be of table:
```fennel
{
	:force   <boolean>
	:verbose <boolean>
}
```
If {opts.force} != `true` then it diffs files for compiling

Example:
```fennel
(tangerine.api.compile.dir 
	:path/fnl 
	:path/lua
	{ :force false :verbose true })
```

<!-- doc=tangerine.api.compile.buffer() -->
#### compile-buffer
<pre lang="fennel"><code> (compile-buffer {opts})
</pre></code>

<ul><li>
Compiles current fennel buffer
</li></ul>

opts can be of table:
```fennel
{
	:verbose <boolean>
}
```

<!-- doc=tangerine.api.compile.vimrc() -->
#### compile-vimrc
<pre lang="fennel"><code> (compile-vimrc {opts})
</pre></code>

<ul><li>

Compiles `config.vimrc` to `config.target/tangerine_vimrc.lua`

</li></ul>

opts can be of table:
```fennel
{
	:force   <boolean>
	:verbose <boolean>
}
```
If {opts.force} != `true` then it diffs files for compiling

<!-- doc=tangerine.api.compile.rtp() -->
#### compile-rtp
<pre lang="fennel"><code> (compile.rtp {opts})
</pre></code>

<ul><li>

Compiles fennel files in `config.rtpdirs`.

</li></ul>

opts can be of table:
```fennel
{
	:force   <boolean>
	:verbose <boolean>
	:rtpdirs <list>
}
```
If {opts.force} != `true` then it diffs files for compiling

Example:
```fennel
(tangerine.api.compile.rtp {
	:force false
	:verbose true
	:rtpdirs [
		"colors"
		"plugin"
		"~/somedir"
	]
})
```

<!-- doc=tangerine.api.compile.all() -->
#### compile-all
<pre lang="fennel"><code> (compile.all {opts})
</pre></code>

<ul><li>

Compiles all indexed fennel files in `config` dirs.

</li></ul>

opts can be of table:
```fennel
{
	:force   <boolean>
	:verbose <boolean>
	:rtpdirs <list>
}
```
If {opts.force} != `true` then it diffs files for compiling

## Cleaning Api
Tangerine comes with functions to clean stale lua file in target dir without their fennel parents.

This section describes function for `tangerine.api.clean.{func}`

<!-- doc=tangerine.api.clean.target() -->
#### clean-target
<pre lang="fennel"><code> (clean.target {target} {force})
</pre></code>

<ul><li>
Deletes lua files in {target} dir without their fennel parent
</li></ul>

If {force} == `true`, then it deletes all compiled files

<!-- doc=tangerine.api.clean.orphaned() -->
#### clean-orphaned
<pre lang="fennel"><code> (clean.orphaned {opts})
</pre></code>

<ul><li>

Deletes lua files in `config.target` dir without their fennel parent

</li></ul>

opts can be of table:
```fennel
{
	:force <boolean>
	:verbose <boolean>
}
```
If {opts.force} == `true`, then it deletes all compiled files

## Evaluation Api
This section describes function for `tangerine.api.eval.{func}`

<!-- doc=tangerine.api.eval.string() -->
#### eval-string
<pre lang="fennel"><code> (eval.string {str})
</pre></code>

<ul><li>
Evaluates string {str} of fennel, and prints the output
</li></ul>

Can throw errors

<!-- doc=tangerine.api.eval.file() -->
#### eval-file
<pre lang="fennel"><code> (eval.file {path})
</pre></code>

<ul><li>
Evaluates {path} of fennel, and prints the output
</li></ul>

Can throw errors

<!-- doc=tangerine.api.eval.range() -->
#### eval-range
<pre lang="fennel"><code> (eval.range {start} {end} {count})
</pre></code>

<ul><li>
Evaluates range {start} to {end} in vim buffer 0
</li></ul>

Optionally takes {count}, only meant to be used in command definitions

<!-- doc=tangerine.api.eval.buffer() -->
#### eval-buffer
<pre lang="fennel"><code> (eval.buffer)
</pre></code>

<ul><li>

Evaluates all lines in vim buffer 0,
wrapper around `(eval.range 1 -1)`

</li></ul>

## Utils Api
<!-- doc=tangerine.api.serialize() -->
#### serialize
<pre lang="fennel"><code> (tangerine.api.serialize {object})
</pre></code>

<ul><li>
Return a human-readable representation of given {object}
</li></ul>

Example:
```fennel
(tangerine.api.serialize [1 2 3 4])
-> "[ 1 2 3 4 ]"
```

<!-- doc=tangerine.api.goto_output() -->
#### goto_output
<pre lang="fennel"><code> (tangerine.api.goto_output)
</pre></code>

<ul><li>
Open lua source of current fennel buffer in a new buffer
</li></ul>

<!-- doc=tangerine.fennel() -->
## Fennel Api
Underlying fennel used by tangerine can by accessed by calling `tangerine.fennel`

<pre lang="fennel"><code> (tangerine.fennel {version})
</pre></code>

{version} can be one of [ `latest` `1-0-0` `0-10-0` `0-9-2` ],
default `config.compiler.version`

# Contributing
## Requirements
| Program       | Description                     |
|---------------|---------------------------------|
| [pandoc]()    | for generating vimdoc           |
| [make]()      | for build instructions          |
| [lua]()       | for running fennel (included)   |
| [bash]()      | for running shell scripts       |
| [coreutils]() | required by shell scripts       |

## Building from source
```bash
git clone https://github.com/udayvir-singh/tangerine.nvim
cd tangerine.nvim

make <git-hooks>
make <target>
```
see `make help` or [below](#make-targets) for information on targets.

## Make Targets
| Target     | Description                                |
|------------|--------------------------------------------|
| `:fnl`     | compiles fennel files                      |
| `:deps`    | copy required deps in lua folder           |
| `:vimdoc`  | runs panvimdoc to generate vimdocs         |
| `:build`   | combines `:fnl` `:deps` `:vimdoc`          |
| `:install` | install tangerine on this system           |
| `:clean`   | deletes build and install dir              |

- To build tangerine run:
```bash
$ make clean build
```

- Then to install it:
```bash
$ make install
```

## Git Hooks
| Target       | Description                                                    |
|--------------|----------------------------------------------------------------|
| `git-pull`   | safely fetches git repo, prevents conflicts with local changes |
| `git-skip`   | makes git ignore build dirs, run before `make :build`          |
| `git-unskip` | reverts `git-skip`, run after `make build`                     |

- Example workflow:
```bash
$ make git-skip # first thing that you should be running

# makes changes to tangerine
$ make clean build

# commit changes 
$ git commit -a -m "<msg>"
$ git push

# cleanly fetch from origin
$ make git-pull
```

## LOC Helpers
Tangerine comes with helpers to generate detailed summary about lines of source code

```bash
$ make loc-{language}
```

Supported Languages:
- fennel
- bash / shellscript
- markdown
- makefile
- yaml

Examples:
```bash
$ make loc-fennel

$ make loc-bash
```

# The End
