#!/bin/env -S nvim -u

if !exists('g:DOTFILES_CONFIG_PATH')
	if !exists('$DOTFILES_VIM_CONFIG_PATH')
		let g:DOTFILES_CONFIG_PATH = "$HOME/.config/dotfiles/vim"
	else
		let g:DOTFILES_CONFIG_PATH = $DOTFILES_VIM_CONFIG_PATH
	endif
	let g:DOTFILES_CONFIG_PATH = expand(g:DOTFILES_CONFIG_PATH)
endif

function! LoadDotfilesConfig(path, reload=v:false)
	if !filereadable(a:path)
		echohl ErrorMsg
		echom "error: no dotfiles vim config"
		echohl Normal
		return 1
	endif
	let l:dotfiles_config_str = join(readfile(a:path, ''), '')
	silent execute "let g:dotfiles_config = json_decode(l:dotfiles_config_str)"
	if type(g:dotfiles_config) !=# v:t_dict
		echohl ErrorMsg
		echom "error: failed to parse dotfiles vim config"
		echohl Normal
		return 1
	endif

	let l:option_list = [
		\'setup_lsp',
		\'use_transparent_bg',
		\'background',
		\'use_italic_style',
		\'cursorcolumn',
		\'open_menu_on_start',
		\'quickui_border_style',
		\'quickui_color_scheme',
		\'open_ranger_on_start',
		\'DO_NOT_OPEN_ANYTHING',
	\]
	for option_ in l:option_list
		if exists('g:dotfiles_config["'.option_.'"]')
			if !exists("g:".option_) || a:reload
				exec printf("let g:%s = g:dotfiles_config[option_]", option_)
			endif
		endif
	endfor
endfunction
call LoadDotfilesConfig(g:DOTFILES_CONFIG_PATH.'/config.json')

function! HandleDotfilesConfig()
	if !exists('g:cursorcolumn')
		let g:cursorcolumn = v:false
	endif
	if !exists('g:cursorline')
		let g:cursorline = v:true
	endif
	if exists('g:background')
		if g:background ==# "dark"
			set background=dark
		else
			set background=light
		endif
	endif
endfunction
call HandleDotfilesConfig()

let mapleader = " "

if !exists('g:CONFIG_PATH')
	if !exists('$VIM_CONFIG_PATH')
		let g:CONFIG_PATH = "$HOME/.config/nvim"
	else
		let g:CONFIG_PATH = $VIM_CONFIG_PATH
	endif
endif

if exists('g:CONFIG_ALREADY_LOADED')
	if g:CONFIG_ALREADY_LOADED
		call HandleBuftypeAll()
	endif
endif
let g:CONFIG_ALREADY_LOADED = v:true

if $PREFIX == ""
	call setenv('PREFIX', '/usr/')
endif

colorscheme blueorange
set termguicolors
set lazyredraw
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
function! WhenceGroup()
	let l:s = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
	exec "verbose hi ".l:s
endfunction

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
	exec printf("hi %s ctermfg=%s", a:dst, ctermfg)
	exec printf("hi %s ctermbg=%s", a:dst, ctermbg)
	exec printf("hi %s cterm=%s", a:dst, cterm)
	exec printf("hi %s guifg=%s", a:dst, guifg)
	exec printf("hi %s guibg=%s", a:dst, guibg)
	exec printf("hi %s gui=%s", a:dst, gui)
endfunction

function! PrepareVital()
	let g:VitalModule#Random = vital#vital#import('Random')

endfunction
function! GetRandomName(length)
	let name = "Rnd_"
	for _ in range(a:length)
		let r = g:VitalModule#Random.range(1, 4)
		if r ==# 1
			let name .= nr2char(g:VitalModule#Random.range(48, 58))
		elseif r ==# 2
			let name .= nr2char(g:VitalModule#Random.range(65, 91))
		elseif r ==# 3
			let name .= nr2char(g:VitalModule#Random.range(97, 123))
		else
			echohl ErrorMsg
			echom "Internal error"
			echohl Normal
		endif
	endfor
	unlet r
	return name
endfunction
function! GenerateTemporaryAutocmd(event, pattern, command, delete_when)
	let random_name = GetRandomName(20)
	exec 'augroup '.random_name
		au!
		exec "autocmd ".a:event." ".a:pattern." ".a:command."|".a:delete_when(random_name)
	augroup END
endfunction
function! AfterSomeEvent(event, command, delete_when={name -> 'au! '.name})
	call GenerateTemporaryAutocmd(a:event, '*', a:command, a:delete_when)
endfunction
function! MakeThingsThatRequireBeDoneAfterPluginsLoaded()
	au TermClose * if !exists('g:bufnrforranger')|call IfOneWinDo("call OnQuit()")|call AfterSomeEvent('TermLeave', 'call Numbertoggle()')|quit|endif
endfunction

set nonu
set nornu
function! STCRel()
	if has('nvim')
		if mode() =~? 'v.*' || mode() ==# "\<c-v>"
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
		if mode() =~? 'v.*' && &modifiable
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
	exec "au! ModeChanged *:\<c-v>* call Numbertoggle_stcrel()"
	au! ModeChanged [vV]*:* call Numbertoggle()
	exec "au! ModeChanged \<c-v>*:* call Numbertoggle()"
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

nnoremap <c-f> <c-f><cmd>call STCUpd()<cr>
nnoremap <c-u> <c-u><cmd>call STCUpd()<cr>

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
		let strmode = '%#ModeNorm#NORM %#StatuslinestatNormTerm#%#ModeTerm# '
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
		let strmode = '%#ModeTerm# '
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
command! -nargs=0 Showtab set stl=%{%Showtab()%}

" command! -nargs=* Git !git <args>
command! -nargs=* Pkg !pkg <args>
function! DotfilesCommit()
	!dotfiles commit --only-copy
	cd ~/dotfiles
	Git commit --all --verbose
endfunction
command! -nargs=0 DotfilesCommit call DotfilesCommit()

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

augroup numbertoggle
	autocmd!
	function! Numbertoggle_stcabs()
		if &modifiable && &buftype !=# 'terminal' && &buftype !=# 'nofile' && &filetype !=# 'netrw' && &filetype !=# 'nerdtree' && &filetype !=# 'TelescopePrompt' && &filetype !=# 'packer'
			call STCAbs(v:insertmode)
		else
			call STCNo()
		endif
	endfunction	
	function! Numbertoggle_stcrel()
		if &modifiable && &buftype !=# 'terminal' && &buftype !=# 'nofile' && &filetype !=# 'netrw' && &filetype !=# 'nerdtree' && &filetype !=# 'TelescopePrompt' && &filetype !=# 'packer'
			call STCRel()
		else
			call STCNo()
		endif
	endfunction
	function! Numbertoggle()
		if mode() =~? 'i'
			call Numbertoggle_stcabs()
		else
			call Numbertoggle_stcrel()
		endif
	endfunction
	function! Numbertoggle_no()
		set stc= nonu nornu
	endfunction
	autocmd InsertLeave * call Numbertoggle_stcrel()
	autocmd InsertEnter * call Numbertoggle_stcabs()
	autocmd BufReadPost,BufEnter,BufLeave,WinLeave,WinEnter * call Numbertoggle()
	autocmd FileType packer call STCNo() | set nocursorline nocursorcolumn
	" autocmd BufLeave * call Numbertoggle_no()
augroup END

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
noremap <c-h> <cmd>NERDTreeToggle<cr>

" autocmd BufReadPost,WinLeave,WinEnter * call Numbertoggle_stcrel()
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
set timeoutlen=250
set ttimeout
set ttimeoutlen=500

set cursorlineopt=screenline,number
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

command! -nargs=0 SWrap setl wrap linebreak nolist

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
	else
		let s:fullscreen = v:false
		let &cursorline = s:old_cursorline
		let &cursorcolumn = s:old_cursorcolumn
		let &showtabline = s:old_showtabline
		let &laststatus = s:old_laststatus
		let &showcmdloc = s:old_showcmdloc
		let &showmode = s:old_showmode
		let &ruler = s:old_ruler
		echon ''
	endif
endfunction
command! ToggleFullscreen call ToggleFullscreen()
noremap <leader><c-f> <cmd>ToggleFullscreen<cr>
noremap <f3> <cmd>ToggleFullscreen<cr>

noremap <c-t> <cmd>TagbarToggle<cr>

nnoremap <leader>g :grep -R <cword> .<cr>

function! ProcessGBut(button)
	let temp = ''
	if &buftype !=# 'terminal'
		let temp .= "\<cmd>set lazyredraw\<cr>"
	endif
	if v:count == 0
		let temp.="g".a:button
	else
		let temp.=v:count.a:button
	endif
	if s:fullscreen || !&cursorcolumn
		call STCUpd()
	endif
	if &buftype !=# 'terminal'
		let temp .= "\<cmd>set nolazyredraw\<cr>"
	endif
	return temp
endfunction

noremap <silent> <expr> j ProcessGBut('j')
noremap <silent> <expr> k ProcessGBut('k')
noremap <silent> <expr> <down> ProcessGBut('j')
noremap <silent> <expr> <up> ProcessGBut('k')
inoremap <silent> <down> <cmd>call STCUpd()<cr><down>
inoremap <silent> <up> <cmd>call STCUpd()<cr><up>
noremap <silent> <leader><up> k:let &stc=&stc<cr>
noremap <silent> <leader><down> j:let &stc=&stc<cr>
noremap <silent> <c-e> <c-e><cmd>call STCUpd()<cr>
" noremap <silent> 0 g0
" noremap <silent> $ g$
" noremap <silent> I g0i
" noremap <silent> A g$a

noremap <silent> <c-e> <cmd>normal $<cr>
inoremap <silent> <c-a> <c-o>_
inoremap <silent> <c-e> <c-o>$

cnoremap <silent> <c-a> <c-b>
cnoremap <c-g> <c-e><c-u><cr>
cnoremap <silent> jk <c-e><c-u><cr>
cnoremap <c-u> <c-e><c-u>
cnoremap <c-b> <S-left>
"noremap jk <cmd>echo 'Not in Insert Mode'<cr>

nnoremap <c-j> viwUe<space><esc>
vnoremap <c-j> iwUe<space>
inoremap <c-j> <esc>viwUe<esc>a

nnoremap <bs> X
noremap <leader><bs> <bs>

function! Findfile()
	if !filereadable(expand('~/.local/share/nvim/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim'))
		echohl Question
		let filename = input('Find file: ')
		echohl Normal
	else
		let filename = quickui#input#open('Find file:                 ', fnamemodify(expand('%'), ':~:.'))
	endif
	if filename !=# ''
		set lazyredraw
		exec printf("tabedit %s", filename)
		set nolazyredraw
	endif
endfunction
command! -nargs=0 Findfile call Findfile()
noremap <c-c>c <cmd>Findfile<cr>
function! Findfilebuffer()
	if !filereadable(expand('~/.local/share/nvim/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim'))
		echohl Question
		let filename = input('Find file (open in buffer): ')
		echohl Normal
	else
		set lazyredraw
		let filename = quickui#input#open('Find file (open in buffer):', fnamemodify(expand('%'), ':~:.'))
		set nolazyredraw
	endif
	if filename !=# ''
		exec printf("edit %s", filename)
	endif
endfunction
command! -nargs=0 Findfilebuffer call Findfilebuffer()
noremap <c-c>C <cmd>Findfilebuffer<cr>
noremap <c-c>% <cmd>split<cr>
noremap <c-c>" <cmd>vsplit<cr>
noremap <c-c>w <cmd>quit<cr>
for i in range(1, 9)
	exec "noremap <c-c>".i." <cmd>tabnext ".i."<cr>"
endfor
"nnoremap <leader>lC :tabnew<Bar>ter<Bar><cr>a./build.sh
"nnoremap <leader>lc :tabnext<Bar><c-\><c-n>:bd!<Bar>tabnew<Bar>ter<cr>a!!<cr>

function! FarOrMc()
	if executable("far")
		let g:far_or_mc = 'far'
	elseif executable("far2l")
		let g:far_or_mc = 'far2l'
	else
		let g:far_or_mc = 'far2l'
	endif
endfunction
call FarOrMc()

function! SelectPosition(cmd, positions)
	while v:true
		if !has('nvim')||!filereadable(expand('~/.local/share/nvim/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim'))
			echohl Question
			echon printf('Select position %s: ', keys(a:positions))
			echohl Normal
			let position = nr2char(getchar())
			echon position
			redraw
		else
			let button_label_string = ''
			for val in values(a:positions)[:-2]
				let button_label_string .= val['button_label']."\n"
			endfor
			let button_label_string .= values(a:positions)[-1]['button_label']

			let choice = quickui#confirm#open('Select position', button_label_string, 1, 'Confirm')
			unlet button_label_string

			let position = keys(a:positions)[choice-1]
		endif
		if char2nr(position) ==# 0
			continue
		endif
		if exists('a:positions[position]')
			exec a:positions[position]['command'](a:cmd)
		else
			echohl ErrorMsg
			echom "Wrong position: ".position
			echohl Normal
			return 1
		endif
		break
	endwhile
endfunction

let g:stdpos = {
	\ 'h': {'button_label': '&Split', 'command': {cmd -> 'split '.cmd}},
	\ 'v': {'button_label': '&Vsplit', 'command': {cmd -> 'vsplit '.cmd}},
	\ 'b': {'button_label': '&Buffer', 'command': {cmd -> 'e '.cmd}},
	\ 't': {'button_label': 'New &tab', 'command': {cmd -> 'tabnew|e '.cmd}},
\ }
let g:termpos = {
	\ 'h': {'button_label': '&Split', 'command': {cmd -> 'split|call OpenTerm("'.cmd.'")'}},
	\ 'v': {'button_label': '&Vsplit', 'command': {cmd -> 'vsplit|call OpenTerm("'.cmd.'")'}},
	\ 'b': {'button_label': '&Buffer', 'command': {cmd -> 'e|call OpenTerm("'.cmd.'")'}},
	\ 't': {'button_label': 'New &tab', 'command': {cmd -> 'tabnew|call OpenTerm("'.cmd.'")'}},
	\ 'f': {'button_label': '&Floating', 'command': {cmd -> 'FloatermNew '.cmd}},
\ }

nnoremap <silent> * *:noh<cr>
nnoremap <silent> <c-*> *
nnoremap <silent> # #:noh<cr>
nnoremap <silent> <c-#> #

noremap <leader>l 10zl
noremap <leader>h 10zh
inoremap <c-l> <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>set lazyredraw<cr><cmd>normal! 10zl<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr><cmd>call HandleBuftype(winnr())<cr>
inoremap <c-h> <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>set lazyredraw<cr><cmd>normal! 10zh<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr><cmd>call HandleBuftype(winnr())<cr>
let s:SCROLL_UP_FACTOR = 2
let s:SCROLL_DOWN_FACTOR = 2
let s:SCROLL_C_E_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_C_Y_FACTOR = s:SCROLL_DOWN_FACTOR
let s:SCROLL_MOUSE_UP_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_MOUSE_DOWN_FACTOR = s:SCROLL_DOWN_FACTOR
exec printf("noremap <silent> <expr> <c-Y> \"%s<c-e>\"", s:SCROLL_C_E_FACTOR)
exec printf("noremap <silent> <expr> <c-y> \"%s<c-y>\"", s:SCROLL_C_Y_FACTOR)
exec printf("noremap <silent> <ScrollWheelDown> <cmd>set lazyredraw<cr>%s<c-e><cmd>call STCUpd()<cr><cmd>set nolazyredraw<cr>", s:SCROLL_MOUSE_DOWN_FACTOR)
exec printf("noremap <silent> <ScrollWheelUp> <cmd>set lazyredraw<cr>%s<c-y><cmd>call STCUpd()<cr><cmd>set nolazyredraw<cr>", s:SCROLL_MOUSE_UP_FACTOR)
noremap <silent> <leader><c-e> <c-e>
noremap <silent> <leader><c-y> <c-y>

" NVIMRC FILE
let g:PLUGINS_INSTALL_FILE_PATH = '~/.config/nvim/lua/packages/plugins.lua'
let g:PLUGINS_SETUP_FILE_PATH = '~/.config/nvim/lua/packages/plugins_setup.lua'
let g:LSP_PLUGINS_SETUP_FILE_PATH = '~/.config/nvim/lua/packages/lsp/plugins.lua'

exec printf('noremap <silent> <leader>ve <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:CONFIG_PATH."/init.vim")
exec printf("noremap <silent> <leader>se <esc>:so %s<cr>", g:CONFIG_PATH.'/init.vim')

exec printf('noremap <silent> <leader>vi <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:PLUGINS_INSTALL_FILE_PATH)
exec printf("noremap <silent> <leader>si <esc>:so %s<cr>", g:PLUGINS_INSTALL_FILE_PATH)

exec printf('noremap <silent> <leader>vs <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>ss <esc>:so %s<cr>", g:PLUGINS_SETUP_FILE_PATH)

exec printf('noremap <silent> <leader>vl <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:LSP_PLUGINS_SETUP_FILE_PATH)
exec printf("noremap <silent> <leader>sl <esc>:so %s<cr>", g:LSP_PLUGINS_SETUP_FILE_PATH)

exec printf('noremap <silent> <leader>vj <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:DOTFILES_CONFIG_PATH.'/config.json')
exec printf('noremap <silent> <leader>sj <cmd>call LoadDotfilesConfig("%s", v:true)<cr><cmd>call HandleDotfilesConfig()<cr><cmd>call HandleBuftypeAll()<cr>', expand(g:DOTFILES_CONFIG_PATH).'/config.json')

" .dotfiles-script.sh FILE
noremap <silent> <leader>b <cmd>call SelectPosition("~/.dotfiles-script.sh", g:stdpos)<cr>

autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" MY .nvimrc HELP
function! DotfilesCheatSheet()
	echo "
	  \Help for my NeoVim config:
	\\n     By default, \<leader\> (LEAD) is space symbol.
	\\n     You can change it typing this command in Vim/Neovim:
	\\n     ╭───────────────────────────╮
	\\n     │ :let mapleader = \"symbol\" │
	\\n     ╰───────────────────────────╯
	\\n     Where symbol is your symbol (type quotes literally)
	\\n  GLOBAL HELP:
	\\n    LEAD ? - Show this help message
	\\n OPEN CONFIGS:
	\\n    LEAD ve - Open init.vim
	\\n    LEAD se  - Reload init.vim
	\\n    LEAD vi - Open plugins list
	\\n    LEAD si - Install plugins in plugins list
	\\n    LEAD vs - Open plugins setup
	\\n    LEAD ss - Reload plugins setup
	\\n    LEAD vl - Open lsp settings (deprecated due to coc.nvim)
	\\n    LEAD vl - Reload lsp settings (deprecated)
	\\n    LEAD vj - Open dotfiles config
	\\n    LEAD sj - Reload dotfiles config
	\\n    LEAD b - Open .dotfiles-script.sh
	\\n    LEAD C - Open colorschemes
	\\n    LEAD Cy - Apply colorscheme under cursor
	\\n  EDITING:
	\\n    SPECIAL:
	\\n      ; - Switch to command mode (:)
	\\n      LEAD - Show possible keyboard shortcuts
	\\n      LEAD LEAD or F10 or F9 - Open quickui menu
	\\n      F3 - Toggle fullscreen mode
	\\n      INSERT: jk - Exit from Insert Mode and save
	\\n      INSERT: jK - Exit from Insert Mode
	\\n      INSERT: ju - Make current word uppercase
	\\n      INSERT: ji - Make current word lowercase
	\\n      CTRL-a - Move to start of line
	\\n      CTRL-e - Move to end of line
	\\n      CTRL-h - Move screen 10 symbols left
	\\n      CTRL-l - Move screen 10 symbols right
	\\n      LEAD i - Increase number under cursor
	\\n      LEAD x - Substract number under cursor
	\\n      ci_ - Edit word from start to first _
	\\n      LEAD d  - Hide search highlightings
	\\n      s - Delete (d) without copying
	\\n      q - Quit window
	\\n      Q - Quit window without saving
	\\n    Tmux-like keybindings:
	\\n      CTRL-c c - Find file
	\\n      CTRL-c C - Find file in buffer
	\\n      CTRL-c % - Split window horizontally
	\\n      CTRL-c \" - Split window vertically
	\\n      CTRL-c w - Quit from window
	\\n      CTRL-c 0-9 - Jump to tab 0-9
	\\n      \<leader\>S - Toggle scrolloff (see :h 'scrolloff')
	\\n    Emacs-like keybindings:
	\\n      ALT-x - Switch to command mode (:)
	\\n      CTRL-x CTRL-c - Close All windows
	\\n      CTRL-x s - Save current buffer
	\\n      CTRL-x CTRL-s - Save current buffer
	\\n      CTRL-x k - Kill (delete) current buffer
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
	\\n    QUOTES AROUND (deprecated, use surround.vim):
	\\n      LEAD \" - Put \'\"\' around word
	\\n      LEAD \' - Put \"\'\" around word
	\\n  TERMINAL:
	\\n    LEAD tt - Open in a new tab
	\\n    LEAD tb - Open in a new buffer
	\\n    LEAD th - Open in a new horizontal window (-)
	\\n    LEAD tv - Open in a new vertical window (\|)
	\\n    LEAD tf - Open in a new floating window (Floaterm)
	\\n  TELESCOPE plugin:
	\\n    LEAD ff - Find files
	\\n    LEAD fg - Live grep
	\\n    LEAD fb - Buffers
	\\n    LEAD fh - Help tags
	\\n  LSP (deprecated due to coc.nvim):
	\\n    LEAD lv - Start vim-language-server
	\\n    LEAD lb - Start bash-language-server
	\\n    LEAD ld - Dump active clients
	\\n  ABOUT:
	\\n    Author: TwoSpikes (2023 - 2024)
	\\n    Github repository: https://github.com/TwoSpikes/dotfiles
	\"
endfunction
command! -nargs=0 DotfilesCheatSheet call DotfilesCheatSheet()
noremap <silent> <leader>? <cmd>DotfilesCheatSheet<cr>

" FAST COMMANDS
noremap ; :
noremap <silent> <leader>; ;
noremap <silent> <leader>: :<c-f>a
"noremap <leader>= :tabe 
"noremap <leader>- :e 
noremap <leader>= <cmd>echo "use \<c-c\>c"<cr>
noremap <leader>- <cmd>echo "use \<c-c\>C"<cr>
noremap <leader>1 :!
nnoremap <leader>u <cmd>lua require('packer').sync()<cr>

" QUOTES AROUND (DEPRECATED BECAUSE OF surround.vim)
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

" SPECIAL
nnoremap ci_ yiwct_
noremap <silent> <leader>d <cmd>nohlsearch<cr>
nnoremap <silent> <esc> <cmd>let @/ = ""<cr>
tnoremap <c-]> <c-\><esc>

" TERMINAL
function! OpenTerm(cmd)
	if a:cmd ==# ""
		exec printf("terminal %s", $SHELL." -l")
	else
		exec printf("terminal %s", a:cmd)
	endif
	startinsert
	return bufnr()
endfunction
noremap <silent> <leader>tt <cmd>tabnew<cr><cmd>call OpenTerm("")<cr>
noremap <silent> <leader>tb <cmd>call OpenTerm("")<cr>
noremap <silent> <leader>th <cmd>split<cr><cmd>call OpenTerm("")<cr>
noremap <silent> <leader>tv <cmd>vsplit<cr><cmd>call OpenTerm("")<cr>
exec printf("noremap <silent> <leader>tf <cmd>FloatermNew %s -l<cr>", $SHELL)
" noremap <silent> <leader>tct <c-\><c-n>:q\|tabnew\|ter<cr>a

" COLORSCHEME
noremap <silent> <leader>C <cmd>call SelectPosition($VIMRUNTIME."/colors", g:stdpos)<cr>
noremap <silent> <leader>Cy <cmd>set lazyredraw<cr>yy:<c-f>pvf]o0"_dxicolo <esc>$x$x$x$x<cr>jzb<cmd>set nolazyredraw<cr>

noremap <silent> <leader>Cu <cmd>CocUpdate<cr>
noremap <silent> <leader>tu <cmd>TSUpdate<cr>

function! CommentOut(comment_string)
	mark z
	if mode() !~? 'v.*' && mode() !~? "\<c-v>.*"
		return "0i".a:comment_string."\<esc>"
	else
		return "\<c-v>0I".a:comment_string."\<esc>"
	endif
	normal! `z
endfunction
function! CommentOutDefault()
	if exists('g:default_comment_string')
		return CommentOut(g:default_comment_string)
	else
		echohl ErrorMsg
		echo "Comments are not available"
		echohl Normal
	endif
endfunction
function! DoCommentOutDefault()
	exec "normal! ".CommentOutDefault()
endfunction
function! UncommentOut(comment_string)
	mark z
	if mode() !~? 'v.*' && mode() !~? "\<c-v>.*"
		call setline(line("."), substitute(getline(line(".")), "^".a:comment_string, "", ""))
	else
		for l:idx in range(line("'>")-line("'<"))
			let l:line = line("'<") + l:idx
			call setline(l:line, substitute(getline(l:line), "^".a:comment_string, "", ""))
		endfor
	endif
	normal! `z
endfunction
function! UncommentOutDefault()
	if exists('g:default_comment_string')
		call UncommentOut(g:default_comment_string)
	else
		echohl ErrorMsg
		echo "Comments are not available"
		echohl Normal
	endif
endfunction
noremap <expr> <leader>/d CommentOutDefault()
noremap <leader>/u <cmd>call UncommentOutDefault()<cr>
augroup cpp
	au!
	au filetype cpp let g:default_comment_string = "//"
	au filetype cpp noremap <silent> <buffer> <leader>n viwo<esc>i::<esc>hi
augroup END
augroup vim
	au!
	au filetype vim let g:default_comment_string = '"'
augroup END
augroup googol
	au!
	au syntax googol let g:default_comment_string = "//"
augroup END
augroup php
	au!
	au filetype php if exists('g:default_comment_string') | unlet g:default_comment_string | endif
	au filetype php noremap <silent> <buffer> <leader>g viwoviGLOBALS['<esc>ea']<esc>
augroup END
augroup sh
	au!
	au filetype bash,sh let g:default_comment_string = "#"
	au filetype bash,sh setlocal nowrap linebreak
augroup END
augroup python
	au!
	au filetype python let g:default_comment_string = "#"
augroup END
augroup rust
	au!
augroup END
augroup netrw
	au!
	if exists('g:default_comment_string')
		unlet g:default_comment_string
	endif
	au filetype netrw setlocal nocursorcolumn | call Numbertoggle()
augroup END
augroup nerdtree
	if exists('g:default_comment_string')
		unlet g:default_comment_string
	endif
	au filetype nerdtree setlocal nocursorcolumn | call Numbertoggle()
augroup END
augroup terminal
	au!
	if has('nvim')
		au termopen * setlocal nocursorline nocursorcolumn | call STCNo()
	endif
augroup END
augroup visual
	function! HandleBuftype(winnum)
		let filetype = getwinvar(a:winnum, '&filetype', 'ERROR')
		let buftype = getwinvar(a:winnum, '&buftype', 'ERROR')
		let pre_cursorcolumn = (mode() !~# "[vVirco]" && mode() !~# "\<c-v>") && !s:fullscreen && filetype !=# 'netrw' && buftype !=# 'terminal' && filetype !=# 'nerdtree' && buftype !=# 'nofile'
		if exists('g:cursorcolumn')
			let pre_cursorcolumn = pre_cursorcolumn && g:cursorcolumn
		endif
		call setwinvar(a:winnum, '&cursorcolumn', pre_cursorcolumn)
		let pre_cursorline = mode() !~# "[irco]" && !s:fullscreen && buftype !=# 'terminal' && (buftype !=# 'nofile' || filetype ==# 'nerdtree') && filetype !=# 'TelescopePrompt'
		if exists('g:cursorline')
			let pre_cursorline = pre_cursorline && g:cursorline
		endif
		call setwinvar(a:winnum, '&cursorline', pre_cursorline)
	endfunction
	au ModeChanged,BufWinEnter * call HandleBuftype(winnr())
augroup END
function! HandleBuftypeAll()
	tabdo windo call HandleBuftype(winnr())
endfunction

" TELESCOPE
function! FuzzyFind()
	lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({winblend = 0 }))
endfunction
nnoremap <silent> <leader>ff <cmd>call FuzzyFind()<cr>
nnoremap <silent> <leader>fg :lua require'telescope.builtin'.live_grep(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fb :lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fh :lua require'telescope.builtin'.help_tags(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>

noremap <silent> <leader>x <c-x>
noremap <silent> <leader>i <c-i>

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
noremap <silent> <c-x><c-c> <cmd>confirm qall<cr>
noremap <silent> <c-x><c-q> <cmd>qall!<cr>
noremap <silent> <c-x>s <cmd>w<cr>
noremap <silent> <c-x>S <cmd>wall<Bar>echohl MsgArea<Bar>echo 'Saved all buffers'<cr>
noremap <silent> <c-x><c-s> <cmd>w<cr>
function! Killbuffer()
	echohl Question
	if !filereadable(expand('~/.local/share/nvim/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim'))
		let user_input = nr2char(input("do you want to kill the buffer? (Y/n): "))
		echohl Normal
	else
		let choice = quickui#confirm#open('Do you want to kill the buffer?', "&Yes\n&No", 1, 'Confirm')
		if choice ==# 0
			let user_input = 'n'
		elseif choice ==# 1
			let user_input = 'y'
		else
			let user_input = 'n'
		endif
	endif
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
command! -nargs=0 Killbuffer call Killbuffer()
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
function! SelectAll()
	mark y
	normal! ggVG
	echohl MsgArea
	echom 'Previous position marked as "y"'
endfunction
noremap <silent> <c-x>h <cmd>call SelectAll()<cr>
noremap <silent> <c-x><c-h> <cmd>h<cr>
noremap <silent> <c-x><c-g> <cmd>echo "Quit"<cr>

noremap mz <cmd>echohl ErrorMsg<cr><cmd>echom "mz is used for commands"<cr><cmd>echohl Normal<cr>
noremap my <cmd>echohl ErrorMsg<cr><cmd>echom "my is used for commands"<cr><cmd>echohl Normal<cr>

noremap <leader>q q
noremap <leader>Q Q

inoremap <silent> jk <esc>:w<cr>
inoremap <silent> jK <esc>
inoremap <silent> JK <esc>:w<cr>
inoremap <silent> Jk <esc>
" FIXME: Bicycle invented, but problem not solved
" NOTE: temporarily commented out due to above reason
" let g:term_j_was_pressed = v:false
" function! ProcessTBut_j()
" 	if g:term_j_was_pressed ==# v:true
" 		return "j"
" 	else
" 		let g:term_j_was_pressed = v:true
" 		return ""
" 	endif
" endfunction
" tnoremap <nowait> <expr> <silent> j ProcessTBut_j()
" function! ProcessTBut_k()
" 	if g:term_j_was_pressed ==# v:true
" 		let g:term_j_was_pressed = v:false
" 		return "\<c-\>\<c-n>"
" 	else
" 		let g:term_j_was_pressed = v:false
" 		return "k"
" 	endif
" endfunction
" tnoremap <nowait> <expr> <silent> k ProcessTBut_k()
tnoremap <silent> jk <c-\><c-n>
tnoremap <silent> jK <c-\><c-n>:bd!<Bar>tabnew<Bar>call OpenTerm("")<cr>
command! -nargs=* W w <args>

inoremap <silent> ju <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>let &lazyredraw=v:false<cr><cmd>normal! viwUea<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr>
inoremap <silent> ji <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>let &lazyredraw=v:false<cr><cmd>normal! viwuea<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr>

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
	exec printf("luafile %s", g:PLUGINS_INSTALL_FILE_PATH)
	PackerInstall
	exec printf("luafile %s", g:PLUGINS_SETUP_FILE_PATH)
endif

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
noremap <silent> <f9> <cmd>call quickui#menu#open()<cr>

" Interface
function! ChangeVisualBlue()
	echo "Visual changed to "
	echohl Visual
	echon "blue"
	echohl Normal
	call CopyHighlightGroup("VisualBlue", "Visual")
endfunction
command! -nargs=0 ChangeVisualBlue call ChangeVisualBlue()
function! ChangeVisualReversed()
	echo "Visual changed to reversed "
	call CopyHighlightGroup("VisualReversed", "Visual")
endfunction
command! -nargs=0 ChangeVisualReversed call ChangeVisualReversed()
"noremap <leader>iv <cmd>ChangeVisualBlue<cr>
"noremap <leader>iV <cmd>ChangeVisualReversed<cr>

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

au VimResized * call OnResized()|mode
function! OnResized()
	echom "Window: ".&lines."rows, ".&columns."cols"
	call STCUpd()
endfunction

au CursorMoved * call STCUpd()

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

if has('nvim')
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
endif

let g:floaterm_width = 1.0
noremap <leader>z <cmd>call SelectPosition('lazygit', g:termpos)<cr>
noremap <leader>m <cmd>call SelectPosition(g:far_or_mc, g:termpos)<cr>

augroup xdg_open
	autocmd!
	function! OpenWithXdg(filename)
		if !filereadable(expand('~/.local/share/nvim/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim'))
			echohl Question
			echon 'Open with xdg-open (y/N): '
			echohl Normal
			let choice = nr2char(getchar())
		else
			let choice = quickui#confirm#open('Open with xdg-open?', "&OK\n&Cancel", 1, 'Confirm')
			if choice ==# 1
				let choice = 'y'
			elseif choice ==# 2
				let choice = 'n'
			else
				let choice = 'n'
			endif
		endif
		if choice ==# 'y'
		\&&executable('xdg-open') ==# 1
			exec "!xdg-open -- ".a:filename
		endif
	endfunction
	autocmd BufEnter *.jpg,*.png,*.jpeg,*.bmp call OpenWithXdg(expand('%'))
augroup END

function! TermuxSaveCursorStyle()
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
	elseif $TERMUX_VERSION
		let g:termux_cursor_style = 'bar'
	endif
endfunction
function! TermuxLoadCursorStyle()
	if $TERMUX_VERSION !=# "" && filereadable(expand("~/.termux/termux.properties")) && exists("g:termux_cursor_style")
		if g:termux_cursor_style ==# 'block'
			let &guicursor = 'a:block'
		elseif g:termux_cursor_style ==# 'bar'
			let &guicursor = 'a:ver25'
		elseif g:termux_cursor_style ==# 'underline'
			let &guicursor = 'a:hor25'
		endif
	endif
endfunction

function! OpenOnStart()
	if exists('g:open_menu_on_start')
		if g:open_menu_on_start ==# v:true
			call ChangeNames()
			call RebindMenus()
			call quickui#menu#open()
			echo quickui#menu#section('&File')
		endif
	endif

	set nolazyredraw
	echo 'type '
	echohl SpecialKey
	echon ':intro<cr>'
	echohl Normal
	echon ' to see help'
	echohl Normal

	if expand('%') == ''
		let open = v:false
		if exists('g:DO_NOT_OPEN_ANYTHING')
			let open = !g:DO_NOT_OPEN_ANYTHING
		else
			let open = v:false
		endif
		if open
			let open = ""
			if exists('g:open_ranger_on_start')
				if g:open_ranger_on_start
					let open = "ranger"
				else
					let open = "explorer"
				endif
			else
				let open = "explorer"
			endif

			if open ==# "explorer"
			\||executable('ranger') !=# 1
				edit ./
			elseif open ==# "ranger"
				let TMPFILE = trim(system(["mktemp", "-u"]))
				let g:bufnrforranger = OpenTerm("ranger --choosefile=".TMPFILE)
				call delete(TMPFILE)
				augroup oncloseranger
					autocmd! oncloseranger
					exec 'autocmd TermClose * let filename=system("cat '.TMPFILE.'")|if bufnr()==#'.g:bufnrforranger."|if filereadable(filename)==#1|bdelete|exec 'edit '.filename|call Numbertoggle()|filetype detect|call AfterSomeEvent(\"ModeChanged\", \"doautocmd BufEnter \".expand(\"%\"))|else|call IfOneWinDo(\"call OnQuit()\")|quit|endif|unlet g:bufnrforranger|endif|unlet filename"
					exec "autocmd BufWinLeave * let f=expand(\"<afile>\")|let n=bufnr(\"^\".f.\"$\")|if n==#".g:bufnrforranger."|unlet f|unlet n|au!oncloseranger|call AfterSomeEvent(\"BufEnter,BufLeave,WinEnter,WinLeave\", \"".g:bufnrforranger."bw!\")|endif"
				augroup END
				unlet TMPFILE
			endif
		endif
	endif
endfunction

function! PrepareWhichKey()
	let g:which_key_timeout = 100
	if filereadable(expand('~/.local/share/nvim/site/pack/packer/start/which-key.nvim/lua/which-key/util.lua'))
		let l:old_lazyredraw=&lazyredraw
		let &lazyredraw = v:true
		edit ~/.local/share/nvim/site/pack/packer/start/which-key.nvim/lua/which-key/util.lua
		if getline(189) =~# 'if not ("nvsxoiRct"):find(mode) then'
			silent 189,192delete
			silent write
		endif
		bwipeout!
		let &lazyredraw = l:old_lazyredraw
	endif
	nnoremap <silent> <leader> <cmd>lua require('which-key').show(vim.g.mapleader)<cr>
endfunction

function! OnStart()
	call PrepareVital()
	call MakeThingsThatRequireBeDoneAfterPluginsLoaded()
	call TermuxSaveCursorStyle()
	call PrepareWhichKey()
	call OpenOnStart()
	Showtab
	so ~/xterm-color-table.vim
	call STCUpd()
endfunction
function! OnQuit()
	call TermuxLoadCursorStyle()
endfunction
function! IfOneWinDo(cmd)
	let s = 0
	tabdo let s += winnr('$')
	if s==# 1
		exec a:cmd
	endif
endfunction

au! VimEnter * call OnStart()
au! VimLeave * call OnQuit()
