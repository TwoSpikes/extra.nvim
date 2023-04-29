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

RESET="\033[0m";

cat ~/todo;
echo -n 'edit? ';
read todo;

if [[ $todo == y ]]; then
	nvim ~/todo;
else
	clear;
ORANGE="\033[0;3$((0 + $RANDOM%10))m";
	echo 'then where?';
ORANGE="\033[0;3$((0 + $RANDOM%10))m";
	echo -e "${ORANGE}0${RESET}. fplus edit";
ORANGE="\033[0;3$((0 + $RANDOM%10))m";
	echo -e "${ORANGE}1${RESET}. fplus run";
ORANGE="\033[0;3$((0 + $RANDOM%10))m";
	echo -e "${ORANGE}2${RESET}. text editor";
ORANGE="\033[0;3$((0 + $RANDOM%10))m";
	echo -e "${ORANGE}3${RESET}. pkg upgrade";
ORANGE="\033[0;3$((0 + $RANDOM%10))m";
	echo -e "${ORANGE}4${RESET}. pkg upgrade && exit";
ORANGE="\033[0;3$((0 + $RANDOM%10))m";
	echo -e "${ORANGE}Enter${RESET}. another";
	read answer;
	clear;
	case $answer in
	"0")
		cd ~/fplus;
		$EDITOR ./main.rs;
	;;
	"1")
		cd ~/fplus;
		.fr --no-ls sim ./examples/pointers.tspl;
	;;
	"2")
		cd ~/te;
		$EDITOR ./main.c;
	;;
	"3")
		pkg upgrade;
	;;
	"4")
		pkg upgrade;
		exit 0;
	;;
	esac;
fi
