#!/bin/env bash

export HISTSIZE=5000
export DISPLAY=":0"

export XDG_CONFIG_HOME="$HOME/.config/"

[[ -z "${PREFIX}" ]] && export PREFIX="/usr/"

source ~/funcname.sh
source ~/timer.sh
source ~/checkhealth.sh

timer_start 'loading variables...'

export EDITOR='nvim'

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
export ALIAS_PROGRAM='alias'
export SOURCE_PROGRAM='.'
export CLEAR_PROGRAM='clear'
export WHICH_PROGRAM='which'

MAX_INSTALL_ATTEMPT=2
MAX_WGET_INSTALL_ATTEMPT=2
DEFAULT_INSTALL_COMMAND='install'
DEFAULT_SEARCH_COMMAND='search'

esc=$(printf '\033')

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

timer_end

timer_start 'loading functions...'

al() { "${ALIAS_PROGRAM}"; }
q() {
	exitcode=${1}
	actual_exitcode=''
	if [[ -z ${exitcode} ]]; then
		actual_exitcode=0
	else
		actual_exitcode=${exitcode}
	fi
	"${EXIT_PROGRAM}" ${actual_exitcode}
}
ald() { ${EDITOR} ~/.bashrc; }
_f() { "${CD_PROGRAM}" ~/fplus; }
_fe() { .f; ${EDITOR} ./main.rs; }
_fr() { ~/.fr.sh ${@:1}; }
_fE() {
    "${CLEAR_PROGRAM}"
	"${RUST_BUILD_RELEASE_COMMAND}" &> temp_file
	errorcode=${?}
	"${GREP_PROGRAM}" "\-->" temp_file
	"${RM_PROGRAM}" temp_file
	"${ECHO_PROGRAM}" "_fE was finished with exit code ${errorcode}"
}
_df_c() {
    "${CLEAR_PROGRAM}"
	"${CD_PROGRAM}" ~/dotfiles/
# Bashrc script and its dependencies
	"${CP_PROGRAM}" ~/.bashrc ~/timer.sh ~/checkhealth.sh ~/.fr.sh ~/tsch.sh ~/inverting.sh ~/funcname.sh ~/dotfiles/
## Vim/NeoVim configs
    "${CP_PROGRAM}" ~/.config/nvim/init.vim ~/dotfiles/.config/nvim/
    "${CP_PROGRAM}" -r ~/.config/nvim/lua/ ~/dotfiles/.config/nvim/
## Vim/NeoVim themes
    "${CP_PROGRAM}" ${PREFIX}/share/nvim/runtime/colors/book.vim ~/dotfiles/
    "${CP_PROGRAM}" ${PREFIX}/share/nvim/runtime/colors/blueorange.vim ~/dotfiles/
## Vim/NeoVim scripts
	"${CP_PROGRAM}" ~/xterm-color-table.vim ~/dotfiles/
## Tmux
	"${CP_PROGRAM}" ~/.tmux.conf ~/dotfiles/
	# "${CP_PROGRAM}" -r ~/.tmux/ ~/dotfiles/
## Git
	"${CP_PROGRAM}" ~/.gitconfig-default ~/.gitmessage ~/dotfiles/
## Termux
	"${CP_PROGRAM}" ~/.termux/colors.properties ~/dotfiles/.termux/
# Commit
	"${GIT_PROGRAM}" commit --all --verbose
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
	"${ECHO_PROGRAM}" -e "${NUMBER_COLOR}${iota}${RESET_COLOR}. ${actual_text}"
	((iota++))
}
on_pause() {
	"${ECHO_PROGRAM}" -en "${GRAY_COLOR}[on pause (code: ${YELLOW_COLOR}${?}${GRAY_COLOR}, press ${BOLD_COLOR}${WHITE_COLOR}RETURN${NON_BOLD_COLOR}${GRAY_COLOR})]${RESET_COLOR}: "
}

set_number_color() {
	# 1 + because both \033[30m and \033[40m are black and we do not need black because our terminal background is black
	foreground_color=$((1 + $RANDOM%9))
	background_color=$(($RANDOM%9))
	if [[ ${background_color} == ${foreground_color} ]]; then
		case ${background_color} in
		'8')
			background_color=0
		;;
		*)
			background_color=$((${foreground_color}+1))
		;;
		esac
	fi
	NUMBER_COLOR="\033[0;9${foreground_color};4${background_color}m"
}

"${SOURCE_PROGRAM}" ~/tsch.sh

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
	while [[ ${attempt} -lt ${max_attempt} ]]; do
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

timer_end

timer_total_time

print_todo() {
	if [[ -f ~/todo ]]; then
		if [[ $("${CAT_PROGRAM}" ~/todo) == '' ]]; then
			"${ECHO_PROGRAM}" -e "$(base_program): ${RED_COLOR}error${RESET_COLOR}: ${YELLOW_COLOR}todo is empty${RESET_COLOR}"
		else
			"${ECHO_PROGRAM}" -e "$(base_program): note: ${GREEN_COLOR}todo file:${RESET_COLOR}"
			"${CAT_PROGRAM}" ~/todo
		fi
	else
		"${ECHO_PROGRAM}" -e "$(basename ${0}): ${RED_COLOR}error${RESET_COLOR}: ${RED_COLOR}todo file does not exist${RESET_COLOR}"
	fi
}
if [[ $BASHRC_ALREADY_LOADED == '' ]]; then
	print_todo
fi

# vim:ts=4:sw=4
# TODO: fdm=expr:fde=getline(v\:lnum)=~'^timer_start'?'1'\:getline(v\:lnum)=~'^timer_end$'?'1'\:'0'
