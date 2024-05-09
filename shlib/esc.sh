#!/bin/env sh

[ ! -z "${INCLUDED_ESC}" ] && return 0 || INCLUDED_ESC=true

esc=$(printf '\033')
