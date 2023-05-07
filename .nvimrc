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

noremap <leader>vet :tabe ~/.nvimrc<CR>
noremap <leader>veb :e ~/.nvimrc<CR>
noremap <leader>veh :split ~/.nvimrc<CR>
noremap <leader>vev :vsplit ~/.nvimrc<CR>
noremap <leader>vs :source ~/.nvimrc<CR>

noremap ; :
noremap = :tabe 
noremap _ :e 

echom 'config: ok'
