#!/bin/env bash

[[ ! -z "${INCLUDED_FUNCNAME}" ]] && return 0 || INCLUDED_FUNCNAME=true

if [[ -n $BASH_VERSION ]]; then
	func_name() {
		echo "${FUNCNAME[1]}"
	}
	program_name() {
		echo "${0}"
	}
else
	func_name() {
		echo "${funcstack[@]:1:1}"
	}
	program_name() {
		echo "${ZSH_ARGZERO}"
	}
fi
base_program() {
	echo "$(basename $(program_name))"
}
