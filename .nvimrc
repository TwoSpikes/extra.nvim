#!/bin/env nvim

let mapleader = " "

colorscheme lunaperche

set hidden
set nonu nornu

noremap - ddk
noremap + zyyp`zj
noremap J mzJ`z

inoremap <c-d> <esc>ddi

nnoremap <c-u> viwUe<space><esc>
vnoremap <c-u> iwUe<space>
inoremap <c-u> <esc>viwUe<space><esc>i

noremap <c-p> :tabp<cr>
noremap <c-n> :tabn<cr>

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

" NVIMRC FILE
noremap <leader>vet <esc>:tabe ~/.nvimrc<cr>
noremap <leader>veb <esc>:e ~/.nvimrc<cr>
noremap <leader>veh <esc>:sp ~/.nvimrc<cr>
noremap <leader>vev <esc>:vsp ~/.nvimrc<cr>
noremap <leader>vs <esc>:so ~/.nvimrc<cr>

" BASHRC FILE
noremap <leader>bt <esc>:tabe ~/.bashrc<cr>
noremap <leader>bb <esc>:e ~/.bashrc<cr>
noremap <leader>bh <esc>:sp ~/.bashrc<cr>
noremap <leader>bv <esc>:vsp ~/.bashrc<cr>

" MY .nvimrc HELP
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
\\n  BASHRC FILE:
\\n    ,bt - Open in a new tab
\\n    ,bb - Open in a new buffer
\\n    ,bh - Open in a new horizontal window (-)
\\n    ,bv - Open in a new vertical window (\|)
\\n  EDITING:
\\n    MOVING:
\\n      You can press `l`, `h`, `right` and `left` at the end of the line and it will go to the beginning of the next line (in Normal mode). To disable this feature, run this command in bash:
\\n        ╭──────────────────────────╮
\\n        │ $ disable_autowrapping=1 │
\\n        ╰──────────────────────────╯
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
\\n      ,d  - Remove search highlightings
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
\\n       ╭───────────────────────────╮
\\n       │ :let mapleader = \"symbol\" │
\\n       ╰───────────────────────────╯
\\n        Where symbol is your symbol (type quotes literally)
\\n  AUTHOR:
\\n    Name: TwoSpikes (2023 - 2023)
\\n    Github: https://github.com/TwoSpikes/dotfiles
\"<cr>

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
noremap <leader>d <esc>:noh<cr>
noremap <c-]> <c-\><esc>

" TERMINAL
noremap <leader>tt :tabnew<cr>:terminal<cr>i
noremap <leader>tb :e<cr>     :terminal<cr>i
noremap <leader>th :split<cr> :terminal<cr>i
noremap <leader>tv :vsplit<cr>:terminal<cr>i
noremap <leader>tct <c-\><c-n>:q\|tabnew\|ter<cr>a

" COLORSCHEME
noremap <leader>cet :tabe $VIMRUNTIME/colors/<cr>
noremap <leader>ceb :e $VIMRUNTIME/colors/<cr>
noremap <leader>ceh :split $VIMRUNTIME/colors/<cr>
noremap <leader>cev :vsplit $VIMRUNTIME/colors/<cr>
noremap <leader>cs :colo 
noremap <leader>cy yiw:colo <c-R>+<cr>j

" TELESCOPE
nnoremap <leader>ff :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <leader>fg :lua require'telescope.builtin'.live_grep(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <leader>fb :lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <leader>fh :lua require'telescope.builtin'.help_tags(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>

" vnoremap <c-/> <esc>v:q:s/.*/# \0
" vnoremap <c-?> <esc>:s/.*/\/\/ \0

" Tab closers
noremap q <esc>:q<cr>
noremap Q <esc>:q!<cr>
noremap W <esc>:w<cr>
noremap <c-w> <esc>:wq<cr>

inoremap jk <esc>:w<cr>
inoremap jK <esc>
tnoremap jk <c-\><c-n>
tnoremap jK <c-\><c-n>:bd!\|tabnew\|ter<cr>a

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
