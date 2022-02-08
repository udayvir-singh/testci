#!/usr/bin/env bash

source $(dirname $0)/../utils/core.sh
source $(dirname $0)/../utils/table.sh

GIT_HEAD=""
TITLE="FILE"
DIR=""
EXT=""
BLANK="^ *$"

declare -A regex

# utils
error () {
	local  MSG="${1}"; shift 1
	local ARGS="${@}"

	printf "loc: ${MSG}\n" ${ARGS} >&2
	exit 1
}

## OPTS
while [ -n "${1}" ]; do
	[[ -z "${2}" || "${2}" =~ "--" ]] && error 'missing value for %s' "${1}"

	case "${1}" in
	--comment) regex[Comment]="${2}"; shift 2 ;;
	--docs)    regex[Docs]="${2}";    shift 2 ;;
	--head)    GIT_HEAD="${2}"; shift 2 ;;
	--title)   TITLE="${2}"; shift 2 ;;
	--dir)     DIR="${2}"; shift 2 ;;
	--ext)     EXT="${2}"; shift 2 ;;
	*)         error 'invalid option "%s"' "${1}" ;;
	esac
done

[ -z "${DIR}" ] && error "missing required argument DIR"
[ -z "${EXT}" ] && error "missing required argument EXT"

if [ -n "${GIT_HEAD}" ]; then
	DIFF_CMD="show --format= "
else
	DIFF_CMD="diff"
fi

## MAIN
lines () {
	local FILE="${1}"

	wc -l < "${FILE}"
}

count () {
	local FILE="${1}"
	local REGEX="${2}"

	egrep -c "${REGEX}" < "${FILE}"
}

changes () {
	local FILE="${1}"
	local DIFF="$(git ${DIFF_CMD} --numstat ${GIT_HEAD} "${FILE}")"

	[ -z "${DIFF}" ] && DIFF="0 0"

	printf "${DIFF}" | awk '{
		changes=($1 - $2)

		if (changes == 0) changes=""

		if (changes ~ "^[1-9]") changes=("+" changes)

		printf "%s", changes
	}'
}

main () {
	declare -A TOTAL=()

	for key in Lines Blank ${!regex[*]}; do
		TOTAL[$key]=0
	done

	DRAW_HEADER ${TITLE} Code ${!regex[*]} Blank SUBTOTAL

	local  FILES="$(list_files "${DIR}" "${EXT}")"
	local NFILES="$(wc -l <<< "${FILES}")"

	for FILE in ${FILES}; do
		Lines=$(lines $FILE) 
		Blank=$(count $FILE "$BLANK")
		Code=$(( Lines - Blank ))

		if [ -n "${regex[Comment]}" ]; then
			Comment=$(count $FILE "${regex[Comment]}")

			let Code-=$Comment
			let TOTAL[Comment]+=$Comment
		fi

		if [ -n "${regex[Docs]}" ]; then
			Docs=$(count $FILE "${regex[Docs]}")

			let Code-=$Docs
			let TOTAL[Docs]+=$Docs
		fi

		let TOTAL[Blank]+=$Blank
		let TOTAL[Lines]+=$Lines
		let TOTAL[Code]+=$Code

		Changes=$(changes $FILE)
		Lines=$(printf "%-4s%4s" $Lines $Changes)

		COLS=(${FILE#$DIR/} $Code $Docs $Comment $Blank)

		if [ "${NFILES}" -gt 1 ]; then
			DRAW_ROW ${COLS[*]} "$Lines"
		else
			DRAW_FOOTER ${COLS[*]} | tail -n +2
		fi
	done

	if [ "${NFILES}" -gt 1 ]; then
		DRAW_FOOTER TOTAL: ${TOTAL[Code]} ${TOTAL[Docs]} ${TOTAL[Comment]} ${TOTAL[Blank]} ${TOTAL[Lines]}
	fi
}

eval main
