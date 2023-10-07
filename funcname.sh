#!/bin/env bash

func_name() {
    if [[ -n $BASH_VERSION ]]; then
        echo "${FUNCNAME[1]}"
    else
        echo "${funcstack[@]:1:1}"
    fi
}
