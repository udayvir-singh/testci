#!/usr/bin/env bash

$(dirname $0)/__init__.sh \
	--title MARKDOWN \
	--comment "^ *#.+" \
	--dir . \
	--ext "*.md" ${@}
