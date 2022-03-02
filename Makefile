FENNEL_BIN  = deps/bin/fennel
SOURCE_DIR  = fnl
INSTALL_DIR = ~/.local/share/nvim/site/pack/tangerine/start/tangerine.nvim

ifndef VERBOSE
.SILENT:
endif

default: help

# ------------------- #
#      BUILDING       #
# ------------------- #
.PHONY: fnl deps
build: deps fnl fnldoc vimdoc

fnl: 
	./scripts/compile.sh "$(FENNEL_BIN)" "$(SOURCE_DIR)"

deps:
	./scripts/link.sh deps/lua lua/tangerine/fennel

fnldoc:
	./scripts/fnldocs.sh fnl/tangerine

vimdoc:
	[ -d doc ] || mkdir doc
	./scripts/docs.sh README.md ./doc/tangerine.txt
	echo :: GENERATING HELPTAGS
	nvim -n --noplugin --headless -c "helptags doc" -c "q" doc/tangerine.txt

clean:
	rm -rf doc/tags doc/tangerine.txt
	echo :: CLEANED VIMDOC
	rm -rf $(shell find fnl -name "README.md")
	echo :: CLEANED FENNEL DOCS
	rm -rf lua/**
	echo :: CLEANED BUILD DIR

install:
	[ -d $(INSTALL_DIR) ] || mkdir -p $(INSTALL_DIR)
	ln -srf lua doc -t $(INSTALL_DIR)
	nvim --headless -c "packadd tangerine" -c "q"
	echo :: FINISHED INSTALLING

uninstall:
	rm -rf $(INSTALL_DIR)
	echo :: UN-INSTALLED TANGERINE
	

# ------------------- #
#         GIT         #
# ------------------- #
LUA_FILES := $(shell find lua -name '*.lua')

--pull:
	git restore doc lua $(shell find fnl -name "README.md")
	echo :: RUNNING GIT PULL
	echo -e  "   \e[1;32m$$\e[0m git pull"
	git pull --rebase | sed 's:^:   :'

git-pull: git-unskip --pull clean build git-skip

git-skip:
	git update-index --skip-worktree $(LUA_FILES)
	git update-index --skip-worktree doc/tangerine.txt

git-unskip:
	git update-index --no-skip-worktree $(LUA_FILES)
	git update-index --no-skip-worktree doc/tangerine.txt


# ------------------- #
#         LOC         #
# ------------------- #
ifdef LOC_HEAD
LOC_ARGS= --head " " $(LOC_HEAD)
endif

loc-fennel:
	./scripts/loc/fennel.sh $(LOC_ARGS)

loc-bash: 
	./scripts/loc/bash.sh $(LOC_ARGS)

loc-markdown: 
	./scripts/loc/markdown.sh $(LOC_ARGS)

loc-makefile: 
	./scripts/loc/makefile.sh $(LOC_ARGS)

loc-yaml: 
	./scripts/loc/yaml.sh $(LOC_ARGS)


# ------------------- #
#        INFO         #
# ------------------- #
help:
	echo 'Usage: make [target] ...'
	echo 
	echo 'Targets:'
	echo '  :fnl            compiles fennel files'
	echo '  :deps           copy required deps in lua folder'
	echo '  :vimdoc         runs panvimdoc to generate vimdocs'
	echo '  :fnldoc         generates module level README'
	echo '  :build          combines :fnl :deps :fnldoc :vimdoc'
	echo '  :install        install tangerine on this system'
	echo '  :clean          deletes build and install dir'
	echo '  :help           print this help.'
	echo 
	echo 'Git helpers:'
	echo '  Hooks for git meant to be used in development,'
	echo '  run :git-skip before running :build to prevent output files in git index'
	echo '  ---'
	echo '  :git-skip       make git ignore build dirs'
	echo '  :git-unskip     reverts git-skip, run :build before executing'
	echo '  :git-pull       clean build dirs before fetching to avoid conflicts'
	echo
	echo 'Lines of Code:'
	echo '  Pretty prints lines of code in source dirs, possible targets are:'
	echo '  ---'
	echo '  :loc-fennel'
	echo '  :loc-bash'
	echo '  :loc-markdown'
	echo '  :loc-makefile'
	echo '  :loc-yaml'
	echo
	echo 'Examples:'
	echo '  make clean build'
	echo '  make install'
	echo '  make loc-fennel'
