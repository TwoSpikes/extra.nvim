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

noremap <leader>ev :tabe ~/.nvimrc<CR>
noremap <leader>bv :e ~/.nvimrc<CR>
noremap <leader>hv :split ~/.nvimrc<CR>
noremap <leader>vv :vsplit ~/.nvimrc<CR>
noremap <leader>sv :source ~/.nvimrc<CR>

echom 'config: ok'
