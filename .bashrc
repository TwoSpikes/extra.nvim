#!/bin/env bash

export EDITOR='nvim'

export MAKE_PROGRAM='make'
export RUST_COMPILER='cargo'

export PKG_MANAGER='pkg'
export GIT_PROGRAM='git'
export WGET_PROGRAM='wget'
export GREP_PROGRAM='grep'

export CD_PROGRAM='cd'
export ECHO_PROGRAM='echo'
export ALIAS_PROGRAM='alias'
export SOURCE_PROGRAM='.'
export CLEAR_PROGRAM='clear'

export DISPLAY=':1'

MAX_INSTALL_ATTEMPT=5
MAX_WGET_INSTALL_ATTEMPT=5
DEFAULT_INSTALL_COMMAND='install'

# colors
RESET_COLOR='\033[0m'
GRAY_COLOR='\033[90m'
RED_COLOR='\033[91m'
GREEN_COLOR='\033[92m'
YELLOW_COLOR='\033[93m'
BLUE_COLOR='\033[94m'
VIOLET_COLOR='\033[95m'
LIGHT_BLUE_COLOR='\033[96m'
WHITE_COLOR='\033[97m'
GRAY_BACK_COLOR='\033[100m'
RED_BACK_COLOR='\033[101m'
GREEN_BACK_COLOR='\033[102m'
YELLOW_BACK_COLOR='\033[103m'
BLUE_BACK_COLOR='\033[104m'
VIOLET_BACK_COLOR='\033[105m'
LIGHT_BLUE_BACK_COLOR='\033[106m'
WHITE_BACK_COLOR='\033[107m'

al() { "${ALIAS_PROGRAM}"; }
q() {
	exitcode=${1}
	actual_exitcode=''
	if [[ -z ${exitcode} ]]; then
		actual_exitcode=0
	else
		actual_exitcode=${exitcode}
	fi
	exit ${actual_exitcode}
}
ald() { ${EDITOR} ~/.bashrc; }
_f() { "${CD_PROGRAM}" ~/fplus; }
_fe() { .f; ${EDITOR} ./main.rs; }
_fr() { ~/.fr.sh ${@:1}; }
_fE() {
    "${CLEAR_PROGRAM}"
	${RUST_COMPILER} build --release &> temp_file
	errorcode=${?}
	${GREP_PROGRAM} "\-->" temp_file
	rm temp_file
	"${ECHO_PROGRAM}" ".fE was finished with exit code ${errorcode}"
}
_df_c() {
    "${CLEAR_PROGRAM}"
	"${CD_PROGRAM}" ~/dotfiles
	cp ~/.bashrc ~/.fr.sh ~/tsch.sh ~/xterm-color-table.vim ~/.oh-my-bash-bashrc ${PREFIX}/share/nvim/runtime/colors/blueorange.vim $PREFIX/share/nvim/runtime/syntax/book.vim ~/.oh-my-bash/custom/themes/tstheme/tstheme.theme.sh ~/dotfiles/
    cp ~/dotfiles/blueorange.vim ${PREFIX}/share/vim/vim90/colors/
    cp ~/dotfiles/book.vim ${PREFIX}/share/vim/vim90/syntax/
    cp ~/.config/nvim/init.vim ~/dotfiles/.config/nvim/
    cp -r ~/.config/nvim/lua/ ~/dotfiles/.config/nvim/lua/
	${GIT_PROGRAM} commit --all --verbose
}
_tsns_c() {
    "${CLEAR_PROGRAM}"
    "${CD_PROGRAM}" ~/tsns
    cp ${PREFIX}/share/nvim/runtime/syntax/googol.vim ~/tsns/editor/
	${GIT_PROGRAM} commit --all --verbose
}
exp() { "${EDITOR}" ./; }
hxp() { "${EDITOR}" ~/; }

if [[ -f $PREFIX/etc/motd ]]; then
	rm $PREFIX/etc/motd
fi

esc=$(printf '\033')

option() {
	text=$1
	character=$2
	actual_text=$("${ECHO_PROGRAM}" "${text}" | sed "s/${character}/${esc}[1m&${esc}[22m/";)
set_number_color
	"${ECHO_PROGRAM}" -e "${NUMBER_COLOR}${iota}${RESET}. ${actual_text}"
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

RESET="\033[0m"

"${SOURCE_PROGRAM}" ~/tsch.sh

try_install() {
	program=${1}
	case ${2} in
		'')
			bad_errorcode=127
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
		${installer} ${install_command} ${program}
		errorcode=${?}
		case ${errorcode} in
			${bad_errorcode})
				case ${attempt} in
					1)
						"${ECHO_PROGRAM}" "trying to install ${program} again..."
					;;
					*)
						"${ECHO_PROGRAM}" "wtf? I am trying to install ${program} for ${attempt} time"
					;;
				esac
			;;
			*)
				return 0
			;;
		esac
		$(attempt+=1)
	done
	return -1
}

if [[ ${0##*/} == 'bash' ]]; then
	if [[ ! -f ~/shell/completion.bash ]]; then
		"${ECHO_PROGRAM}" -e "${YELLOW_COLOR}completion.bash file was not found${RESET_COLOR}"
		"${WGET_PROGRAM}" https://github.com/junegunn/fzf/raw/master/shell/completion.bash
		errorcode=${?}
		case ${errorcode} in
			127)
				errorcode=`try_install wget 100 MAX_WGET_INSTALL_ATTEMPT`
				case ${errorcode} in
					0)
						wget https://github.com/junegunn/fzf/raw/master/shell/completion.bash
					;;
					*)
						"${ECHO_PROGRAM}" 'we cannot install wget (we tried)'
						exit -1
					;;
				esac
			;;
			*)
			;;
		esac
	fi
	if [[ ! -f ~/shell/key-bindings.bash ]]; then
		"${ECHO_PROGRAM}" -e "${YELLOW_COLOR}key-bindings.bash file was not found${RESET_COLOR}"
		wget https://github.com/junegunn/fzf/raw/master/shell/key-bindings.bash
	fi
	if [[ ! -f ~/shell/completion.bash ]] || [[ ! -f ~/shell/key-bindings.bash ]]; then
		mv ~/completion.bash ~/key-bindings.bash ~/shell/
		errorcode=${?}
		case ${errorcode} in
			127)
				mkdir shell
				mv ~/completion.bash ~/key-bindings.bash ~/shell/
			;;
			*)
			;;
		esac
	fi

	source ~/.fzf.bash
	source ~/.oh-my-bash-bashrc
	source $OSH/oh-my-bash.sh
fi

if [[ ! -f ~/spacevim-install.sh ]]; then
	curl -sLf https://spacevim.org/install.sh > ~/spacevim-install.sh
fi

if [[ -f ~/todo ]]; then
	if [[ `cat ~/todo` -eq '' ]]; then
		"${ECHO_PROGRAM}" -e "${YELLOW_COLOR}todo is empty${RESET_COLOR}"
	else
		"${ECHO_PROGRAM}" -e "${GREEN_COLOR}todo file:${RESET_COLOR}"
		cat todo
	fi
else
	"${ECHO_PROGRAM}" -e "${RED_COLOR}todo file does not exist${RESET_COLOR}"
fi

export SSPYPL_PATH=~/sspypl
