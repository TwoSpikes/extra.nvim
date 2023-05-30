#!/bin/env nvim

let mapleader = ","

colorscheme industry

set hidden
set nonu nornu

noremap - ddk
noremap + myyyp`yj

inoremap <c-d> <esc>ddi

nnoremap <c-u> viwUe<space><esc>
vnoremap <c-u> iwUe<space>
inoremap <c-u> <esc>viwUe<space><esc>i

if !$disable_autowrapping
 noremap l <space>
 noremap h <bs>
 noremap <right> <space>
 noremap <left> <bs>
endif

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
\\n  GLOBAL HELP:
\\n    ,? - Show this help message
\\n  NVIMRC FILE:
\\n    ,vet - Open in a new tab
\\n    ,veb - Open in a new buffer
\\n    ,veh - Open in a new horizontal window (-)
\\n    ,vev - Open in a new vertical window (\|)
\\n    ,vs  - Source it
\\n  EDITING:
\\n    MOVING:
\\n      You can press `l`, `h`, `right` and `left` at the end of the line and it will go to the beginning of the next line (in Normal mode). To disable this feature, run this command in bash:
 \\n        /--------------------------\\
\\n        \| $ disable_autowrapping=1 \|
\\n        \\--------------------------/
\\n    FAST COMMANDS:
\\n      ; - Switch to command mode (:)
\\n      = - Open file in a new tab (:tabe)
\\n      _ - Open file in a new buffer (:e)
\\n      ! - Run environment command
\\n    QUOTES AROUND:
\\n      ,\" - Put \'\"\' around word
\\n      ,\' - Put \"\'\" around word
\\n    SPECIAL:
\\n      ci_ - Edit word from start to first _
\\n  TERMINAL:
\\n    ,tt - Open in a new tab
\\n    ,tb - Open in a new buffer
\\n    ,th - Open in a new horizontal window (-)
\\n    ,tv - Open in a new vertical window (\|)
\\n  COLORSCHEME:
\\n    ,cet - Open schemes in a new tab
\\n    ,ceb - Open schemes in a new buffer
\\n    ,ceh - Open schemes in a new horizontal window (-)
\\n    ,cev - Open schemes in a new vertical window (\|)
\\n    ,cs  - Set colorscheme (:colo)
\\n    ,cy  - Copy colorscheme name from current buffer and set it
\\n  TELESCOPE (Plugin):
\\n    ,ff - Find files
\\n    ,fg - Live grep
\\n    ,fb - Buffers
\\n    ,fh - Help tags
\\n  SPECIAL:
\\n    You can replace `,` with other symbol. To do this, run this command in Vim/Neovim:
 \\n        /---------------------------\\
\\n        \| :let mapleader = \"symbol\" \|
\\n        \\---------------------------/
\\n        Where symbol is your symbol (type quotes literally)
\\n  AUTHOR:
\\n    Name: TwoSpikes (2023 - 2023)
\\n    Github: https://github.com/TwoSpikes/dotfiles
\"<CR>

" FAST COMMANDS
noremap ; :
noremap = :tabe 
noremap _ :e 
noremap ! :!

" QUOTES AROUND
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

" SPECIAL
nnoremap ci_ yiwct_

" TERMINAL
noremap <leader>tt :tabnew<CR>:terminal<CR>i
noremap <leader>tb :e<CR>   :terminal<CR>i
noremap <leader>th :split<CR> :terminal<CR>i
noremap <leader>tv :vsplit<CR>:terminal<CR>i

" COLORSCHEME
noremap <leader>cet :tabe $VIMRUNTIME/colors/<CR>
noremap <leader>ceb :e $VIMRUNTIME/colors/<CR>
noremap <leader>ceh :split $VIMRUNTIME/colors/<CR>
noremap <leader>cev :vsplit $VIMRUNTIME/colors/<CR>
noremap <leader>cs :colo 
noremap <leader>cy yiw:colo <c-R>+<CR>

" TELESCOPE
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" vnoremap <c-/> <esc>v:q:s/.*/# \0
" vnoremap <c-?> <esc>:s/.*/\/\/ \0

noremap q <esc>:q<CR>
noremap Q <esc>:q!<CR>
noremap W <esc>:w<CR>
noremap <c-w> <esc>:wq<CR>

inoremap jk <esc>:w<CR>
inoremap jK <esc>

autocmd!

echom 'config: default: loaded'

let s:dein_base = '/data/data/com.termux/files/home/.local/share/dein'
let s:dein_src = '/data/data/com.termux/files/home/.local/share/dein/repos/github.com/Shougo/dein.vim'
execute 'set runtimepath+=' . s:dein_src
call dein#begin(s:dein_base)
call dein#add(s:dein_src)

echom 'config: dein: loaded'

call dein#add('nvim-lua/plenary.nvim')

echom 'config: plenary.nvim: loaded'

call dein#add('nvim-telescope/telescope.nvim', { 'rev': '0.1.1' })

echom 'config: telescope.nvim: loaded'

call dein#end()
if dein#check_install()
	call dein#install()
endif

echom 'config: all: loaded'
