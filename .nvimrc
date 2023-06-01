#!/bin/env nvim

let mapleader = " "

colorscheme lunaperche

set hidden
set nonu nornu

noremap - dd
noremap dd ddk
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
\\n    <leader>? - Show this help message
\\n  NVIMRC FILE:
\\n    <leader>vet - Open in a new tab
\\n    <leader>veb - Open in a new buffer
\\n    <leader>veh - Open in a new horizontal window (-)
\\n    <leader>vev - Open in a new vertical window (\|)
\\n    <leader>vs  - Source it
\\n  BASHRC FILE:
\\n    <leader>bt - Open in a new tab
\\n    <leader>bb - Open in a new buffer
\\n    <leader>bh - Open in a new horizontal window (-)
\\n    <leader>bv - Open in a new vertical window (\|)
\\n  EDITING:
\\n    MOVING:
\\n      You can press `l`, `h`, `right` and `left` at the end of the line and it will go to the beginning of the next line (in Normal mode). To disable this feature, run this command in bash:
\\n      ╭──────────────────────────╮
\\n      │ $ disable_autowrapping=1 │
\\n      ╰──────────────────────────╯
\\n    FAST COMMANDS:
\\n      ; - Switch to command mode (:)
\\n      = - Open file in a new tab (:tabe)
\\n      _ - Open file in a new buffer (:e)
\\n      ! - Run environment command
\\n    QUOTES AROUND:
\\n      <leader>\" - Put \'\"\' around word
\\n      <leader>\' - Put \"\'\" around word
\\n    SPECIAL:
\\n      ci_ - Edit word from start to first _
\\n      <leader>d  - Remove search highlightings
\\n  TERMINAL:
\\n    <leader>tt - Open in a new tab
\\n    <leader>tb - Open in a new buffer
\\n    <leader>th - Open in a new horizontal window (-)
\\n    <leader>tv - Open in a new vertical window (\|)
\\n  COLORSCHEME:
\\n    <leader>cet - Open schemes in a new tab
\\n    <leader>ceb - Open schemes in a new buffer
\\n    <leader>ceh - Open schemes in a new horizontal window (-)
\\n    <leader>cev - Open schemes in a new vertical window (\|)
\\n    <leader>cs  - Set colorscheme (:colo)
\\n    <leader>cy  - Copy colorscheme name from current buffer and set it
\\n  TELESCOPE (Plugin):
\\n    <leader>ff - Find files
\\n    <leader>fg - Live grep
\\n    <leader>fb - Buffers
\\n    <leader>fh - Help tags
\\n  SPECIAL:
\\n     By default, <leader> is space symbol. You can change it typing this command in Vim/Neovim:
\\n     ╭───────────────────────────╮
\\n     │ :let mapleader = \"symbol\" │
\\n     ╰───────────────────────────╯
\\n     Where symbol is your symbol (type quotes literally)
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
noremap <leader>tb :terminal<cr>i
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

let s:dein_base = '/data/data/com.termux/files/home/.local/share/dein'
let s:dein_src = '/data/data/com.termux/files/home/.local/share/dein/repos/github.com/Shougo/dein.vim'
execute 'set runtimepath+=' . s:dein_src
call dein#begin(s:dein_base)
call dein#add(s:dein_src)

call dein#add('nvim-lua/plenary.nvim')

call dein#add('nvim-telescope/telescope.nvim', { 'rev': '0.1.1' })

call dein#end()
if dein#check_install()
	call dein#install()
endif

echom 'config: loaded'
