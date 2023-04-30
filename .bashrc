export EDITOR='nvim';
export JOURNAL='~/.journal';

alias al='alias';
al q='exit 0 ';
al ald='$EDITOR $HOME/.bashrc';
al .f='cd ~/fplus';
al .fe='.f;$EDITOR main.rs';
al .fr='~/.fr.sh';
al .fE='clear;cargo build --release &> .lol;errorcode=$?;grep "\-->" .lol;rm .lol;echo $errorcode';
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

function tsch() {
	clear;
set_number_color;
		echo 'TwoSpikes ChooseHub';
set_number_color;
		echo -e "${NUMBER_COLOR}0${RESET}. Fplus edit";
set_number_color;
		echo -e "${NUMBER_COLOR}1${RESET}. fplus Run";
set_number_color;
		echo -e "${NUMBER_COLOR}2${RESET}. text editor Edit";
set_number_color;
		echo -e "${NUMBER_COLOR}3${RESET}. Text editor run";
set_number_color;
		echo -e "${NUMBER_COLOR}4${RESET}. pkg Upgrade";
set_number_color;
		echo -e "${NUMBER_COLOR}5${RESET}. pkg upgrade && eXit";
set_number_color;
		echo -e "${NUMBER_COLOR}6${RESET}. edit toDo";
set_number_color;
		echo -e "${NUMBER_COLOR}7${RESET}. Ald";
set_number_color;
		echo -e "${NUMBER_COLOR}8${RESET}. reload Colors";
		echo -e "\033[91mEnter${RESET}. another";
	read answer;
	clear;
	case ${answer} in
	'0'|'f'|'F')
		cd ~/fplus;
		${EDITOR} ./main.rs;
	;;
	'1'|'r'|'R')
		cd ~/fplus;
		.fr --no-ls sim ./examples/pointers.tspl;
	;;
	'2'|'e'|'E')
		cd ~/te;
		${EDITOR} ./main.c;
	;;
	'3'|'t'|'T')
		cd ~/te;
		make&&tste;
		echo -n "[On pause (code: $?, press ENTER)]: ";
		read;
	;;
	'4'|'p'|'P')
		pkg upgrade;
	;;
	'5'|'x'|'X')
		pkg upgrade;
		exit 0;
	;;
	'6'|'d'|'D')
		${EDITOR} ~/todo;
	;;
	'7'|'a'|'A')
		ald;
		echo 'wanna load ~/.bashrc?';
set_number_color;
		echo -e "${NUMBER_COLOR}0${RESET}. No, back to menu";
set_number_color;
		echo -e "${NUMBER_COLOR}1${RESET}. Yes, restart";
set_number_color;
		echo -e "${NUMBER_COLOR}2${RESET}. no, Exit from menu";
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
	'8'|'c'|'C')
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
