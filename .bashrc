#!/bin/env bash

export EDITOR='nvim';
export JOURNAL='~/.journal';
export PKG_MANAGER='pkg';
export MAKE_PROGRAM='make';
export RUST_COMPILER='cargo';
export GREP_PROGRAM='grep';
export GIT_PROGRAM='git';

export DISPLAY=':1';

BASHRC_NAME='.bashrc';
NVIMRC_NAME='.nvimrc';
FR_SH_NAME='.fr.sh';
TSCH_NAME='tsch.sh';

# colors
RESET_COLOR='\033[0m';
GRAY_COLOR='\033[90m';
RED_COLOR='\033[91m';
GREEN_COLOR='\033[92m';
YELLOW_COLOR='\033[93m';
BLUE_COLOR='\033[94m';
VIOLET_COLOR='\033[95m';
LIGHT_BLUE_COLOR='\033[96m';
WHITE_COLOR='\033[97m';
GRAY_BACK_COLOR='\033[100m';
RED_BACK_COLOR='\033[101m';
GREEN_BACK_COLOR='\033[102m';
YELLOW_BACK_COLOR='\033[103m';
BLUE_BACK_COLOR='\033[104m';
VIOLET_BACK_COLOR='\033[105m';
LIGHT_BLUE_BACK_COLOR='\033[106m';
WHITE_BACK_COLOR='\033[107m';

function al() {
	alias;
}
function q() {
	exitcode=$1;
	actual_exitcode='';
	if [[ -z ${exitcode} ]]; then
		actual_exitcode=0;
	else
		actual_exitcode=${exitcode};
	fi;
	exit ${actual_exitcode};
}
function ald() {
	${EDITOR} ${HOME}/${BASHRC_NAME};
}
function .f() {
	cd ~/fplus;
}
function .fe() {
	.f;
	${EDITOR} ./main.rs;
}
function .fr() {
	~/.fr.sh ${@:1};
}
function .fE() {
	clear;
	${RUST_COMPILER} build --release &> temp_file;
	errorcode=${?};
	${GREP_PROGRAM} "\-->" temp_file;
	rm temp_file;
	echo ".fE was finished with exit code ${errorcode}";
}
function .df-c() {
	clear;
	cd ~/dotfiles;
	cp ~/${BASHRC_NAME} ~/${NVIMRC_NAME} ~/${FR_SH_NAME} ~/${TSCH_NAME} ~/dotfiles;
	${GIT_PROGRAM} commit -a;
}
clear;

esc=$(printf '\033');

function option() {
	text=$1;
	character=$2;
	actual_text=$(echo "${text}" | sed "s/${character}/${esc}[1m&${esc}[22m/";)
set_number_color;
	echo -e "${NUMBER_COLOR}${iota}${RESET}. ${actual_text}";
	((iota++));
}
function on_pause() {
	echo -en "${GRAY_COLOR}[on pause (code: ${YELLOW_COLOR}${?}${GRAY_COLOR}, press ${BOLD_COLOR}${WHITE_COLOR}RETURN${NON_BOLD_COLOR}${GRAY_COLOR})]${RESET_COLOR}: ";
}

function set_number_color() {
	# 1 + because both \033[30m and \033[40m are black and we do not need black because our terminal background is black
	foreground_color=$((1 + $RANDOM%9));
	background_color=$(($RANDOM%9));
	if [[ ${background_color} == ${foreground_color} ]]; then
		case ${background_color} in
		'8')
			background_color=0;
		;;
		*)
			background_color=$((${foreground_color}+1));
		;;
		esac;
	fi;
	NUMBER_COLOR="\033[0;9${foreground_color};4${background_color}m";
}

RESET="\033[0m";

. ~/$TSCH_NAME;

. ${HOME}/.cargo/env;



[ -f ~/.fzf.bash ] && source ~/.fzf.bash
