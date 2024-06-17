#!/bin/env sh

! test -z "${INCLUDED_FUNCNAME}" && return 0 || INCLUDED_FUNCNAME=true

if ! test -z ${ZSH_VERSION}; then
	func_name() {
		echo "${funcstack[@]:1:1}"
	}
	program_name() {
		echo "${ZSH_ARGZERO}"
	}
elif test ! -z ${BASH_VERSION}; then
	func_name() {
		echo "${FUNCNAME[1]}"
	}
	program_name() {
		echo "${0}"
	}
else
	func_name() {
		echo "unknown"
	}
	program_name() {
		echo "${0}"
	}
fi
base_program() {
	echo "$(basename $(program_name))"
}
