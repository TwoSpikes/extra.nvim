#!/bin/env bash

if [[ $TIMER_INCLUDED == '' ]]; then
	export TIMER_INCLUDED=true
	. ~/timer.sh
fi

function check_for() {
	case "${1}" in
		'')
			echo "No program name was found: exiting..."
			return -1
		;;
		*)
			PROGRAM_NAME="${1}"
		;;
	esac
	case "${2}" in
		'')
			installer=${PKG_MANAGER}
		;;
		*)
			installer="${2}"
		;;
	esac
	case "${3}" in
		'')
			install_command="${DEFAULT_INSTALL_COMMAND}"
		;;
		*)
			install_command="${3}"
		;;
	esac
	case "${4}" in
		'')
			search_command="${DEFAULT_SEARCH_COMMAND}"
		;;
		*)
			search_command="${4}"
		;;
	esac

	"${ECHO_PROGRAM}" -n "Checking for ${PROGRAM_NAME}: "

	"${WHICH_PROGRAM}" "${PROGRAM_NAME}"

	errorcode=${?}
	case "${errorcode}" in
		1)
			try_install "${1}"
			installation_errorcode=${?}
			case ${installation_errorcode} in
				-1)
					"${ECHO_PROGRAM}" -n "Do you wanna search for this package [Y/n]: "
					read package_answer
					case "${package_answer}" in
						''|'y'|'Y'|'yes'|'Yes'|'YES')
							"${installer}" "${search_command}" "${PROGRAM_NAME}"
						;;
						*)
							"${ECHO_PROGRAM}" "Aborting..."
						;;
					esac
					return -1
				;;
				*)
					
				;;	
			esac
		;;
		*)
		;;
	esac
}

function checkhealth() {
	timer_start 'checking needed staff...'
	check_for 'sh'
	timer_end
}
