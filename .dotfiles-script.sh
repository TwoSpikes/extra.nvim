#!/bin/env sh
dotfiles init
alias nvim='nvim -c "let g:DO_NOT_OPEN_ANYTHING=0" -c "let g:PAGER_MODE=0" $@'
alias q="exit"
md(){ test $# -eq 1 && mkdir -p -- "$1" && cd -- "$1"; }
nd(){ test $# -eq 1 && mkdir -p -- "$1" && cd -- "$1" && nvim ./; }
