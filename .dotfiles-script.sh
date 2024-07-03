#!/bin/env sh
dotfiles init
export PATH=$PATH:$HOME/elixir/bin
alias q="exit"
md(){ test $# -eq 1 && mkdir -p -- "$1" && cd -- "$1"; }
nd(){ test $# -eq 1 && mkdir -p -- "$1" && cd -- "$1" && nvim ./; }
up(){ cd ..; }
if ! test -z "${ZSH_VERSION}"
then
	autoload -U compinit
	compinit
	compdef _directories md
	compdef _directories nd
fi
eb(){ exec bash --noprofile -c "clear"; }

GOPATH=${GOPATH:="${HOME}/go"}
GOBIN=${GOBIN:="${GOPATH}/bin"}
export PATH="${PATH}:${GOBIN}"

export HISTSIZE=5000
export DISPLAY=":0"
if [ -f "/data/data/com.termux/files/usr/lib/libtermux-exec.so" ]; then
	export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec.so
fi

export XDG_CONFIG_HOME="${HOME}/.config/"

[ -z "${PREFIX}" ] && ( export PREFIX="/usr/" )

JAVA_HOME="${PREFIX}/share/jdk8"

export VISUAL="nvim"
export EDITOR='nvim'

if command -v 'most' > /dev/null 2>&1
then
	export PAGER='most'
elif command -v 'less' > /dev/null 2>&1
then
	export PAGER='less'
else
	export PAGER='more'
fi
