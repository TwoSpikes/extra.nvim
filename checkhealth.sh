#!/bin/env bash

if [[ $TIMER_INCLUDED == '' ]]; then
	export TIMER_INCLUDED=true
	. ~/timer.sh
fi

function checkhealth() {
	timer_start 'checking needed staff...'

	if [[ ${0##*/} == 'bash' ]]; then
		if [[ ! -f ~/shell/completion.bash ]]; then
			"${ECHO_PROGRAM}" -e "${YELLOW_COLOR}completion.bash file was not found${RESET_COLOR}"
			"${WGET_PROGRAM}" https://github.com/junegunn/fzf/raw/master/shell/completion.bash
			errorcode=${?}
			case ${errorcode} in
				127)
					errorcode=`try_install "${WGET_PROGRAM}" 100 MAX_WGET_INSTALL_ATTEMPT`
					case ${errorcode} in
						0)
							"${WGET_PROGRAM}" https://github.com/junegunn/fzf/raw/master/shell/completion.bash
						;;
						*)
							"${ECHO_PROGRAM}" "we cannot install ${WGET_PROGRAM} (we tried)"
							"${EXIT_PROGRAM}" -1
						;;
					esac
				;;
				*)
				;;
			esac
		fi
		if [[ ! -f ~/shell/key-bindings.bash ]]; then
			"${ECHO_PROGRAM}" -e "${YELLOW_COLOR}key-bindings.bash file was not found${RESET_COLOR}"
			"${WGET_PROGRAM}" https://github.com/junegunn/fzf/raw/master/shell/key-bindings.bash
		fi
		if [[ ! -f ~/shell/completion.bash ]] || [[ ! -f ~/shell/key-bindings.bash ]]; then
			"${MV_PROGRAM}" ~/completion.bash ~/key-bindings.bash ~/shell/
			errorcode=${?}
			case ${errorcode} in
				127)
					"${MKDIR_PROGRAM}" shell
					"${MV_PROGRAM}" ~/completion.bash ~/key-bindings.bash ~/shell/
				;;
				*)
				;;
			esac
		fi
	fi

	if [[ ! -f ~/spacevim-install.sh ]]; then
		"${CURL_PROGRAM}" -sLf https://spacevim.org/install.sh > ~/spacevim-install.sh
	fi

	timer_end
}
