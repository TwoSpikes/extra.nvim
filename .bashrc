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

function set_orange() {
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
	ORANGE="\033[0;9${foreground_color};4${background_color}m";
}

RESET="\033[0m";

function ask_action() {
	clear;
set_orange;
		echo 'then where?';
set_orange;
		echo -e "${ORANGE}0${RESET}. fplus edit";
set_orange;
		echo -e "${ORANGE}1${RESET}. fplus run";
set_orange;
		echo -e "${ORANGE}2${RESET}. text editor edit";
set_orange;
		echo -e "${ORANGE}3${RESET}. text editor run";
set_orange;
		echo -e "${ORANGE}4${RESET}. pkg upgrade";
set_orange;
		echo -e "${ORANGE}5${RESET}. pkg upgrade && exit";
set_orange;
		echo -e "${ORANGE}6${RESET}. edit todo";
set_orange;
		echo -e "${ORANGE}7${RESET}. ald";
set_orange;
		echo -e "${ORANGE}Enter${RESET}. another";
	read answer;
	clear;
	case ${answer} in
	'0'|'f'|'fe'|'fE'|'.fe'|'.fE'|'edit')
		cd ~/fplus;
		${EDITOR} ./main.rs;
	;;
	'1'|'r'|'fr'|'fR'|'.fr'|'.fR'|'run'|'зап'|'F+r'|'fplusr'|'f+r'|'frun')
		cd ~/fplus;
		.fr --no-ls sim ./examples/pointers.tspl;
	;;
	'2'|'ee'|'E'|'.e'|'.E'|'.ee'|'.eE'|'.Ee'|'.EE')
		cd ~/te;
		${EDITOR} ./main.c;
	;;
	'3'|'er'|'R'|'.r'|'.R'|'.er'|'.re'|'.eR'|'.rE'|'.Er'|'.Re'|'.RE')
		cd ~/te;
		make&&tste;
	;;
	'4'|'p'|'P'|'pkg'|'pkG'|'pKg'|'pKG'|'Pkg'|'PkG'|'PKg'|'PKG')
		pkg upgrade;
	;;
	'5'|'pe'|'.pe'|'ep'|'.ep')
		pkg upgrade;
		exit 0;
	;;
	'6'|'t'|'todo'|'et'|'.et'|'eT'|'.eT'|'Et'|'.Et'|'ET'|'.ET')
		${EDITOR} ~/todo;
	;;
	'7'|'a'|'A'|'.a'|'.A'|'ald'|'.ald'|'ALD'|'.ALD')
		ald;
		echo 'wanna load ~/.bashrc?';
set_orange;
		echo -e "${ORANGE}0${RESET}. No, back to menu";
set_orange;
		echo -e "${ORANGE}1${RESET}. Yes, restart";
set_orange;
		echo -e "${ORANGE}2${RESET}. no, Exit from menu";
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
	*)
		to_exit='true';
	;;
	esac;
	if [[ $to_exit != 'true' ]]; then
		ask_action;
	else
		clear;
	fi;
};

ask_action;
