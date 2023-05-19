let mapleader = ","

noremap - dd
noremap + yyp

inoremap <c-d> <esc>ddi

nnoremap <c-u> viwUe<space><esc>
vnoremap <c-u> iwUe<space>
inoremap <c-u> <esc>viwUe<space><esc>i

noremap l <space>
noremap h <bs>
noremap <right> <space>
noremap <left> <bs>

noremap L $
noremap H ^

set nowrap
noremap <C-l> 5zl
noremap <C-h> 5zh
noremap <C-e> 5<C-e>
noremap <C-y> 5<C-y>

noremap <leader>vet <esc>:tabe ~/.nvimrc<CR>
noremap <leader>veb <esc>:e ~/.nvimrc<CR>
noremap <leader>veh <esc>:split ~/.nvimrc<CR>
noremap <leader>vev <esc>:vsplit ~/.nvimrc<CR>
noremap <leader>vs <esc>:source ~/.nvimrc<CR>

noremap ; :
noremap = :tabe 
noremap _ :e 
noremap ! :!

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

nnoremap ci_ yiwct_

vnoremap <c-/> <esc>v:q:s/.*/# \0
vnoremap <c-?> <esc>:s/.*/\/\/ \0

noremap q <esc>:q<CR>
noremap Q <esc>:q!<CR>
noremap W <esc>:w<CR>
noremap <c-w> <esc>:wq<CR>

inoremap jk <esc>

noremap : <nop>
inoremap <esc> <nop>
nnoremap dd <nop>

autocmd!
autocmd InsertLeave * :write

echom 'config: loaded'
