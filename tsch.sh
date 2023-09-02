#!/bin/env bash

function tsch_fplus_run() {
	if [[ -f ~/fplus ]]; then
		cd ~/fplus
	else
		echo -n "No fplus directory, create it? (y/N/<Ctrl+C>): "
		read answer
		case "${answer}" in
			'y'|'Y'|'yes'|'Yes'|'YES')
				mkdir ~/fplus
				;;
			*)
				echo "Aborted"
				;;
		esac
	fi
	FPLUS_FLAGS=''
	echo 'flags:'
set_number_color
	echo -e "${NUMBER_COLOR}0${RESET}. --sim-debug"
set_number_color
	echo -e "${NUMBER_COLOR}1${RESET}. --parse-debug"
set_number_color
	echo -e "${NUMBER_COLOR}2${RESET}. --sim-debug --parse-debug"
set_number_color
	echo -e "${NUMBER_COLOR}3${RESET}. --only-link --link-debug"
set_number_color
	echo -e "${NUMBER_COLOR}c${RESET}. reload colors"
set_number_color
	echo -e "${NUMBER_COLOR}x${RESET}. back to menu"
	echo -e "\033[91mEnter${RESET}. [no flags]"
	read input_fplus_flags
	case ${input_fplus_flags} in
	'0')
		FPLUS_FLAGS='--sim-debug'
	;;
	'1')
		FPLUS_FLAGS='--parse-debug'
	;;
	'2')
		FPLUS_FLAGS='--sim-debug --parse-debug'
	;;
	'3')
		FPLUS_FLAGS='--only-link --link-debug'
	;;
	'c')
		clear
		tsch_fplus_run
		return
	;;
	'x')
		return
	;;
	*)
		FPLUS_FLAGS=''
	;;
	esac
	clear
	.fr --no-ls sim ./examples/pointers.tspl ${FPLUS_FLAGS}
	on_pause
	read
	clear
	tsch_fplus_run
}

function tsch() {
	clear
set_number_color
		echo 'TwoSpikes ChooseHub (2023-2023)'
		iota=0
		option 'fplus edit' 'f'
		option 'fplus run' 'r'
		option 'text editor edit' 'e'
		option 'text editor run' 't'
		option 'upgrade packages' 'u'
		option 'upgrade && exit' 'x'
		option 'edit todo' 'd'
set_number_color
		echo -e "${NUMBER_COLOR}7${RESET}. edit b\033[1ma\033[22mshrc"
set_number_color
		echo -e "${NUMBER_COLOR}8${RESET}. edit n\033[1mv\033[22mimrc"
set_number_color
		echo -e "${NUMBER_COLOR}9${RESET}. reload \033[1mc\033[22molors"
set_number_color
		echo -e "${NUMBER_COLOR}10${RESET}. ca\033[1ml\033[22m"
set_number_color
		echo -e "${NUMBER_COLOR}11${RESET}. cal -\033[1my\033[22m"
set_number_color
		echo -e "${NUMBER_COLOR}12${RESET}. \033[1mw\033[22meb edit"
		echo -e "\033[91mEnter${RESET}. another"
	read answer
	clear
	case ${answer} in
	'0'|'f')
		cd ~/fplus
		${EDITOR} ./main.rs
	;;
	'1'|'r')
		tsch_fplus_run
	;;
	'2'|'e')
		cd ~/te
		${EDITOR} ./main.c
	;;
	'3'|'t')
		default_file='lol'
		echo -en "On what file? (default='${default_file}'): "
		read file
		case "${file}" in
		'')
			actual_file="${default_file}"
		;;
		*)
			actual_file="${file}"
		;;
		esac

		cd ~/te

		"${MAKE_PROGRAM}" install
		errorcode="${?}"
		on_pause
		read

		if [[ "${errorcode}" == 0 ]]; then
			tste "${actual_file}"
			echo ''
			on_pause
		fi
		read
	;;
	'4'|'p')
		"${PKG_MANAGER}" upgrade
	;;
	'5'|'x')
		"${PKG_MANAGER}" upgrade
		exit 0
	;;
	'6'|'d')
		"${EDITOR}" ~/todo
	;;
	'7'|'a')
		ald
		echo "wanna load ~/${BASHRC_NAME}?"
set_number_color
		echo -e "${NUMBER_COLOR}0${RESET}. No, back to menu"
set_number_color
		echo -e "${NUMBER_COLOR}1${RESET}. Yes, restart"
set_number_color
		echo -e "${NUMBER_COLOR}2${RESET}. no, Exit from start menu"
		read answer2
		case ${answer2,,} in
		'0'|'n')
			
		;;
		'1'|'y'|'r')
			exit 0
		;;
		'2'|'e')
			to_exit='true'
		;;
		esac
	;;
	'8'|'v')
		"${EDITOR}" "${HOME}"/"${NVIMRC_NAME}"
	;;
	'9'|'c')
	;;
	'10'|'l')
		cal
		read
	;;
	'11'|'y')
		cal -y
		read
	;;
	'12'|'w')
		cd ~/web
		${EDITOR} -o ./index.html ./style.css ./main.js
	;;
	*)
		to_exit='true'
	;;
	esac
	if [[ $to_exit != 'true' ]]; then
		tsch
	else
		clear
	fi
}
