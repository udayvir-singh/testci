#!/usr/bin/env bash

# ---------------------- #
#         Logger         #
# ---------------------- #
:: () {
	echo ":: $@"
}

log () {
	local COLOR="${1}"
	local CONTENT="$(echo $@ | cut -d' ' -f2-)"

	echo -e "  \e[1;3${COLOR}m ==>\e[0m $CONTENT"
} 

logcat () {
	cat "${1}" | sed "s/^/       /"
}

# ---------------------- #
#         Parser         #
# ---------------------- #
get-target () {
	echo "${1}" | sed "s/fnl/lua/g"
}

shortname () {
	echo ${1} | sed "s:fnl/::"
}

# ---------------------- #
#         Files          #
# ---------------------- #
list_files () {
	local DIR="${1}"
	local EXT="${2}"

	find "${DIR}" -name "${EXT}" -printf "%d %p\n" | LC_ALL=C sort -n | cut -d " " -f 2
}

