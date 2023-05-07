export EDITOR='nvim';
export JOURNAL='~/.journal';
export PKG_MANAGER='pkg';
export BASHRC_NAME='.bashrc';
export NVIMRC_NAME='.nvimrc';
export MAKE_PROGRAM='make';
export RUST_COMPILER='cargo';
export GREP_PROGRAM='grep';

alias al='alias';
alias q='exit 0';
alias ald='${EDITOR} ${HOME}/${BASHRC_NAME}';
alias .f='cd ~/fplus';
alias .fe='.f;${EDITOR} main.rs';
alias .fr='~/.fr.sh';
alias .fE='clear;${RUST_COMPILER} build --release &> .lol;errorcode=$?;${GREP_PROGRAM} "\-->" .lol;rm .lol;echo $errorcode';
clear;

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

function tsch_fplus_run() {
	cd ~/fplus;
	FPLUS_FLAGS='';
	echo 'flags:';
set_number_color;
	echo -e "${NUMBER_COLOR}0${RESET}. --sim-debug";
set_number_color;
	echo -e "${NUMBER_COLOR}1${RESET}. --parse-debug";
set_number_color;
	echo -e "${NUMBER_COLOR}2${RESET}. --sim-debug --parse-debug";
set_number_color;
	echo -e "${NUMBER_COLOR}3${RESET}. --only-link --link-debug";
	echo -e "${NUMBER_COLOR}c${RESET}. reload colors";
set_number_color;
	echo -e "${NUMBER_COLOR}x${RESET}. back to menu";
	echo -e "\033[91mEnter${RESET}. [no flags]";
	read input_fplus_flags;
	case ${input_fplus_flags} in
	'0')
		FPLUS_FLAGS='--sim-debug';
	;;
	'1')
		FPLUS_FLAGS='--parse-debug';
	;;
	'2')
		FPLUS_FLAGS='--sim-debug --parse-debug';
	;;
	'3')
		FPLUS_FLAGS='--only-link --link-debug';
	;;
	'c')
		clear;
		tsch_fplus_run;
		return;
	;;
	'x')
		return;
	;;
	*)
		FPLUS_FLAGS='';
	;;
	esac;
	clear;
	.fr --no-ls sim ./examples/pointers.tspl ${FPLUS_FLAGS};
	echo -n "[On pause (code: ${?}, press RETURN)]: ";
	read;
	clear;
	tsch_fplus_run;
}

function tsch() {
	clear;
set_number_color;
		echo 'TwoSpikes ChooseHub (2023-2023)';
set_number_color;
		echo -e "${NUMBER_COLOR}0${RESET}. \033[1mf\033[22mplus edit";
set_number_color;
		echo -e "${NUMBER_COLOR}1${RESET}. fplus \033[1mr\033[22mun";
set_number_color;
		echo -e "${NUMBER_COLOR}2${RESET}. text editor \033[1me\033[22mdit";
set_number_color;
		echo -e "${NUMBER_COLOR}3${RESET}. \033[1mt\033[22mext editor run";
set_number_color;
		echo -e "${NUMBER_COLOR}4${RESET}. ${PKG_MANAGER} \033[1mu\033[22mpgrade";
set_number_color;
		echo -e "${NUMBER_COLOR}5${RESET}. ${PKG_MANAGER} upgrade && e\033[1mx\033[22mit";
set_number_color;
		echo -e "${NUMBER_COLOR}6${RESET}. edit to\033[1md\033[22mo";
set_number_color;
		echo -e "${NUMBER_COLOR}7${RESET}. edit b\033[1ma\033[22mshrc";
set_number_color;
		echo -e "${NUMBER_COLOR}8${RESET}. edit n\033[1mv\033[22imshrc";
set_number_color;
		echo -e "${NUMBER_COLOR}9${RESET}. reload \033[1mc\033[22molors";
set_number_color;
		echo -e "${NUMBER_COLOR}10${RESET}. ca\033[1ml\033[22m";
set_number_color;
		echo -e "${NUMBER_COLOR}11${RESET}. cal -\033[1my\033[22m";
		echo -e "\033[91mEnter${RESET}. another";
	read answer;
	clear;
	case ${answer} in
	'0'|'f'|'F')
		cd ~/fplus;
		${EDITOR} ./main.rs;
	;;
	'1'|'r'|'R')
		tsch_fplus_run;
	;;
	'2'|'e'|'E')
		cd ~/te;
		${EDITOR} ./main.c;
	;;
	'3'|'t'|'T')
		default_file='lol';
		echo -en "On what file? (default='${default_file}'): ";
		read file;
		case "${file}" in
		'')
			actual_file="${default_file}";
		;;
		*)
			actual_file="${file}";
		;;
		esac;

		cd ~/te;

		"${MAKE_PROGRAM}" install;
		errorcode="${?}";
		echo -n "[On pause (code: ${errorcode}, press RETURN)]: ";
		read;

		if [[ "${errorcode}" == 0 ]]; then
			tste "${actual_file}";
			echo '';
			echo -n "[On pause (code: ${?}, press RETURN)]: ";
		fi;
		read;
	;;
	'4'|'p'|'P')
		"${PKG_MANAGER}" upgrade;
	;;
	'5'|'x'|'X')
		"${PKG_MANAGER}" upgrade;
		exit 0;
	;;
	'6'|'d'|'D')
		"${EDITOR}" ~/todo;
	;;
	'7'|'v'|'V')
		"${EDITOR}" "${HOME}"/"${NVIMRC_NAME}";
	;;
	'8'|'a'|'A')
		ald;
		echo "wanna load ~/${BASHRC_NAME}?";
set_number_color;
		echo -e "${NUMBER_COLOR}0${RESET}. No, back to menu";
set_number_color;
		echo -e "${NUMBER_COLOR}1${RESET}. Yes, restart";
set_number_color;
		echo -e "${NUMBER_COLOR}2${RESET}. no, Exit from start menu";
		read answer2;
		case $answer2 in
		'0'|'n'|'N')
			
		;;
		'1'|'y'|'Y'|'r'|'R')
			exit 0;
		;;
		'2'|'e'|'E')
			to_exit='true';
		;;
		esac;
	;;
	'9'|'c'|'C')
	;;
	'10'|'l'|'L')
		cal;
		read;
	;;
	'11'|'y'|'Y')
		cal -y;
		read;
	;;
	*)
		to_exit='true';
	;;
	esac;
	if [[ $to_exit != 'true' ]]; then
		tsch;
	else
		clear;
	fi;
};

tsch;
