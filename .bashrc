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
	# 1 + because both \033[30m and \033[40m are black and we do not need black
	foreground_color=$((1 + $RANDOM%9));
	background_color=$(($RANDOM%9));
	if [[ ${background_color} == ${foreground_color} ]]; then
		case ${background_color} in
		'8')
			background_color=0
		;;
		*)
			background_color=$((${foreground_color}+1));
		;;
		esac;
	fi;
	ORANGE="\033[0;9${foreground_color};4${background_color}m";
}

RESET="\033[0m";

clear;
set_orange
	echo 'then where?';
set_orange
	echo -e "${ORANGE}0${RESET}. fplus edit";
set_orange
	echo -e "${ORANGE}1${RESET}. fplus run";
set_orange
	echo -e "${ORANGE}2${RESET}. text editor";
set_orange
	echo -e "${ORANGE}3${RESET}. pkg upgrade";
set_orange
	echo -e "${ORANGE}4${RESET}. pkg upgrade && exit";
set_orange
	echo -e "${ORANGE}5${RESET}. edit todo"
set_orange
	echo -e "${ORANGE}Enter${RESET}. another";
read answer;
clear;
case ${answer} in
'0')
	cd ~/fplus;
	${EDITOR} ./main.rs;
;;
'1')
	cd ~/fplus;
	.fr --no-ls sim ./examples/pointers.tspl;
;;
'2')
	cd ~/te;
	${EDITOR} ./main.c;
;;
'3')
	pkg upgrade;
;;
'4')
	pkg upgrade;
	exit 0;
;;
esac;
