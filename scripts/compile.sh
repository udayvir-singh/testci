#!/usr/bin/env bash

FENNEL_BIN="${1}"
SOURCE_DIR="${2}"

source $(dirname $0)/utils/core.sh

# --------------------- #
#         UTILS         #
# --------------------- #
FLAGS="--globals vim"
LOGFILE="$(mktemp)"

compile () {
	local SOURCE="${1}"
	local TARGET="${2}"

	"${FENNEL_BIN}" ${FLAGS} -c "${SOURCE}" > "${TARGET}" 2> "${LOGFILE}"
}

# --------------------- #
#         MAIN          #
# --------------------- #
:: INITILIZE COMPILING

SOURCES="$(list_files "${SOURCE_DIR}" "*.fnl")"

for SOURCE in ${SOURCES}; do
	NAME="$(sed "s:^fnl/::" <<< "${SOURCE}")"
	TARGET="$(get-target "${SOURCE}")"
	TARGET_DIR="$(dirname "${TARGET}")"

	[ ! -d "${TARGET_DIR}" ] && mkdir -p "${TARGET_DIR}"

	if compile "${SOURCE}" "${TARGET}"; then
		log 2 "${NAME}" 
	else
		log 1 "${NAME}" 
		logcat "${LOGFILE}"
		exit 1
	fi
done

:: DONE
