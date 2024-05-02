#!/bin/env -S nvim -u

let mapleader = " "

let g:CONFIG_PATH = "$HOME/.config/nvim"

if $PREFIX == ""
	call setenv('PREFIX', '/usr/')
endif
let g:COLORSCHEME_PATH = "$PREFIX/share/nvim/runtime/colors/blueorange.vim"
set termguicolors
set background=light
exec printf("so %s", g:COLORSCHEME_PATH)
set nolazyredraw
set encoding=utf-8

set helpheight=10
set splitbelow
set splitkeep=cursor
set nosplitright
set scrolloff=3

set nogdefault
set ignorecase
set smartcase
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

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! ReturnHighlightTerm(group, term)
   " Store output of group to variable
   let output = execute('hi ' . a:group)

   " Find the term we're looking for
   return matchstr(output, a:term.'=\zs\S*')
endfunction

function! CopyHighlightGroup(src, dst)
	let ctermfg = ReturnHighlightTerm(a:src, "ctermfg")
	if ctermfg ==# ""
		let ctermfg = "NONE"
	endif
	let ctermbg = ReturnHighlightTerm(a:src, "ctermbg")
	if ctermbg ==# ""
		let ctermbg = "NONE"
	endif
	let cterm = ReturnHighlightTerm(a:src, "cterm")
	if cterm ==# ""
		let cterm = "NONE"
	endif
	let guifg = ReturnHighlightTerm(a:src, "guifg")
	if guifg ==# ""
		let guifg = "NONE"
	endif
	let guibg = ReturnHighlightTerm(a:src, "guibg")
	if guibg ==# ""
		let guibg = "NONE"
	endif
	let gui = ReturnHighlightTerm(a:src, "gui")
	if gui ==# ""
		let gui = "NONE"
	endif
	exec printf("hi %s ctermfg=%s ctermbg=%s cterm=%s guifg=%s guibg=%s gui=%s", a:dst, ctermfg, ctermbg, cterm, guifg, guibg, gui)
endfunction

set nonu
set nornu
function! STCRel()
	if has('nvim')
		if mode() ==? 'v'
			let &l:stc = '%{%v:relnum?"":"%#CursorLineNrVisu#".((v:virtnum <= 0)?v:lnum:"")%}%{%v:relnum?"%#LineNrVisu#%=".((v:virtnum <= 0)?v:lnum:""):""%} '
			call CopyHighlightGroup("StatementVisu", "Statement")
			return
		endif
		let &l:stc = '%#CursorLineNr#%{%v:relnum?"%#LineNr#":((v:virtnum <= 0)?v:lnum:"")%}%=%{v:relnum?((v:virtnum <= 0)?v:relnum:""):""} '
		call CopyHighlightGroup("StatementNorm", "Statement")
		call s:SaveStc(v:false)
	else
		set nu rnu
	endif
endfunction
function! STCAbs(actual_mode)
	if has('nvim')
		if a:actual_mode ==# ''
			let &l:stc = '%{%v:relnum?"":"%#CursorLineNr#".((v:virtnum <= 0)?v:lnum:"")%}%{%v:relnum?"%#LineNr#%=".((v:virtnum <= 0)?v:lnum:""):""%} '
			call CopyHighlightGroup("StatementNorm", "Statement")
			return
		endif
		if a:actual_mode ==# 'r'
			let &l:stc = '%{%v:relnum?"":"%#CursorLineNrRepl#".((v:virtnum <= 0)?v:lnum:"")%}%=%{v:relnum?((v:virtnum <= 0)?v:lnum:""):""} '
			return
		endif
		if mode() ==? 'v' && &modifiable
			let &l:stc = '%{%v:relnum?"":"%#CursorLineNrVisu#".((v:virtnum <= 0)?v:lnum:"")%}%=%{v:relnum?((v:virtnum <= 0)?v:lnum:""):""} '
			return
		endif
		let &l:stc = '%{%v:relnum?"":"%#CursorLineNrIns#".((v:virtnum <= 0)?v:lnum:"")%}%{%v:relnum?"%#LineNrIns#%=".((v:virtnum <= 0)?v:lnum:""):""%} '
		call CopyHighlightGroup("StatementIns", "Statement")
	else
		set nu nornu
	endif
endfunction
augroup Visual
	au! ModeChanged *:[vV]* call Numbertoggle_stcrel()
	au! ModeChanged [vV]*:* call Numbertoggle_stcrel()
augroup END

function! STCNo()
	if has('nvim')
		setlocal stc=
	endif
	setlocal nonu nornu
endfunction
let s:stc_shrunk = v:false
function! STCUpd()
	if &columns ># 40
		if has('nvim')
			let &stc = &stc
		endif
		if s:stc_shrunk
			let &stc = s:old_stc
		endif
		let s:stc_shrunk = v:false
	else
		if s:stc_shrunk
			let &stc = ''
		else
			let s:stc_shrunk = v:true
			let s:old_stc = &stc
			let &stc = ''
		endif
	endif
endfunction
call STCUpd()

set showcmd
set showcmdloc=statusline
set laststatus=2

let s:custom_mode = ''
let s:specmode = ''
function! SetStatusLineNc()
	echohl StatusLineNc
endfunction
function! SetGitBranch()
	let s:virtual_gitbranch = split(system('git rev-parse --abbrev-ref HEAD 2> /dev/null'))
	if len(s:virtual_gitbranch) > 0
		let s:gitbranch = s:virtual_gitbranch[0]
	else
		let s:gitbranch = ''
	endif
endfunction
augroup gitbranch
	autocmd!
	autocmd BufEnter,BufLeave * call SetGitBranch()
augroup END
function! GetGitBranch()
	return s:gitbranch
endfunction
function! Showtab()
	let stl_name = '%<%t'
	let stl_name .= '%( %* %#StatusLinemod#%M%R%H%W%)%*'
	if &columns ># 40
		let stl_name .= '%( %#StatusLinemod#'
		let stl_name .= &syntax
		let stl_name .= '%)%*'
	endif
	if &columns ># 45
		let stl_name .= '%( %#Statuslinemod#'
		let stl_name .= '%{GetGitBranch()}'
		let stl_name .= '%)%*'
	endif
	let mode = mode('lololol')
	let strmode = ''
	if mode == 'n'
		let strmode = '%#ModeNorm# '
	elseif mode == 'no'
		let strmode = 'OP_PEND '
	elseif mode == 'nov'
		let strmode = 'visu OP_PEND '
	elseif mode == 'noV'
		let strmode = 'vis_line OP_PEND '
	elseif mode == 'noCTRL-v'
		let strmode = 'vis_block OP_PEND '
	elseif mode == 'niI'
		let strmode = '^o INS '
	elseif mode == 'niR'
		let strmode = '^o REPL '
	elseif mode == 'niV'
		let strmode = '^o visu REPL '
	elseif mode == 'nt'
		let strmode = '%#ModeNorm#NORM %#StatuslinestatNormTerm#%#ModeTerm# TERM '
	elseif mode == 'ntT'
		let strmode = '^\^o norm TERM '
	elseif mode == 'v'
		let strmode = '%#ModeVisu# '
	elseif mode == 'V'
		let strmode = 'VIS_LINE '
	elseif mode == 'vs'
		let strmode = '^o visu SEL '
	elseif mode == 'CTRL-V'
		let strmode = 'VIS_BLOCK '
	elseif mode == 'CTRL-Vs'
		let strmode = '^o vis_block SEL '
	elseif mode == 's'
		let strmode = 'SEL  '
	elseif mode == 'S'
		let strmode = 'SEL LINE '
	elseif mode == 'CTRL-S'
		let strmode = 'SEL BLOCK '
	elseif mode == 'i'
		let strmode = '%#ModeIns# '
	elseif mode == 'ic'
		let strmode = 'compl INS '
	elseif mode == 'ix'
		let strmode = '%#ModeCom#^x compl%#ModeIns#INS'
	elseif mode == 'R'
		let strmode = '%#ModeRepl# '
	elseif mode == 'Rc'
		let strmode = 'compl REPL '
	elseif mode == 'Rx'
		let strmode = '^x compl REPL '
	elseif mode == 'Rv'
		let strmode = '%#ModeIns#visu%*%#ModeRepl#REPL'
	elseif mode == 'Rvc'
		let strmode = 'compl visu REPL '
	elseif mode == 'Rvx'
		let strmode = '^x compl visu REPL '
	elseif mode == 'c'
		if s:specmode == 'b'
			let strmode = 'COM_BLOCK '
		else
			let strmode = '%#ModeCom# '
		endif
	elseif mode == 'cv'
		let strmode = 'EX   '
	elseif mode == 'r'
		let strmode = 'HIT_ENTER '
	elseif mode == 'rm'
		let strmode = 'MORE '
	elseif mode == 'r?'
		let strmode = 'CONFIRM '
	elseif mode == '!'
		let strmode = 'SHELL '
	elseif mode == 't'
		let strmode = '%#ModeTerm#TERM '
	else
		let strmode = '%#ModeVisu#visu %#StatuslinestatVisuBlock#%#ModeBlock# BLOCK '
	endif
	"let stl_time = '%{strftime("%b,%d %H:%M:%S")}'
	
	let stl_pos = ''
	let stl_pos .= '%l:%c'
	if &columns ># 35
		let stl_pos .= ' %LL'
	endif

	let stl_showcmd = '%(%#Statuslinemod#%S%*%)'
	let stl_buf = '#%n %p%%'
	let stl_mode_to_put = ''
	if &columns ># 20
		let stl_mode_to_put .= strmode
		let stl_mode_to_put .= s:custom_mode?' '.s:custom_mode:''
		let stl_mode_to_put .= ''
	endif

	let s:result = stl_mode_to_put
	let s:result .= stl_name
	if &columns ># 30
		let &showcmdloc = 'statusline'
		let s:result .= ' '
		let s:result .= stl_showcmd
	else
		let &showcmdloc = 'last'
	endif
	let s:result .= '%='
	if &columns ># 45
		let s:result .= '%#Statuslinestat01#'
		let s:result .= ''
		let s:result .= '%#Statuslinestat1#'
		let s:result .= ' '
	endif
	if &columns ># 30
		let s:result .= stl_pos
	endif
	if &columns ># 45
		let s:result .= ' '
	endif
	if &columns ># 45
		let s:result .= '%#Statuslinestat12#'
		let s:result .= ''
	endif
	if &columns ># 30
		let s:result .= '%#Statuslinestat2# '
		let s:result .= stl_buf
		let s:result .= ' '
	endif
	return s:result
endfunction
command! Showtab set stl=%{%Showtab()%}
Showtab

command! -nargs=* Git !git <args>
command! -nargs=* Pkg !pkg <args>

" let s:tabtimerid = 0
" function TabTimerHandler(id)
" 	let s:tabtimerid = a:id
" 	Showtab
" endfunction
" function TabTimerStart()
" 	if s:tabtimerid == 0
" 		Showtab
" 		call timer_start(500, 'TabTimerHandler', {'repeat': -1})
" 	endif
" endfunction
" function TabTimerStop()
" 	call timer_stop(s:tabtimerid)
" 	let s:tabtimerid = 0
" endfunction
" call TabTimerStart()
" function Printtabtimerid()
" 	echom "Timer id is: " . s:tabtimerid
" endfunction
" augroup tabtimer
" 	autocmd!
" 	autocmd CmdlineEnter * Showtab
" 	autocmd CmdlineLeave * call TabTimerStart()
" 	autocmd CmdwinEnter * let s:specmode = 'b' | Showtab
" 	autocmd CmdwinLeave * let s:specmode = '' | Showtab
" 	autocmd CursorHold * call TabTimerStop()
" 	autocmd CursorMoved * call TabTimerStart()
" 	autocmd CursorHoldI * call TabTimerStop()
" 	autocmd CursorMovedI * call TabTimerStart()
" 	autocmd InsertEnter * call TabTimerStart()
" 	autocmd InsertLeave * call TabTimerStart()
" augroup END
" 
" "noremap <silent> <esc> <cmd>Showtab<cr>

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowIgnored = 1
noremap <c-n> <cmd>NERDTreeToggle<cr>

augroup numbertoggle
	autocmd!
	function! Numbertoggle_stcabs()
		if &modifiable
			call STCAbs(v:insertmode)
		else
			call STCNo()
		endif
	endfunction
	function! Numbertoggle_stcrel()
		if !s:fullscreen
			if &modifiable
				call STCRel()
			else
				call STCNo()
			endif
		endif
	endfunction
	function! Numbertoggle_no()
		set stc= nonu nornu
	endfunction
	autocmd FocusGained,InsertLeave * call Numbertoggle_stcrel()
	autocmd FocusLost,InsertEnter * call Numbertoggle_stcabs()
	" autocmd BufLeave * call Numbertoggle_no()
augroup END

function! BufModifiableHandler()
	if &modifiable
		call STCRel()
	else
		call STCNo()
	endif
endfunction
autocmd BufReadPost,WinLeave,WinEnter * call BufModifiableHandler()
" call timer_start(500, 'BufModifiableHandler', {'repeat': -1})

function! MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let original_buf_name = bufname(buflist[winnr - 1])
	if original_buf_name == ''
		let buf_name = '[null]'
	else
		let buf_name = original_buf_name
	endif
	return fnamemodify(buf_name, ':~:.:gs?\([^/]\)[^/]*/?\1/?')
	" call execute("normal :!echo '" . buf_name . "' > ~/.config/nvim/config_garbagefile.txt")
	" redir! > ~/.config/nvim/config_garbagefile.txt
	" 	silent echo buf_name
	" redir END
endfunction
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    elseif (i - tabpagenr()) % 2 == 0
		let s ..= '%#TabLine#'
	else
		let s ..= '%#TabLineSec#'
    endif

    " set the tab page number (for mouse clicks)
    let s ..= '%' .. (i + 1) .. 'T'

    " the label is made by MyTabLabel()
    let s ..= '%{MyTabLabel(' .. (i + 1) .. ')}'
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'

	" let s ..= '%=%#TabLine#%999Xclose'

  return s
endfunction
set tabline=%!MyTabLine()

set hidden
set nowrap
set nolinebreak
let &breakat = "    !¡@*-+;:,./?¿{}[]^%&"
set list
set display=lastline
set fcs=lastline:>
set listchars=tab:>\ ,trail:_,nbsp:+
set shortmess=filmnrxwsWItCF
set showtabline=2
set noshowmode
set noconfirm
set virtualedit=onemore

setlocal nowrap

set matchpairs=(:),{:},[:],<:>
set noshowmatch
set matchtime=2
set maxfuncdepth=50
" set maxmapdepth=2
set maxmempattern=500
set history=10000
set modelineexpr
set updatetime=5000
set timeout
set timeoutlen=500
set nottimeout
set ttimeoutlen=500

set cursorline
set cursorlineopt=screenline,number
set cursorcolumn
set mouse=a
set nomousefocus
set nomousehide
set mousemodel=popup_setpos
set nomousemoveevent
if has('nvim')
	set mousescroll=ver:3,hor:6
endif
set mouseshape=i:beam,r:beam,s:updown,sd:cross,m:no,ml:up-arrow,v:rightup-arrow
set mousetime=400
set startofline

set concealcursor=nc
set conceallevel=0

set tabstop=4
set shiftwidth=4
set smartindent
set smarttab
set noexpandtab

let g:loaded_perl_provider = 0

command! SWrap setl wrap linebreak nolist

if v:version >= 700
  au BufLeave * let b:winview = winsaveview()
  au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif

noremap <silent> dd ddk
noremap <silent> - dd
noremap <silent> + mzyyp`zj

noremap <silent> J mzJ`z
noremap <silent> gJ mzgJ`z

let s:fullscreen = v:false
function! ToggleFullscreen()
	if !s:fullscreen
		let s:fullscreen = v:true
		let s:old_cursorline = &cursorline
		let s:old_cursorcolumn = &cursorcolumn
		let s:old_showtabline = &showtabline
		let s:old_laststatus = &laststatus
		let s:old_showcmdloc = &showcmdloc
		let s:old_showmode = &showmode
		let s:old_ruler = &ruler
		set nocursorline
		set nocursorcolumn
		set showtabline=0
		set laststatus=0
		set showcmdloc=last
		set showmode
		set ruler
		call STCAbs('')
	else
		let s:fullscreen = v:false
		let &cursorline = s:old_cursorline
		let &cursorcolumn = s:old_cursorcolumn
		let &showtabline = s:old_showtabline
		let &laststatus = s:old_laststatus
		let &showcmdloc = s:old_showcmdloc
		let &showmode = s:old_showmode
		let &ruler = s:old_ruler
		call STCRel()
	endif
endfunction
function! ToggleLocalFullscreen()
	echom "ToggleLocalFullscreen: not implemented yet"
endfunction
command! ToggleFullscreen call ToggleFullscreen()
command! ToggleLocalFullscreen call ToggleLocalFullscreen()
noremap <leader><c-f> <cmd>ToggleFullscreen<cr>
noremap <leader><c-l><c-f> <cmd>ToggleLocalFullscreen<cr>

noremap <c-t> <cmd>TagbarToggle<cr>

nnoremap <leader>g :grep -R <cword> .<cr>

"function! ProcessBut(button)
"	let mode_was = mode()
"	let temp = ''
"
"	let temp .= "\<cmd>set showcmdloc=last\<cr>"
"
"	let temp .= a:button
"
"	let temp .= "\<Esc>\<cmd>set showcmdloc=statusline\<cr>"
"
"	if mode_was == 'v' || mode_was == 'V' || mode_was == 'CTRL-V'
"		let temp .= "gv"
"	endif
"
"	return temp
"endfunction
function! ProcessGBut(button)
	let temp = ''
	let temp .= "\<cmd>set lazyredraw\<cr>"
	if v:count == 0
		let temp .= 'g' . a:button
	else
		let temp .= a:button
	endif
	call STCUpd()
	let temp .= "\<cmd>set nolazyredraw\<cr>"
	return temp
endfunction

noremap <silent> <expr> j ProcessGBut('j')
noremap <silent> <expr> k ProcessGBut('k')
noremap <silent> <expr> <down> ProcessGBut('j')
noremap <silent> <expr> <up> ProcessGBut('k')
inoremap <silent> <down> <cmd>call STCUpd()<cr><down>
inoremap <silent> <up> <cmd>call STCUpd()<cr><up>
noremap <silent> <leader>j j:let &stc=&stc<cr>
noremap <silent> <leader>k k:let &stc=&stc<cr>
noremap <silent> <leader><up> k:let &stc=&stc<cr>
noremap <silent> <leader><down> j:let &stc=&stc<cr>
noremap <silent> <c-e> <c-e><cmd>call STCUpd()<cr>
" noremap <silent> 0 g0
" noremap <silent> $ g$
" noremap <silent> I g0i
" noremap <silent> A g$a

noremap <silent> <c-s> <c-a>
noremap <silent> <c-a> <cmd>normal g0<cr>
noremap <silent> <c-e> <cmd>normal $<cr>
inoremap <silent> <c-a> <c-o>_
inoremap <silent> <c-e> <c-o>$

cnoremap <silent> <c-a> <c-b>
cnoremap <c-g> <c-e><c-u><cr>
cnoremap <silent> jk <c-e><c-u><cr>
cnoremap <c-u> <c-e><c-u>
cnoremap <c-a> <c-b>
cnoremap <c-b> <S-left>
"noremap jk <cmd>echo 'Not in Insert Mode'<cr>

nnoremap <c-j> viwUe<space><esc>
vnoremap <c-j> iwUe<space>
inoremap <c-j> <esc>viwUe<esc>a

nnoremap <bs> X
noremap <leader><bs> <bs>

function! Findfile()
	echohl Question
	let filename = input('find file: ')
	echohl Normal
	if filename !=# ''
		exec printf("tabedit %s", filename)
	endif
endfunction
command! Findfile call Findfile()
noremap <c-c>c <cmd>Findfile<cr>
function! Findfilebuffer()
	echohl Question
	let filename = input('find file (in buffer): ')
	echohl Normal
	if filename !=# ''
		exec printf("edit %s", filename)
	endif
endfunction
command! Findfilebuffer call Findfilebuffer()
noremap <c-c>C <cmd>Findfilebuffer<cr>
"nnoremap <leader>lC :tabnew<Bar>ter<Bar><cr>a./build.sh
"nnoremap <leader>lc :tabnext<Bar><c-\><c-n>:bd!<Bar>tabnew<Bar>ter<cr>a!!<cr>

nnoremap <silent> * *:noh<cr>
nnoremap <silent> <c-*> *
nnoremap <silent> # #:noh<cr>
nnoremap <silent> <c-#> #

noremap <leader>l 20zl
noremap <leader>h 20zh
inoremap <c-l> <esc>20zla
inoremap <c-h> <esc>20zha
let s:SCROLL_UP_FACTOR = 2
let s:SCROLL_DOWN_FACTOR = 2
let s:SCROLL_C_E_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_C_Y_FACTOR = s:SCROLL_DOWN_FACTOR
let s:SCROLL_MOUSE_UP_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_MOUSE_DOWN_FACTOR = s:SCROLL_DOWN_FACTOR
exec printf("noremap <silent> <expr> <c-Y> \"%s<c-e>\"", s:SCROLL_C_E_FACTOR)
exec printf("noremap <silent> <expr> <c-y> \"%s<c-y>\"", s:SCROLL_C_Y_FACTOR)
exec printf("noremap <silent> <expr> <ScrollWheelDown> \"%s<c-e><cmd>call STCUpd()<cr>\"", s:SCROLL_MOUSE_DOWN_FACTOR)
exec printf("noremap <silent> <expr> <ScrollWheelUp> \"%s<c-y><cmd>call STCUpd()<cr>\"", s:SCROLL_MOUSE_UP_FACTOR)
noremap <silent> <leader><c-e> <c-e>
noremap <silent> <leader><c-y> <c-y>

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
noremap <silent> <leader>bt <esc>:tabe ~/.dotfiles-script.sh<cr>
noremap <silent> <leader>bb <esc>:e ~/.dotfiles-script.sh<cr>
noremap <silent> <leader>bh <esc>:sp ~/.dotfiles-script.sh<cr>
noremap <silent> <leader>bv <esc>:vsp ~/.dotfiles-script.sh<cr>

autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" MY .nvimrc HELP
noremap <silent> <leader>? <esc>:echo "
  \MY .nvimrc HELP:
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
\\n      You can press `l`, `h`, `right` and `left` at the end of the line and it will go to the beginning of the next line (in Normal mode).
\\n      To disable this feature, run this command in bash:
\\n      ╭──────────────────────────╮
\\n      │ $ disable_autowrapping=1 │
\\n      ╰──────────────────────────╯
\\n    SPECIAL:
\\n      ; - Switch to command mode (:)
\\n      SPC SPC - Open quickui menu
\\n      INSERT: jk - Exit from Insert Mode
\\n      INSERT: ju - Make current word uppercase
\\n      CTRL-a - Move to start of line
\\n      CTRL-e - Move to end of line
\\n      CTRL-h - 20zh
\\n      CTRL-l - 20zl
\\n      CTRL-a - Increase number
\\n      CTRL-x - Deecrease number
\\n      ci_ - Edit word from start to first _
\\n      \<leader\>d  - Remove search highlightings
\\n      s - Delete (d) without copying
\\n      q - Quit window
\\n      Q - Quit without saving
\\n      CTRL-c - Find file
\\n      CTRL-C - Find file in buffer
\\n      \<leader\>S - Toggle scrolloff (see :h 'scrolloff')
\\n    Like in Emacs:
\\n      ALT-x - Switch to command mode (:)
\\n      F10 - Open quickui menu
\\n      CTRL-x CTRL-c - Close All windows
\\n      CTRL-x s - Save current buffer
\\n      CTRL-x CTRL-s - See CTRL-x s
\\n      CTRL-x k - Kill current buffer
\\n      CTRL-x 0 - Close current window
\\n      CTRL-x 1 - Close all but current window
\\n      CTRL-x 2 - Split window
\\n      CTRL-x 3 - Vertically split window
\\n      CTRL-x o - Next tab
\\n      CTRL-x O - Previous tab
\\n      CTRL-x CTRL-f - See CTRL-c c
\\n      CTRL-x t 0 - Close current tab
\\n      CTRL-x t 1 - Close all but current tab
\\n      CTRL-x t 2 - New tab
\\n      CTRL-x t o - Next tab
\\n      CTRL-x t O - Previous tab
\\n      CTRL-x h - Select all text
\\n      CTRL-x CTRL-h - See help (:h)
\\n    QUOTES AROUND:
\\n      \<leader\>\" - Put \'\"\' around word
\\n      \<leader\>\' - Put \"\'\" around word
\\n  TERMINAL:
\\n    \<leader\>tt - Open in a new tab
\\n    \<leader\>tb - Open in a new buffer
\\n    \<leader\>th - Open in a new horizontal window (-)
\\n    \<leader\>tv - Open in a new vertical window (\|)
\\n  COLORSCHEME:
\\n    \<leader\>cet - Open colorschemes in a new tab
\\n    \<leader\>ceb - Open colorschemes in a new buffer
\\n    \<leader\>ceh - Open colorschemes in a new horizontal window (-)
\\n    \<leader\>cev - Open colorschemes in a new vertical window (\|)
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
\\n    Github: https://github.com/TwoSpikes/dotfiles.git
\"<cr>

" FAST COMMANDS
noremap ; :
noremap <silent> <leader>; ;
noremap <silent> <leader>: :<c-f>a
"noremap <leader>= :tabe 
"noremap <leader>- :e 
noremap <leader>= <cmd>echo "use \<c-c\>c"<cr>
noremap <leader>- <cmd>echo "use \<c-c\>C"<cr>
noremap <leader>1 :!

" QUOTES AROUND
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

" SPECIAL
nnoremap ci_ yiwct_
noremap <silent> <leader>d <esc>:noh<cr>
tnoremap <c-]> <c-\><esc>

" TERMINAL
function! OpenTerm(cmd)
	if a:cmd ==# ""
		exec printf("terminal %s", $SHELL." -l")
	else
		exec printf("terminal %s", a:cmd)
	endif
	setlocal statuscolumn=
	setlocal nonu nornu
	startinsert
endfunction
noremap <silent> <leader>tt <cmd>tabnew<cr><cmd>call OpenTerm("")<cr>
noremap <silent> <leader>tb <cmd>call OpenTerm("")<cr>
noremap <silent> <leader>th <cmd>split<cr><cmd>call OpenTerm("")<cr>
noremap <silent> <leader>tv <cmd>vsplit<cr><cmd>call OpenTerm("")<cr>
exec printf("noremap <silent> <leader>tf <cmd>FloatermNew %s -l<cr>", $SHELL)
" noremap <silent> <leader>tct <c-\><c-n>:q\|tabnew\|ter<cr>a

" COLORSCHEME
noremap <silent> <leader>ct :tabe $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>cb :e $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>ch :split $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>cv :vsplit $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>cf :FloatermNew nvim -c "ToggleFullscreen" $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>cy <cmd>set lazyredraw<cr>yy:<c-f>pvf]o0"_dxicolo <esc>$x$x$x$x<cr>jzb<cmd>set nolazyredraw<cr>

augroup cpp
	au!
	au filetype cpp noremap <silent> <buffer> <leader>n viwo<esc>i::<esc>hi
	au filetype cpp noremap <silent> <buffer> <leader>/d mz0i//<esc>`zll
	au filetype cpp noremap <silent> <buffer> <leader>/u mz:s:^//<cr>`zhh:noh<cr>
	au filetype cpp noremap <silent> <buffer> <leader>! :e ~/.config/tsvimconf/cpp/example.cpp<cr>ggvGy:bd<cr>pgg
augroup END
augroup vim
	au!
	au filetype vim noremap <silent> <buffer> <leader>/d mz0i"<esc>`zl
	au filetype vim noremap <silent> <buffer> <leader>/u mz:s/^"<cr>`zh:noh<cr>
augroup END
augroup googol
	au!
	au syntax googol noremap <silent> <buffer> <leader>/d mz0i//<esc>`zll
	au syntax googol noremap <silent> <buffer> <leader>/u mz:s:^//<cr>`zhh:noh<cr>
augroup END
augroup php
	au!
	au filetype php nnoremap <silent> <buffer> <leader>g viwoviGLOBALS['<esc>ea']<esc>
augroup END
augroup bash
	au!
	au filetype bash,sh setlocal nowrap linebreak
augroup END
augroup python
	au!
	au filetype python nnoremap <silent> <buffer> <leader>/d mz0i#<esc>`zl
	au filetype python nnoremap <silent> <buffer> <leader>/u mz:s/^#<cr>`zh:noh<cr>
augroup END
augroup netrw
	au!
	au filetype netrw setlocal nocursorcolumn
	au filetype nerdtree setlocal nocursorcolumn
augroup END
augroup terminal
	au!
	if has('nvim')
		au termopen * setlocal nocursorline nocursorcolumn
	endif
augroup END
augroup visual
	function! HandleBuftype()
		let &cursorcolumn = mode() !~# "[vVirco]" && !s:fullscreen && &filetype !=# 'netrw' && &buftype !=# 'terminal' && &filetype !=# 'nerdtree'
		let &cursorline = mode() !~# "[irco]" && !s:fullscreen && &buftype !=# 'terminal'
	endfunction
	au ModeChanged,BufWinEnter * call HandleBuftype()
augroup END

" TELESCOPE
nnoremap <silent> <leader>ff :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fg :lua require'telescope.builtin'.live_grep(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fb :lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fh :lua require'telescope.builtin'.help_tags(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>

" vnoremap <c-/> <esc>v:q:s/.*/# \0
" vnoremap <c-?> <esc>:s/.*/\/\/ \0

function! IsYes(string)
	return a:string ==# 'y' || a:string ==# 'Y' || a:string ==# 'yes' || a:string ==# 'Yes' || a:string ==# 'YES'
endfunction
function! IsNo(string)
	return a:string ==# 'n' || a:string ==# 'N' || a:string ==# 'no' || a:string ==# 'No' || a:string ==# 'NO'
endfunction

" Tab closers
noremap <silent> q <cmd>q<cr>
noremap <silent> Q <cmd>q!<cr>
noremap <c-w><c-g> <cmd>echo "Quit"<cr>

" Emacs support
noremap <silent> <c-x><c-c> <cmd>qa<cr>
noremap <silent> <c-x>s <cmd>w<cr>
noremap <silent> <c-x><c-s> <cmd>w<cr>
function! Killbuffer()
	echohl Question
	let user_input = input("do you wanna kill the buffer (Y/n): ")
	echohl Normal
	if user_input ==# '' || IsYes(user_input)
		bdelete
	elseif !IsNo(user_input)
		echohl ErrorMsg
		echo " "
		echo "please answer "
		echohl Title
		echon "yes"
		echohl ErrorMsg
		echon " or "
		echohl Title
		echon "no"
		echohl ErrorMsg
		echon " or leave blank empty"
		echohl Normal
	endif
endfunction
command! Killbuffer call Killbuffer()
noremap <silent> <c-x>k <cmd>Killbuffer<cr>
noremap <silent> <c-x>0 <cmd>q<cr>
noremap <silent> <c-x>1 <cmd>only<cr>
noremap <silent> <c-x>2 <cmd>split<cr>
noremap <silent> <c-x>3 <cmd>vsplit<cr>
noremap <silent> <c-x>o <c-w>w
noremap <silent> <c-x>O <c-w>W
noremap <silent> <c-x><c-f> <cmd>Findfilebuffer<cr>
noremap <silent> <c-x>t0 <cmd>tabclose<cr>
noremap <silent> <c-x>t1 <cmd>tabonly<cr>
noremap <silent> <c-x>t2 <cmd>tabnew<cr>
noremap <silent> <c-x>to <cmd>tabnext<cr>
noremap <silent> <c-x>tO <cmd>tabprevious<cr>
noremap <silent> <c-x>5 <cmd>echo "Frames are only in Emacs/GNU Emacs"<cr>
noremap <m-x> :
noremap <silent> <c-x>h ggVG
noremap <silent> <c-x><c-h> <cmd>h<cr>
noremap <silent> <c-x><c-g> <cmd>echo "Quit"<cr>

noremap mz <cmd>echohl ErrorMsg<cr><cmd>echom "mz is used for commands"<cr><cmd>echohl Normal<cr>

noremap <leader>q q
noremap <leader>Q Q

inoremap <silent> jk <esc>:w<cr>
inoremap <silent> jK <esc>
inoremap <silent> JK <esc>:w<cr>
inoremap <silent> Jk <esc>
tnoremap <silent> jk <c-\><c-n>
tnoremap <silent> jK <c-\><c-n>:bd!<Bar>tabnew<Bar>call OpenTerm("")<cr>
command! W w

inoremap <silent> ju <esc>viwUea
inoremap <silent> ji <esc>viwUea

inoremap ( ()<c-o>h
inoremap [ []<c-o>h
inoremap { {}<c-o>h
function! HandleKeystroke(keystroke)
	if a:keystroke ==# "\\\<bs>"
		if getline('.')[col('.')-2] ==# '('
		\&& getline('.')[col('.')-1] ==# ')'
		\|| getline('.')[col('.')-2] ==# '{'
		\&& getline('.')[col('.')-1] ==# '}'
		\|| getline('.')[col('.')-2] ==# '['
		\&& getline('.')[col('.')-1] ==# ']'
		\|| getline('.')[col('.')-2] ==# "'"
		\&& getline('.')[col('.')-1] ==# "'"
		\|| getline('.')[col('.')-2] ==# '"'
		\&& getline('.')[col('.')-1] ==# '"'
		\|| getline('.')[col('.')-2] ==# '<'
		\&& getline('.')[col('.')-1] ==# '>'
			return "\<del>\<bs>"
		else
			return "\<bs>"
		endif
	endif
	if a:keystroke ==# ')'
	\&& getline('.')[col('.')-1] ==# ')'
	\|| a:keystroke ==# ']'
	\&& getline('.')[col('.')-1] ==# ']'
	\|| a:keystroke ==# '}'
	\&& getline('.')[col('.')-1] ==# '}'
	\|| a:keystroke ==# "'"
	\&& getline('.')[col('.')-1] ==# "'"
	\|| a:keystroke ==# '"'
	\&& getline('.')[col('.')-1] ==# '"'
		return "\<right>"
	else
		if a:keystroke ==# '"'
		\|| a:keystroke ==# "'"
			return a:keystroke.a:keystroke."\<left>"
		endif
		return a:keystroke
	endif
endfunction
inoremap <expr> ) HandleKeystroke(')')
inoremap <expr> ] HandleKeystroke(']')
inoremap <expr> } HandleKeystroke('}')
inoremap <expr> ' HandleKeystroke("'")
inoremap <expr> " HandleKeystroke('"')
inoremap <expr> <bs> HandleKeystroke('\<bs>')

if has('nvim')
	exec printf("luafile %s", s:PLUGINS_INSTALL_FILE_PATH)
	PackerInstall
	exec printf("luafile %s", s:PLUGINS_SETUP_FILE_PATH)
endif

so ~/xterm-color-table.vim

if has('nvim')
	lua M = {}
	lua servers = { gopls = {}, html = {}, jsonls = {}, pyright = {}, rust_analyzer = {}, sumneko_lua = {}, tsserver = {}, vimls = {}, }
	lua on_attach = function(client, bufnr) vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc") vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()") require("config.lsp.keymaps").setup(client, bufnr) end
	lua opts = { on_attach = on_attach, flags = { debounce_text_changes = 150, }, }
	lua setup = function() require("config.lsp.installer").setup(servers, opts) end
endif

if has('nvim')
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
endif

noremap <silent> <leader>S :let &scrolloff = 999 - &scrolloff<cr>

nnoremap s "_d

noremap <silent> <f10> <cmd>call quickui#menu#open()<cr>

" Interface
function! ChangeVisual()
	echo "Visual changed to "
	echohl Visual
	echon "blue"
	echohl Normal
	hi Visual ctermfg=NONE ctermbg=18 cterm=NONE guifg=NONE guibg=#000087 gui=NONE
endfunction
command! ChangeVisual call ChangeVisual()
function! DeChangeVisual()
	echo "Visual changed to reversed "
	hi Visual ctermfg=NONE ctermbg=NONE cterm=reverse guifg=NONE guibg=NONE gui=reverse
endfunction
command! DeChangeVisual call DeChangeVisual()
noremap <leader>iv ChangeVisual
noremap <leader>iV DeChangeVisual

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
endfunction

au VimResized * call OnResized()
function! OnResized()
	echom "Window: ".&lines."rows, ".&columns."cols"
	call STCUpd()
endfunction

" Russian mappings
map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m

augroup LineNrForInactive
	function! s:SaveStc(clear_stc)
		exec printf("let g:stc_was_%d = &l:stc", win_getid())
		if a:clear_stc
			let &l:stc = ''
		endif
	endfunction
	au! WinLeave * call s:SaveStc(v:true)
	function! s:LoadStc()
		if exists("g:stc_was_"..win_getid())==#1
			let &l:stc = eval("g:stc_was_"..win_getid())
		else
			let &l:stc = ''
		endif
	endfunction
	au! WinEnter * call s:LoadStc()
augroup END

let g:floaterm_width = 1.0
noremap <leader>zt <cmd>tabnew<cr><cmd>call OpenTerm("lazygit")<cr>
noremap <leader>zb <cmd>call OpenTerm("lazygit")<cr>
noremap <leader>zh <cmd>split<cr><cmd>call OpenTerm("lazygit")<cr>
noremap <leader>zv <cmd>vsplit<cr><cmd>call OpenTerm("lazygit")<cr>
noremap <leader>zf <cmd>FloatermNew lazygit<cr>
noremap <leader>mt <cmd>tabnew<cr><cmd>call OpenTerm("mc")<cr>
noremap <leader>mb <cmd>call OpenTerm("mc")<cr>
noremap <leader>mh <cmd>split<cr><cmd>call OpenTerm("mc")<cr>
noremap <leader>mv <cmd>vsplit<cr><cmd>call OpenTerm("mc")<cr>
noremap <leader>mf <cmd>FloatermNew mc<cr>

function! g:TermuxSaveCursorStyle()
	if $TERMUX_VERSION !=# "" && filereadable(expand("~/.termux/termux.properties"))
		if !filereadable(expand("~/.cache/dotfiles/termux/terminal_cursor_style"))
			let TMPFILE=trim(system(["mktemp", "-u"]))
			call system(["cp", expand("~/.termux/termux.properties"), TMPFILE])
			call system(["sed", "-i", "s/ *= */=/", TMPFILE])
			call system(["sed", "-i", "s/-/_/g", TMPFILE])
			call writefile(["echo $terminal_cursor_style"], TMPFILE, "a")
			let g:termux_cursor_style = trim(system(TMPFILE))
			if !isdirectory(expand("~/.cache/dotfiles/termux"))
				call mkdir(expand("~/.cache/dotfiles/termux"), "p", 0700)
			endif
			call writefile([g:termux_cursor_style], expand("~/.cache/dotfiles/termux/terminal_cursor_style"), "")
			call system(["rm", TMPFILE])
		else
			let g:termux_cursor_style = trim(readfile(expand("~/.cache/dotfiles/termux/terminal_cursor_style"))[0])
		endif
	endif
endfunction
function! g:TermuxLoadCursorStyle()
	if $TERMUX_VERSION !=# "" && filereadable(expand("~/.termux/termux.properties")) && exists("g:termux_cursor_style")
		if g:termux_cursor_style ==# "block"
			let &guicursor = "a:block"
		elseif g:termux_cursor_style ==# "bar"
			let &guicursor = "a:ver25"
		elseif g:termux_cursor_style ==# "underline"
			let &guicursor = "a:hor25"
		endif
	endif
endfunction
au! VimEnter * call g:TermuxSaveCursorStyle()
au! VimLeave * call g:TermuxLoadCursorStyle()

if expand("%") == ""
	edit ./
endif

function s:PrintIntroHelp()
	echo 'type ' | echohl SpecialKey | echon ':intro<cr>' | echohl Normal | echon ' to see help'
endfunction
if v:vim_did_enter
	call s:PrintIntroHelp()
else
	au! SourcePost init.vim call s:PrintIntroHelp()
endif
