#!/bin/env -S nvim -u

let mapleader = " "

set notermguicolors
set background=dark
colorscheme blueorange
set nolazyredraw

set helpheight=25
set splitbelow
set splitkeep=cursor
set nosplitright

set nogdefault
set ignorecase
set incsearch
set magic

set foldclose=all
set foldenable
set foldexpr=0
set foldignore=#
set foldlevel=0
set foldmarker={{{,}}}
set foldmethod=marker
set foldnestmax=15

set nonu
set nornu
function STCAbs()
	let &stc = '%=%{v:relnum?v:relnum:v:lnum} '
endfunction
call STCAbs()
let s:custom_mode = ''
function! Showtab()
	let stl_name = '%t%( %M%R%H%W%)'
	let mode = mode('lololol')
	let strmode = ''
	if mode == 'n'
		let strmode = 'NORM'
	elseif mode == 'no'
		let strmode = 'OP_PEND'
	elseif mode == 'nov'
		let strmode = 'vis OP_PEND'
	elseif mode == 'noV'
		let strmode = 'vis_line OP_PEND'
	elseif mode == 'noCTRL-v'
		let strmode = 'vis_block OP_PEND'
	elseif mode == 'niI'
		let strmode = '^o INS'
	elseif mode == 'niR'
		let strmode = '^o REPL'
	elseif mode == 'niV'
		let strmode = '^o VIRT_REPL'
	elseif mode == 'nt'
		let strmode = 'norm TERM'
	elseif mode == 'ntT'
		let strmode = '^\^o norm TERM'
	elseif mode == 'v'
		let strmode = 'VIS'
	elseif mode == 'V'
		let strmode = 'VIS_LINE'
	elseif mode == 'vs'
		let strmode = '^o vis SEL'
	elseif mode == 'CTRL-V'
		let strmode = 'VIS_BLOCK'
	elseif mode == 'CTRL-Vs'
		let strmode = '^o vis_block SEL'
	elseif mode == 's'
		let strmode = 'SEL '
	elseif mode == 'S'
		let strmode = 'SEL_LINE'
	elseif mode == 'CTRL-S'
		let strmode = 'SEL_BLOCK'
	elseif mode == 'i'
		let strmode = 'INS '
	elseif mode == 'ic'
		let strmode = 'compl INS'
	elseif mode == 'ix'
		let strmode = '^x compl INS'
	elseif mode == 'R'
		let strmode = 'REPL'
	elseif mode == 'Rc'
		let strmode = 'compl REPL'
	elseif mode == 'Rx'
		let strmode = '^x compl REPL'
	elseif mode == 'Rv'
		let strmode = 'vis REPL'
	elseif mode == 'Rvc'
		let strmode = 'compl vis REPL'
	elseif mode == 'Rvx'
		let strmode = '^x compl vis REPL'
	elseif mode == 'c'
		let strmode = 'COM '
	elseif mode == 'cv'
		let strmode = 'EX  '
	elseif mode == 'r'
		let strmode = 'HIT_ENTER'
	elseif mode == 'rm'
		let strmode = 'MORE'
	elseif mode == 'r?'
		let strmode = 'CONFIRM'
	elseif mode == '!'
		let strmode = 'SHELL'
	elseif mode == 't'
		let strmode = 'TERM'
	endif
	let stl_time = '%{strftime("%b,%d %H:%M:%S")}'
	let stl_pos = '%l/%L,%c%V'
	let stl_buf = '#%n %p%%'
	let &stl = stl_name . '%=' . stl_pos . '%=' . stl_time . '%=' . strmode . (s:custom_mode ? ' ' . s:custom_mode : '') . '%=' . stl_buf
endfunction
command! Showtab call Showtab()
call timer_start(500, {-> execute('Showtab')}, {'repeat': -1})
Showtab

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | STCAbs | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | STCRel | endif
augroup END

augroup STC_FILETYPE
	au filetype help setl nonu nornu
	" au terminalopen
augroup END

augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | en

function MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let buf_name = bufname(buflist[winnr - 1])
	return fnamemodify(buf_name, ':~:.')
	" call execute("normal :!echo '" . buf_name . "' > ~/.config/nvim/config_garbagefile.txt")
	" redir! > ~/.config/nvim/config_garbagefile.txt
	" 	silent echo buf_name
	" redir END
endfunction
function MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s ..= '%' .. (i + 1) .. 'T'

    " the label is made by MyTabLabel()
    let s ..= ' %{MyTabLabel(' .. (i + 1) .. ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'

	" let s ..= '%=%#TabLine#%999Xclose'

  return s
endfunction
" set tabline=%!MyTabLine()

set hidden
set wrap
set nolinebreak
let &breakat = "    !¡@*-+;:,./?¿{}[]"
set nolist
set display=lastline
set fcs=lastline:>
set shortmess=filmnrwxsWI
set showtabline=2
set noshowmode

set matchpairs=(:),{:},[:],<:>
set noshowmatch
set matchtime=2
set maxfuncdepth=60
" set maxmapdepth=2
set maxmempattern=500
set history=10000
set modelineexpr

set cursorline
set cursorcolumn
set mouse=a
set nomousefocus
set nomousehide
set mousemodel=popup_setpos
set nomousemoveevent
set mousescroll=ver:3,hor:6
set mouseshape=i:beam,r:beam,s:updown,sd:cross,m:no,ml:up-arrow,v:rightup-arrow
set mousetime=400
set startofline

set tabstop=4
set shiftwidth=4
set smartindent
set smarttab
set noexpandtab

let g:loaded_perl_provider = 0

setlocal nowrap

command! SWrap setl wrap linebreak nolist

if v:version >= 700
  au BufLeave * let b:winview = winsaveview()
  au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif

noremap <silent> - dd
noremap <silent> dd ddk
noremap <silent> + mzyyp`zj
noremap <silent> J mzJ`z

noremap <silent> <expr> j v:count == 0 ? 'gj' : "\<Esc>".v:count.'j' " .'let &stc=&stc'
noremap <silent> <expr> k v:count == 0 ? 'gk' : "\<Esc>".v:count.'k' " .'let &stc=&stc'
noremap <silent> <expr> <down> v:count == 0 ? 'gj' : "\<Esc>".v:count.'j' " .'let &stc=&stc'
noremap <silent> <expr> <up> v:count == 0 ? 'gk' : "\<Esc>".v:count.'k' " .'let &stc=&stc'
noremap <silent> <leader>j j:let &stc=&stc<cr>
noremap <silent> <leader>k k:let &stc=&stc<cr>
noremap <silent> <leader><up> k:let &stc=&stc<cr>
noremap <silent> <leader><down> j:let &stc=&stc<cr>
" noremap <silent> 0 g0
" noremap <silent> $ g$
" noremap <silent> I g0i
" noremap <silent> A g$a

noremap <silent> <c-h> mzggVG`z
noremap <silent> <c-s> <c-a>
noremap <silent> <c-a> :normal g0<cr>
noremap <silent> <c-e> :normal g$<cr>

nnoremap <c-j> viwUe<space><esc>
vnoremap <c-j> iwUe<space>
inoremap <c-j> <esc>viwUe<esc>a

noremap <c-p> :tabp<cr>
noremap <c-n> :tabn<cr>
nnoremap <leader>lC :tabnew<Bar>ter<Bar><cr>a./build.sh
nnoremap <leader>lc :tabnext<Bar><c-\><c-n>:bd!<Bar>tabnew<Bar>ter<cr>a!!<cr>

if !$disable_autowrapping
 noremap l <space>
 noremap h <bs>
 noremap <right> <space>
 noremap <left> <bs>
endif

nnoremap <silent> * *:noh<cr>
nnoremap <silent> <c-*> *
nnoremap <silent> # #:noh<cr>
nnoremap <silent> <c-#> #

noremap <c-l> 20zl
noremap <c-h> 20zh
inoremap <c-l> <esc>20zla
inoremap <c-h> <esc>20zha
let s:SCROLL_UP_FACTOR = 2
let s:SCROLL_DOWN_FACTOR = 3
let s:SCROLL_C_E_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_C_Y_FACTOR = s:SCROLL_DOWN_FACTOR
let s:SCROLL_MOUSE_UP_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_MOUSE_DOWN_FACTOR = s:SCROLL_DOWN_FACTOR
exec printf("noremap <c-e> %s<c-e>", s:SCROLL_C_E_FACTOR)
exec printf("noremap <c-y> %s<c-y>", s:SCROLL_C_Y_FACTOR)
exec printf("noremap <ScrollWheelDown> %s<c-e>", s:SCROLL_MOUSE_DOWN_FACTOR)
exec printf("noremap <ScrollWheelUp> %s<c-y>", s:SCROLL_MOUSE_UP_FACTOR)

" NVIMRC FILE
let s:INIT_FILE_PATH = '~/.config/nvim/init.vim'
let s:PLUGINS_INSTALL_FILE_PATH = '~/.config/nvim/lua/packages/plugins.lua'
let s:PLUGINS_SETUP_FILE_PATH = '~/.config/nvim/lua/packages/plugins_setup.lua'
let s:LSP_PLUGINS_SETUP_FILE_PATH = '~/.config/nvim/lua/packages/lsp/plugins.lua'

exec printf("noremap <silent> <leader>vet <esc>:tabe %s<cr>", s:INIT_FILE_PATH)
exec printf("noremap <silent> <leader>veb <esc>:e %s<cr>", s:INIT_FILE_PATH)
exec printf("noremap <silent> <leader>veh <esc>:sp %s<cr>", s:INIT_FILE_PATH)
exec printf("noremap <silent> <leader>vev <esc>:vsp %s<cr>", s:INIT_FILE_PATH)
exec printf("noremap <silent> <leader>ves <esc>:so %s<cr>", s:INIT_FILE_PATH)

exec printf("noremap <silent> <leader>vit <esc>:tabe %s<cr>", s:PLUGINS_INSTALL_FILE_PATH)
exec printf("noremap <silent> <leader>vib <esc>:e %s<cr>", s:PLUGINS_INSTALL_FILE_PATH)
exec printf("noremap <silent> <leader>vih <esc>:sp %s<cr>", s:PLUGINS_INSTALL_FILE_PATH)
exec printf("noremap <silent> <leader>viv <esc>:vsp %s<cr>", s:PLUGINS_INSTALL_FILE_PATH)
exec printf("noremap <silent> <leader>vis <esc>:so %s<cr>", s:PLUGINS_INSTALL_FILE_PATH)

exec printf("noremap <silent> <leader>vst <esc>:tabe %s<cr>", s:PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>vsb <esc>:e %s<cr>", s:PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>vsh <esc>:sp %s<cr>", s:PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>vsv <esc>:vsp %s<cr>", s:PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>vss <esc>:so %s<cr>", s:PLUGINS_SETUP_FILE_PATH)

exec printf("noremap <silent> <leader>vlt <esc>:tabe %s<cr>", s:LSP_PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>vlb <esc>:e %s<cr>", s:LSP_PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>vlh <esc>:sp %s<cr>", s:LSP_PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>vlv <esc>:vsp %s<cr>", s:LSP_PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>vls <esc>:so %s<cr>", s:LSP_PLUGINS_SETUP_FILE_PATH)

" BASHRC FILE
noremap <silent> <leader>bt <esc>:tabe ~/.bashrc<cr>
noremap <silent> <leader>bb <esc>:e ~/.bashrc<cr>
noremap <silent> <leader>bh <esc>:sp ~/.bashrc<cr>
noremap <silent> <leader>bv <esc>:vsp ~/.bashrc<cr>

" MY .nvimrc HELP
noremap <silent> <leader>? <esc>:echo "
  \MY .nvimrc HELP (warning: help is old):
\\n  GLOBAL HELP:
\\n    \<leader\>? - Show this help message
\\n  NVIMRC FILE:
\\n    \<leader\>vet - Open in a new tab
\\n    \<leader\>veb - Open in a new buffer
\\n    \<leader\>veh - Open in a new horizontal window (-)
\\n    \<leader\>vev - Open in a new vertical window (\|)
\\n    \<leader\>vs  - Source it
\\n  BASHRC FILE:
\\n    \<leader\>bt - Open in a new tab
\\n    \<leader\>bb - Open in a new buffer
\\n    \<leader\>bh - Open in a new horizontal window (-)
\\n    \<leader\>bv - Open in a new vertical window (\|)
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
\\n      \<leader\>\" - Put \'\"\' around word
\\n      \<leader\>\' - Put \"\'\" around word
\\n    SPECIAL:
\\n      ci_ - Edit word from start to first _
\\n      \<leader\>d  - Remove search highlightings
\\n  TERMINAL:
\\n    \<leader\>tt - Open in a new tab
\\n    \<leader\>tb - Open in a new buffer
\\n    \<leader\>th - Open in a new horizontal window (-)
\\n    \<leader\>tv - Open in a new vertical window (\|)
\\n  COLORSCHEME:
\\n    \<leader\>cet - Open schemes in a new tab
\\n    \<leader\>ceb - Open schemes in a new buffer
\\n    \<leader\>ceh - Open schemes in a new horizontal window (-)
\\n    \<leader\>cev - Open schemes in a new vertical window (\|)
\\n    \<leader\>cs  - Set colorscheme (:colo)
\\n    \<leader\>cy  - Copy colorscheme name from current buffer and set it
\\n  TELESCOPE (Plugin):
\\n    \<leader\>ff - Find files
\\n    \<leader\>fg - Live grep
\\n    \<leader\>fb - Buffers
\\n    \<leader\>fh - Help tags
\\n  LSP:
\\n    \<leader\>slv - Start vim-language-server
\\n    \<leader\>slb - Start bash-language-server
\\n    \<leader\>sld - Dump active clients
\\n  SPECIAL:
\\n     By default, \<leader\> is space symbol. You can change it typing this command in Vim/Neovim:
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
noremap <leader>= :tabe 
noremap <leader>- :e 
noremap <leader>1 :!

" QUOTES AROUND
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

" SPECIAL
nnoremap ci_ yiwct_
noremap <silent> <leader>d <esc>:noh<cr>
noremap <c-]> <c-\><esc>

" TERMINAL
noremap <silent> <leader>tt :tabnew<cr>:terminal<cr>i
noremap <silent> <leader>tb :terminal<cr>i
noremap <silent> <leader>th :split<cr> :terminal<cr>i
noremap <silent> <leader>tv :vsplit<cr>:terminal<cr>i
noremap <silent> <leader>tct <c-\><c-n>:q\|tabnew\|ter<cr>a

" COLORSCHEME
noremap <silent> <leader>cet :tabe $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>ceb :e $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>ceh :split $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>cev :vsplit $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>cs :colo 
noremap <silent> <leader>cy yiw:colo <c-r>"<cr>j

augroup cpp
	au filetype cpp noremap <silent> <buffer> <leader>n viwo<esc>i::<esc>hi
	au filetype cpp noremap <silent> <buffer> <leader>/d mz0i//<esc>`zll
	au filetype cpp noremap <silent> <buffer> <leader>/u mz:s:^//<cr>`zhh:noh<cr>
    au filetype cpp noremap <silent> <buffer> <leader>! :e ~/.config/tsvimconf/cpp/example.cpp<cr>ggvGy:bd<cr>pgg
augroup END
augroup syn
	au BufEnter .oh-my-bash-bashrc set filetype=bash
augroup END
augroup vim
	au filetype vim noremap <silent> <buffer> <leader>/d mz0i"<esc>`zl
	au filetype vim noremap <silent> <buffer> <leader>/u mz:s/^"<cr>`zh:noh<cr>
augroup END
augroup googol
	au syntax googol noremap <silent> <buffer> <leader>/d mz0i//<esc>`zll
	au syntax googol noremap <silent> <buffer> <leader>/u mz:s:^//<cr>`zhh:noh<cr>
augroup END

" TELESCOPE
nnoremap <silent> <leader>ff :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fg :lua require'telescope.builtin'.live_grep(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fb :lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fh :lua require'telescope.builtin'.help_tags(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>

" vnoremap <c-/> <esc>v:q:s/.*/# \0
" vnoremap <c-?> <esc>:s/.*/\/\/ \0

" Tab closers
noremap <silent> q <esc>:q<cr>
noremap <silent> Q <esc>:q!<cr>
noremap <silent> <C-w> <esc>:wq<cr>
noremap <silent> <C-W> <C-W>

noremap <leader>q q
noremap <leader>Q Q

inoremap <silent> jk <esc>:w<cr>
inoremap <silent> jK <esc>
inoremap <silent> JK <esc>:w<cr>
inoremap <silent> Jk <esc>
tnoremap <silent> jk <c-\><c-n>
tnoremap <silent> jK <c-\><c-n>:bd!<Bar>tabnew<Bar>ter<cr>a
command! W w

inoremap <silent> jup <c-o>:normal viwUe<cr>

exec printf("luafile %s", s:PLUGINS_INSTALL_FILE_PATH)
PackerInstall
exec printf("luafile %s", s:PLUGINS_SETUP_FILE_PATH)

so ~/xterm-color-table.vim

if has('nvim')
	lua M = {}
	lua servers = { gopls = {}, html = {}, jsonls = {}, pyright = {}, rust_analyzer = {}, sumneko_lua = {}, tsserver = {}, vimls = {}, }
	lua on_attach = function(client, bufnr) vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc") vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()") require("config.lsp.keymaps").setup(client, bufnr) end
	lua opts = { on_attach = on_attach, flags = { debounce_text_changes = 150, }, }
	lua setup = function() require("config.lsp.installer").setup(servers, opts) end
endif

lua table_dump = function(table)
\   if type(table) == 'table' then
\      local s = '{ '
\      for k,v in pairs(table) do
\         if type(k) ~= 'number' then k = '"'..k..'"' end
\         s = s .. '['..k..'] = ' .. table_dump(v) .. ','
\      end
\      return s .. '} '
\   else
\      return tostring(table)
\   end
\ end

noremap <silent> <leader>S :let s:scrolloff = 999 - s:scrolloff<cr>

function! SwapHiGroup(group)
    let id = synIDtrans(hlID(a:group))
    for mode in ['cterm', 'gui']
        for g in ['fg', 'bg']
            exe 'let '. mode.g. "=  synIDattr(id, '".
                        \ g."#', '". mode. "')"
            exe "let ". mode.g. " = empty(". mode.g. ") ? 'NONE' : ". mode.g
        endfor
    endfor
    exec printf('hi %s ctermfg=%s ctermbg=%s guifg=%s guibg=%s', a:group, ctermbg, ctermfg, guibg, guifg)
endfunc

echom 'config: loaded'

" vim:syn=vim:nowrap
