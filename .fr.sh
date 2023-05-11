#!/bin/env bash

set -e;

cd ~/fplus;
clear;

errorcode=$?;
start_from=1;

no_ls='';
clear_after_build='';

if [[ $1 == --no-ls ]] || [[ $2 == --no-ls ]]; then
	let "start_from+=1";
	no_ls=true;
fi

if [[ $1 == --clear-after-build ]] || [[ $2 == --clear-after-build ]]; then
	let "start_from+=1";
	clear_after_build=true;
fi

cargo build --release;
if [[ $clear_after_build ]]; then
	clear;
fi

install target/release/fplus $PREFIX/bin/;

if [[ $no_ls != true ]]; then
	ls -la ~/fplus/target/release/;
fi

if [[ $errorcode == 0 ]] then
	fplus ${@:$start_from};
fi
