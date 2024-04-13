#!/bin/env sh

. ~/.shlibs/esc.sh

[ ! -z "${INCLUDED_COLORS}" ] && return 0 || INCLUDED_COLORS=true

# colors
RESET_COLOR="${esc}[0m"
GRAY_COLOR="${esc}[90m"
RED_COLOR="${esc}[91m"
GREEN_COLOR="${esc}[92m"
YELLOW_COLOR="${esc}[93m"
BLUE_COLOR="${esc}[94m"
VIOLET_COLOR="${esc}[95m"
LIGHT_BLUE_COLOR="${esc}[96m"
WHITE_COLOR="${esc}[97m"
GRAY_BACK_COLOR="${esc}[100m"
RED_BACK_COLOR="${esc}[101m"
GREEN_BACK_COLOR="${esc}[102m"
YELLOW_BACK_COLOR="${esc}[103m"
BLUE_BACK_COLOR="${esc}[104m"
VIOLET_BACK_COLOR="${esc}[105m"
LIGHT_BLUE_BACK_COLOR="${esc}[106m"
WHITE_BACK_COLOR="${esc}[107m"
