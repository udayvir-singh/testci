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
build: deps fnl vimdoc

fnl: 
	./scripts/compile.sh "$(FENNEL_BIN)" "$(SOURCE_DIR)"

deps:
	./scripts/link.sh deps/lua lua/tangerine/fennel

vimdoc:
	[ -d doc ] || mkdir doc
	./scripts/docs.sh README.md ./doc/tangerine.txt
	echo :: GENERATING HELPTAGS
	nvim --noplugin --headless -c "helptags doc" -c "q" doc/tangerine.txt

clean:
	rm -rf doc/tags doc/tangerine.txt
	echo :: CLEANED VIMDOC
	rm -rf lua/**
	echo :: CLEANED BUILD DIR

install:
	[ -d $(INSTALL_DIR) ] || mkdir -p $(INSTALL_DIR)
	ln -srf lua doc -t $(INSTALL_DIR)
	echo :: FINISHED INSTALLING

uninstall:
	rm -rf $(INSTALL_DIR)
	echo :: UN-INSTALLED TANGERINE

# ------------------- #
#         GIT         #
# ------------------- #
LUA_FILES := $(shell find lua -name '*.lua')

--pull:
	echo :: RUNNING GIT PULL
	echo -e  "   \e[1;32m$$\e[0m git pull"
	git pull | sed 's:^:   :'

git-pull: clean --pull build

git-skip:
	git update-index --skip-worktree $(LUA_FILES)
	git update-index --skip-worktree doc/tangerine.txt

git-unskip:
	git update-index --no-skip-worktree $(LUA_FILES)
	git update-index --no-skip-worktree doc/tangerine.txt

# ------------------- #
#        EXTRA        #
# ------------------- #
loc:
	./scripts/loc.sh "$(SOURCE_DIR)"

help:
	echo 'Usage: make [target] ...'
	echo 
	echo 'Targets:'
	echo '  :fnl            compiles fennel files'
	echo '  :deps           copy required deps in lua folder'
	echo '  :vimdoc         runs panvimdoc to generate vimdocs'
	echo '  :build          combines :fnl :deps :vimdoc'
	echo '  :install        install tangerine on this system'
	echo '  :clean          deletes build and install dir'
	echo '  :loc            pretty print lines of code in fennel files'
	echo '  :help           print this help.'
	echo 
	echo 'Git helpers:'
	echo '  git-skip       make git ignore build dirs'
	echo '  git-unskip     reverts git-skip, run :build before executing'
	echo '  git-pull       clean build dirs before fetching to avoid conflicts'
	echo
	echo 'PS: run git-skip before running any targets to prevent output files in git index'
	echo
	echo 'Examples:'
	echo '  make clean build'
	echo '  make install'
	echo '  make loc  [do it]'
