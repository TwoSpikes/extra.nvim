#!/bin/env sh

GOPATH=${GOPATH:="${HOME}/go"}
GOBIN=${GOBIN:="${GOPATH}/bin"}
export PATH="${PATH}:${GOBIN}"

export HISTSIZE=5000
export DISPLAY=":0"
if [ -f "/data/data/com.termux/files/usr/lib/libtermux-exec.so" ]; then
	export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec.so
fi

export XDG_CONFIG_HOME="${HOME}/.config/"

[ -z "${PREFIX}" ] && ( export PREFIX="/usr/" )

JAVA_HOME="${PREFIX}/share/jdk8"

. ~/shlib/funcname.sh
. ~/shlib/timer.sh
. ~/shlib/checkhealth.sh
. ~/shlib/colors.sh

timer_start_silent

export VISUAL="nvim"
export EDITOR='nvim'

if command -v 'most' > /dev/null 2>&1
then
	export PAGER='most'
elif command -v 'less' > /dev/null 2>&1
then
	export PAGER='less'
else
	export PAGER='more'
fi

alias nvim="nvim -c \"let g:DO_NOT_OPEN_ANYTHING=0\" -c \"let g:PAGER_MODE=0\""

export MAKE_PROGRAM='make'
export CMAKE_PROGRAM='make'
export AUTOMAKE_PROGRAM='make'

export RUST_COMPILER='rustc'
export RUST_BUILD_SYSTEM='cargo'
export RUST_BUILD_COMMAND="${RUST_BUILD_SYSTEM} build"
export RUST_BUILD_DEBUG_COMMAND="${RUST_BUILD_COMMAND}"
export RUST_BUILD_RELEASE_COMMAND="${RUST_BUILD_COMMAND} --release"

export PKG_MANAGER='pkg'
export GIT_PROGRAM='git'
export WGET_PROGRAM='wget'
export CURL_PROGRAM='curl'
export GREP_PROGRAM='grep'

export CD_PROGRAM='cd'
export CP_PROGRAM='cp'
export MV_PROGRAM='mv'
export RM_PROGRAM='rm'
export MKDIR_PROGRAM='mkdir'
export CAT_PROGRAM='cat'
export EXIT_PROGRAM='exit'
export ECHO_PROGRAM='echo'
export PRINTF_PROGRAM='printf'
export ALIAS_PROGRAM='alias'
export UNALIAS_PROGRAM='unalias'
export SOURCE_PROGRAM='.'
export CLEAR_PROGRAM='clear'
export WHICH_PROGRAM='type'
if ! command -v "lsd" > /dev/null 2>&1; then
	export LS_PROGRAM='ls'
else
	export LS_PROGRAM='lsd'
fi

md() {
	test $# -eq 1 && mkdir -p -- "$1" && cd -- "$1"
}
if ! test -z "${ZSH_VERSION}"
then
	autoload -Uz compinit
	compinit
	compdef _directories md
fi

nd() {
	test $# -eq 1 && mkdir -p -- "$1" && cd -- "$1" && nvim ./
}
if ! test -z "${ZSH_VERSION}"
then
	autoload -Uz compinit
	compinit
	compdef _directories nd
fi

"${ECHO_PROGRAM}" -n "${esc}[5 q"

MAX_INSTALL_ATTEMPT=2
MAX_WGET_INSTALL_ATTEMPT=2
DEFAULT_INSTALL_COMMAND='install'
DEFAULT_SEARCH_COMMAND='search'

al() { "${ALIAS_PROGRAM}" "${@}"; }
if "${ALIAS_PROGRAM}" ls > /dev/null 2>&1; then
	"${UNALIAS_PROGRAM}" ls
fi
n() { nvim "${@}"; }
ls() { env "${LS_PROGRAM}" "${@}"; }
q() {
	exitcode=${1}
	actual_exitcode=''
	if [ -z ${exitcode} ]; then
		actual_exitcode=0
	else
		actual_exitcode=${exitcode}
	fi
	"${EXIT_PROGRAM}" ${actual_exitcode}
}
eb() { exec bash --noprofile -c "clear"; }
_fE() {
    "${CLEAR_PROGRAM}"
	"${RUST_BUILD_RELEASE_COMMAND}" &> temp_file
	errorcode=${?}
	"${GREP_PROGRAM}" "\-->" temp_file
	"${RM_PROGRAM}" temp_file
	"${ECHO_PROGRAM}" "_fE was finished with exit code ${errorcode}"
}
_tsns_c() {
    "${CLEAR_PROGRAM}"
    "${CD_PROGRAM}" ~/tsns/
    "${CP_PROGRAM}" ${PREFIX}/share/nvim/runtime/syntax/googol.vim ~/tsns/editor/
	"${GIT_PROGRAM}" commit --all --verbose
}

option() {
	text=$1
	character=$2
	actual_text=$("${ECHO_PROGRAM}" "${text}" | sed "s/${character}/${esc}[1m&${esc}[22m/";)
set_number_color
	"${PRINTF_PROGRAM}" "${NUMBER_COLOR}${iota}${RESET_COLOR}. ${actual_text}\n"
	iota=$((iota + 1))
}
on_pause() {
	"${PRINTF_PROGRAM}" "${GRAY_COLOR}[on pause (code: ${YELLOW_COLOR}${?}${GRAY_COLOR}, press ${BOLD_COLOR}${WHITE_COLOR}RETURN${NON_BOLD_COLOR}${GRAY_COLOR})]${RESET_COLOR}: "
}

set_number_color() {
	# + 1 because both \033[30m and \033[40m are black and we do not need black because our terminal background is black
	# foreground_color=$((1 + ${RANDOM} % 9))
	foreground_color=$(shuf -i1-9)
	background_color=$(shuf -i0-8)
	if [ "${background_color}" = "${foreground_color}" ]; then
		case ${background_color} in
			'8')
				background_color=0
			;;
			*)
				background_color=$((background_color + 1))
			;;
		esac
	fi
	NUMBER_COLOR="\033[0;9${foreground_color};4${background_color}m"
}

"${SOURCE_PROGRAM}" ~/shscripts/tsch.sh

try_install() {
	program=${1}
	case ${2} in
		'')
			bad_errorcode=100
		;;
		*)
			bad_errorcode=${2}
		;;
	esac
	case ${3} in
		'')
			max_attempt=${MAX_INSTALL_ATTEMPT}
		;;
		*)
			max_attempt=${3}
		;;
	esac
	case ${4} in
		'')
			installer=${PKG_MANAGER}
		;;
		*)
			installer=${4}
		;;
	esac
	case ${5} in
		'')
			install_command=${DEFAULT_INSTALL_COMMAND}
		;;
		*)
			install_command=${5}
		;;
	esac
	attempt=1
	while test ${attempt} -lt ${max_attempt}; do
		case ${attempt} in
			1)
				"${ECHO_PROGRAM}" "trying to install ${program}..."
			;;
			2)
				"${ECHO_PROGRAM}" "trying to install ${program} again..."
			;;
			*)
				"${ECHO_PROGRAM}" "wtf? I am trying to install ${program} for ${attempt} time"
			;;
		esac
		"${installer}" "${install_command}" "${program}"
		errorcode=${?}
		case ${errorcode} in
			${bad_errorcode})

			;;
			*)
				return 0
			;;
		esac
		let "attempt+=1"
	done
	"${ECHO_PROGRAM}" "i'm done trying to install ${program}"
	return -1
}

timer_end_silent

if ! command -v "stat" > /dev/null 2>&1 \
|| ! command -v "numfmt" > /dev/null 2>&1; then
	timer_total_time "loading time"
else
	space=$(($(stat -f --format="%a*%S" .)))
	space=$(numfmt --to=iec-i --suffix=B --format="%9.2f" ${space})
	timer_total_time "free space: ${YELLOW_COLOR}${space}${RESET_COLOR} loading time"
fi

print_todo() {
	if test -f ~/todo; then
		if [ $("${CAT_PROGRAM}" ~/todo)='' ]; then
			"${PRINTF_PROGRAM}" "$(base_program): ${RED_COLOR}error${RESET_COLOR}: ${YELLOW_COLOR}todo is empty${RESET_COLOR}\n"
		else
			"${PRINTF_PROGRAM}" "$(base_program): note: ${GREEN_COLOR}todo file:${RESET_COLOR}\n"
			"${CAT_PROGRAM}" ~/todo
		fi
	else
		if false; then
			"${PRINTF_PROGRAM}" "$(basename ${0}): ${RED_COLOR}error${RESET_COLOR}: ${RED_COLOR}todo file does not exist${RESET_COLOR}\n"
		fi
	fi
}
if [ $BASHRC_ALREADY_LOADED='' ]; then
	print_todo
fi

# vim:ts=4:sw=4
# TODO: fdm=expr:fde=getline(v\:lnum)=~'^timer_start'?'1'\:getline(v\:lnum)=~'^timer_end$'?'1'\:'0'
