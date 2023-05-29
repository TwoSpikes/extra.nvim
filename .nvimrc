#!/bin/env nvim

let mapleader = ","

set hidden
set nonu nornu

noremap - ddk
noremap + myyyp`yj

inoremap <c-d> <esc>ddi

nnoremap <c-u> viwUe<space><esc>
vnoremap <c-u> iwUe<space>
inoremap <c-u> <esc>viwUe<space><esc>i

noremap l <space>
noremap h <bs>
noremap <right> <space>
noremap <left> <bs>

noremap L 50<up>zz
noremap H 50<down>zz

set wrap
noremap <C-l> 20zl
noremap <C-h> 20zh
noremap <C-e> 3<C-e>
noremap <C-y> 4<C-y>

noremap <leader>vet <esc>:tabe ~/.nvimrc<CR>
noremap <leader>veb <esc>:e ~/.nvimrc<CR>
noremap <leader>veh <esc>:split ~/.nvimrc<CR>
noremap <leader>vev <esc>:vsplit ~/.nvimrc<CR>
noremap <leader>vs <esc>:source ~/.nvimrc<CR>
noremap <leader>? <esc>:echo "
\MY .nvimrc HELP:
\\n  GLOBAL_HELP:
\\n    ? - Show this help message
\\n  NVIMRC:
\\n    vet - Open in a new tab
\\n    veb - Open in a new buffer
\\n    veh - Open in a new horizontal window (-)
\\n    vev - Open in a new vertical window (\|)
\\n    vs  - Source it
\\n  TERMINAL:
\\n    tt - Open in a new tab
\\n    tb - Open in a new buffer
\\n    th - Open in a new horizontal window (-)
\\n    tv - Open in a new vertical window (\|)
\\n  AUTHOR:
\\n    Name: TwoSpikes (2023 - 2023)
\\n    Github: https://github.com/TwoSpikes/dotfiles
\"<CR>

noremap ; :
noremap = :tabe 
noremap _ :e 
noremap ! :!

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

noremap <leader>tt :tabnew<CR>:terminal<CR>i
noremap <leader>tb :e<CR>   :terminal<CR>i
noremap <leader>th :split<CR> :terminal<CR>i
noremap <leader>tv :vsplit<CR>:terminal<CR>i

nnoremap ci_ yiwct_

vnoremap <c-/> <esc>v:q:s/.*/# \0
vnoremap <c-?> <esc>:s/.*/\/\/ \0

noremap q <esc>:q<CR>
noremap Q <esc>:q!<CR>
noremap W <esc>:w<CR>
noremap <c-w> <esc>:wq<CR>

inoremap jk <esc>

autocmd!
autocmd InsertLeave * :write

echom 'config: loaded'
