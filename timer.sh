#!/bin/env bash

function timer_start() {
	TIMER_START_MESSAGE="${1}"
	echo -n "${TIMER_START_MESSAGE}"
	START=$(date +%s%N)
}
function timer_end() {
	END=$(date +%s%N)
	TOOK=$(((END - START) / 1000000))
	if [[ -f "${PREFIX}"/bin/busybox ]] then
		echo " (took ${TOOK} sec)"
	else
		echo " (took ${TOOK} ms)"
	fi
	export ALL_TIME=$((ALL_TIME + TOOK))
}
