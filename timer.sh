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

if [[ $TIMER_ALREADY_LOADED == '' ]]; then
	export ALL_TIME=0
fi

if [[ $TIMER_ALREADY_LOADED == '' ]]; then
	export TIMER_ALREADY_LOADED=true
fi
