#!/bin/env bash

function timer_start() {
	TIMER_START_MESSAGE="${1}"
	echo -n "${TIMER_START_MESSAGE}"
	START=$(date +%s%N)
}
function timer_end() {
	END=$(date +%s%N)
	TOOK=$(((END - START) / 1000000))
	echo " (took ${TOOK} ms)"
	export ALL_TIME=$((ALL_TIME + TOOK))
}
