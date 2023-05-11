set nu
set rnu

let mapleader = ","

noremap - dd
noremap + yyp

noremap <c-d> dd
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

noremap <leader>vet :tabe ~/.nvimrc<CR>
noremap <leader>veb :e ~/.nvimrc<CR>
noremap <leader>veh :split ~/.nvimrc<CR>
noremap <leader>vev :vsplit ~/.nvimrc<CR>
noremap <leader>vs :source ~/.nvimrc<CR>

noremap ; :
noremap = :tabe 
noremap _ :e 

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

noremap q <esc>:wq<CR>
noremap Q <esc>:q!<CR>
noremap W <esc>:w<CR>

inoremap jk <esc>

noremap : <nop>
inoremap <esc> <nop>
nnoremap dd <nop>

autocmd!
" this file is about 2300 lines of code so i do not want to see line numbers
autocmd BufRead main.rs :set nonu nornu
autocmd InsertLeave * :write

echom 'config: loaded'
