#!/bin/env sh

[ ! -z "${INCLUDED_TIMER}" ] && return 0 || INCLUDED_TIMER=true

. ~/.shlibs/funcname.sh
. ~/.shlibs/colors.sh

to_timer_human_time() {
	INPUT_TIME="${1}"

	if [ -f "${PREFIX}"/bin/busybox ]; then
		echo "${INPUT_TIME} sec"
	fi
	echo "${INPUT_TIME} ms"
}
timer_start() {
	TIMER_START_MESSAGE="${1}"

	# echo -n "$(base_program): $(func_name): note: ${TIMER_START_MESSAGE}"
	echo -n "[INFO] ${TIMER_START_MESSAGE}"
	START=$(date +%s%N)
}
timer_startln() {
	timer_start "${1}"
	echo ""
}
timer_end() {
	END=$(date +%s%N)
	TOOK=$(((END - START) / 1000000))
	HUMAN_TOOK=$(to_timer_human_time ${TOOK})
	printf " (took ${YELLOW_COLOR}${HUMAN_TOOK}${RESET_COLOR})\n"
	export ALL_TIME=$((ALL_TIME + TOOK))
}
timer_endln() {
	END=$(date +%s%N)
	TOOK=$(((END - START) / 1000000))
	HUMAN_TOOK=$(to_timer_human_time ${TOOK})
	printf "[INFO] Took ${YELLOW_COLOR}${HUMAN_TOOK}${RESET_COLOR}\n"
	export ALL_TIME=$((ALL_TIME + TOOK))
}
timer_total_time() {
	# echo "$(base_program): $(func_name): note: ${ALL_TIME} ms"
	printf "[INFO] total time: ${YELLOW_COLOR}${ALL_TIME} ms${RESET_COLOR}\n"
	export ALL_TIME=0
}
