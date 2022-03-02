#!/usr/bin/env bash

SOURCE_DIR="${1}"

source $(dirname $0)/utils/core.sh

# --------------------- #
#         UTILS         #
# --------------------- #
get-deps () {
	local SOURCE="${1}"

	awk '{
		if ($2 == "DEPENDS:") {
			getline
			block="True"
		}
		else if ($1 != ";") {
			block=Null
		}

		if (block) print $(NF)
	}' < "${SOURCE}"

}

get-about () {
	local SOURCE="${1}"

	awk '{
		if ($2 == "ABOUT:") {
			getline
			block="True"
		}
		else if ($1 != ";" || $2 == "DEPENDS:") {
			block=Null
		}

		if (block) {
			gsub("^; *", "")
			print $0
		}
	}' < "${SOURCE}"

}

get-exports () {
	local SOURCE="${1}"

	nvim -n --noplugin --headless \
	-c "lua require('tangerine.api').eval.file('${SOURCE}', {float=false})" \
	-c "q" 2>&1 | sed "s/^:return //" | col -b
}

gen-markdown () {
	SOURCE="${1}"

	TITLE="$(basename "${SOURCE}")"
	ABOUT="$(get-about "${SOURCE}")"
	DEPENDS="$(get-deps "${SOURCE}")"
	EXPORTS="$(get-exports "${SOURCE}")"

	echo "# ${TITLE}"
	echo "> ${ABOUT}"

	[ -n "${DEPENDS}" ] && printf '
**DEPENDS:**
```
%s
```
' "${DEPENDS}"

	printf '
**EXPORTS**
```fennel
%s
```
\n' "${EXPORTS}"
}


# --------------------- #
#         MAIN          #
# --------------------- #
SUB_DIRS="$(find "${SOURCE_DIR}" -type d)"

:: GENERATING FENNEL DOCS
for DIR in ${SUB_DIRS}; do
	log 2 "$(sed "s:^fnl/::" <<< "${DIR}")"

	for SOURCE in "${DIR}"/*.fnl; do
		if [[ "${SOURCE}" =~ "init.fnl" ]]; then
			continue
		fi
		gen-markdown "${SOURCE}"
	done > "${DIR}/README.md"
done
:: DONE
