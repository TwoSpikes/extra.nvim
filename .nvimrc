set nu
set rnu

let mapleader = ","

noremap - dd
noremap + yyp

noremap <c-d> dd
inoremap <c-d> <esc>ddi

noremap <c-u> bveUe<space>
inoremap <c-u> <esc>bveUe<space>i

noremap l <space>
noremap h <bs>
noremap <right> <space>
noremap <left> <bs>

noremap <leader>v :tabe ~/.nvimrc<CR>
noremap <leader>V :vsplit ~/.nvimrc<CR>

echom 'config: ok'
