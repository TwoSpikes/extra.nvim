#!/bin/env -S nvim -u

if has('nvim')
	lua vim.loader.enable()
endif

set lazyredraw

if !has('nvim')
	set nocompatible
endif

function! SetDotfilesConfigPath()
	if !exists('g:DOTFILES_CONFIG_PATH') || g:DOTFILES_CONFIG_PATH ==# ""
		if !exists('$DOTFILES_VIM_CONFIG_PATH')
			let g:DOTFILES_CONFIG_PATH = "$HOME/.config/dotfiles/vim/config.json"
		else
			let g:DOTFILES_CONFIG_PATH = $DOTFILES_VIM_CONFIG_PATH
		endif
		let g:DOTFILES_CONFIG_PATH = expand(g:DOTFILES_CONFIG_PATH)
	endif
endfunction
call SetDotfilesConfigPath()

function! LoadDotfilesConfig(path, reload=v:false)
	if !filereadable(a:path)
		echohl ErrorMsg
		if g:language ==# 'russian'
			echom "блядь: dotfiles vim конфиг не найден"
		else
			echom "error: no dotfiles vim config"
		endif
		echohl Normal
		return 1
	endif
	let l:dotfiles_config_str = join(readfile(a:path, ''), '')
	silent execute "let g:dotfiles_config = json_decode(l:dotfiles_config_str)"
	if type(g:dotfiles_config) !=# v:t_dict
		echohl ErrorMsg
		if g:language ==# 'russian'
			echom "блядь: не удалось распарсить dotfiles vim конфиг"
		else
			echom "error: failed to parse dotfiles vim config"
		endif
		echohl Normal
		return 1
	endif

	let l:option_list = [
		\'setup_lsp',
		\'use_transparent_bg',
		\'background',
		\'use_italic_style',
		\'cursorcolumn',
		\'cursorline',
		\'cursorline_style',
		\'linenr',
		\'linenr_style',
		\'open_menu_on_start',
		\'quickui_border_style',
		\'quickui_color_scheme',
		\'open_on_start',
		\'use_github_copilot',
		\'pad_amount_confirm_dialogue',
		\'cursor_style',
		\'showtabline',
		\'tabline_path',
		\'tabline_spacing',
		\'tabline_modified',
		\'tabline_icons',
		\'tabline_pressable',
		\'enable_mouse',
		\'mouse_focus',
		\'use_nvim_cmp',
		\'enable_fortune',
		\'quickui_icons',
		\'language',
		\'fast_terminal',
		\'enable_which_key',
		\'compatible',
	\]
	for option in l:option_list
		if exists('g:dotfiles_config["'.option.'"]')
			if !exists("g:".option) || a:reload
				exec "let g:".option." = g:dotfiles_config[option]"
			endif
		endif
	endfor
endfunction

call LoadDotfilesConfig(g:DOTFILES_CONFIG_PATH)

function! SetConfigPath()
	if !exists('g:CONFIG_PATH') || g:CONFIG_PATH ==# ""
		if !exists('$VIM_CONFIG_PATH')
			let g:CONFIG_PATH = "$HOME/.config/nvim"
		else
			let g:CONFIG_PATH = $VIM_CONFIG_PATH
		endif
	endif
endfunction
call SetConfigPath()

colorscheme blueorange
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

if has('nvim')
	augroup LineNrForInactive
		function! s:SaveStc(clear_stc, winnr=winnr())
			exec printf("let g:stc_was_%d = &l:stc", win_getid(a:winnr))
			if a:clear_stc
				call setwinvar(a:winnr, '&stc', '')
			endif
		endfunction
		au! WinLeave * call s:SaveStc(v:true)
		function! s:LoadStc(winnr=winnr())
			if exists("g:stc_was_"..win_getid(a:winnr))==#1
				call setwinvar(a:winnr, '&stc', eval("g:stc_was_"..win_getid(a:winnr)))
			else
				call setwinvar(a:winnr, '&stc', '')
			endif
		endfunction
		au! WinEnter * call s:LoadStc()
	augroup END
endif

function! STCRel(winnr=winnr())
	if has('nvim')
		if mode() =~? 'v.*' || mode() ==# "\<c-v>"
			call setwinvar(a:winnr, '&stc', '%#CursorLineNrVisu#%{%v:relnum?"%#LineNrVisu#":((v:virtnum <= 0)?v:lnum:"")%}%=%{v:relnum?((v:virtnum <= 0)?v:relnum:""):""} ')
			call CopyHighlightGroup("StatementVisu", "Statement")
			return
		endif
		call setwinvar(a:winnr, '&stc', '%#CursorLineNr#%{%v:relnum?"%#LineNr#":((v:virtnum <= 0)?v:lnum:"")%}%=%{v:relnum?((v:virtnum <= 0)?v:relnum:""):""} ')
		call CopyHighlightGroup("StatementNorm", "Statement")
		call s:SaveStc(v:false)
	else
		call setwinvar(a:winnr, '&number', v:true)
		call setwinvar(a:winnr, '&relativenumber', v:true)
	endif
endfunction
function! STCAbs(actual_mode, winnr=winnr())
	if has('nvim')
		if a:actual_mode ==# '' || a:actual_mode =~? 'n'
			call setwinvar(a:winnr, '&stc', '%{%v:relnum?"":"%#CursorLineNr#".((v:virtnum <= 0)?Pad(v:lnum,len(line("$"))+&foldcolumn):"")%}%{%v:relnum?"%#LineNr#%=".((v:virtnum <= 0)?v:lnum:""):""%} ')
			call CopyHighlightGroup("StatementNorm", "Statement")
			return
		endif
		if a:actual_mode =~? 'r'
			call setwinvar(a:winnr, '&stc', '%{%v:relnum?"":"%#CursorLineNrRepl#".Pad((v:virtnum <= 0)?v:lnum:"",len(line("$"))+&foldcolumn)%}%{%v:relnum?"%#LineNrIns#%=".((v:virtnum <= 0)?v:lnum:""):""%} ')
			return
		endif
		if a:actual_mode =~? 'v' && getwinvar(a:winnr, '&modifiable')
			call setwinvar(a:winnr, '&stc', '%{%v:relnum?"":"%#CursorLineNrVisu#".((v:virtnum <= 0)?Pad(v:lnum,len(line("$"))+&foldcolumn):"")%}%{%v:relnum?"%#LineNrVisu#%=".((v:virtnum <= 0)?v:lnum:""):""%} ')
			return
		endif
		call setwinvar(a:winnr, '&stc', '%{%v:relnum?"":"%#CursorLineNrIns#".Pad((v:virtnum <= 0)?v:lnum:"", len(line("$"))+&foldcolumn)%}%{%v:relnum?"%#LineNrIns#%=".((v:virtnum <= 0)?v:lnum:""):""%} ')
		call CopyHighlightGroup("StatementIns", "Statement")
	else
		call setwinvar(a:winnr, '&number', v:true)
		call setwinvar(a:winnr, '&relativenumber', v:false)
	endif
endfunction
function! STCNo(winnr=winnr())
	if has('nvim')
		call setwinvar(a:winnr, '&stc', '')
	endif
	setlocal nonu nornu
	call setwinvar(a:winnr, '&number', v:false)
	call setwinvar(a:winnr, '&relativenumber', v:false)
endfunction
function! STCNoAll()
	tabdo windo call STCNo(winnr())
endfunction

function! Numbertoggle_stcabs(mode='', winnr=winnr())
	if &modifiable && &buftype !=# 'terminal' && &buftype !=# 'nofile' && &filetype !=# 'netrw' && &filetype !=# 'neo-tree' && &filetype !=# 'TelescopePrompt' && &filetype !=# 'packer' && &filetype !=# 'spectre_panel' && &filetype !=# 'alpha' && g:linenr
		call STCAbs(a:mode, a:winnr)
	else
		call STCNo(a:winnr)
	endif
endfunction	
function! Numbertoggle_stcrel(winnr)
	if &modifiable && &buftype !=# 'terminal' && &buftype !=# 'nofile' && &filetype !=# 'netrw' && &filetype !=# 'neo-tree' && &filetype !=# 'TelescopePrompt' && &filetype !=# 'packer' && &filetype !=# 'spectre_panel' && &filetype !=# 'alpha' && g:linenr
		call STCRel(a:winnr)
	else
		call STCNo(a:winnr)
	endif
endfunction
function! Numbertoggle(mode='', winnr=winnr())
	if a:mode =~? 'i' || a:mode =~? 'r' || g:linenr_style ==# 'absolute'
		call Numbertoggle_stcabs(a:mode, a:winnr)
	else
		call Numbertoggle_stcrel(a:winnr)
	endif
endfunction
function! NumbertoggleAll(mode='')
	tabdo windo call Numbertoggle(a:mode, winnr())
endfunction
function! Numbertoggle_no()
	if has('nvim')
		set stc=
	endif
	set nonu nornu
endfunction

function! PreserveAndDo(cmd, preserve_tab, preserve_win)
	if a:preserve_tab
		let old_tabpagenr = tabpagenr()
	endif
	if a:preserve_win
		let old_winnr = winnr()
	endif
	exec a:cmd
	if a:preserve_tab
		exec old_tabpagenr 'tabnext'
	endif
	if a:preserve_win
		exec old_winnr 'wincmd w'
	endif
endfunction

function! DefineAugroupVisual()
	augroup Visual
		autocmd!
		if g:linenr
			exec "autocmd! ModeChanged {\<c-v>*,[vV]*}:* call Numbertoggle(mode())"
			exec "autocmd! ModeChanged *:{\<c-v>*,[vV]*} call Numbertoggle('v')"
		else
			autocmd! Visual
		endif
	augroup END
endfunction
function! DefineAugroupNumbertoggle()
	augroup numbertoggle
		autocmd!
		if g:linenr
			autocmd InsertLeave * call Numbertoggle('')
			autocmd InsertEnter * call Numbertoggle(v:insertmode)
			autocmd BufReadPost,BufEnter,BufLeave,WinLeave,WinEnter * call Numbertoggle()
			autocmd FileType packer,spectre_panel,man call Numbertoggle()|call HandleBuftype(winnr())
		else
			autocmd! numbertoggle
		endif
	augroup END
endfunction

augroup UnfocusFiletype
	autocmd!
	autocmd BufWinEnter * if &filetype==#'notify'|wincmd p|endif
augroup END

function! UpdateShowtabline()
	let &showtabline = g:showtabline
endfunction

function! DefineAugroups()
	call DefineAugroupVisual()
	call DefineAugroupNumbertoggle()
endfunction
function! SetDefaultValuesForStartupOptionsAndDotfilesConfigOptions()
	" Default values for startup options
	if !exists('g:PAGER_MODE')
		let g:PAGER_MODE = v:false
	endif
	if !exists('g:DO_NOT_OPEN_ANYTHING')
		let g:DO_NOT_OPEN_ANYTHING = v:false
	endif

	" Default values for options
	if !exists('g:use_transparent_bg')
		let g:use_transparent_bg = "dark"
	endif
	if !exists('g:cursorcolumn')
		let g:cursorcolumn = v:false
	endif
	if !exists('g:cursorline')
		let g:cursorline = v:true
	endif
	if !exists('g:cursorline_style')
		let g:cursorline_style = "dim"
	endif
	if !exists('g:linenr')
		let g:linenr = v:true
	endif
	if !exists('g:linenr_style')
		let g:linenr_style = v:true
	endif
	if !exists('g:background')
		let g:background = "dark"
	endif
	if !exists('g:pad_amount_confirm_dialogue')
		let g:pad_amount_confirm_dialogue = 30
	endif
	if !exists('g:cursor_style')
		let g:cursor_style = "block"
	endif
	if !exists('g:showtabline')
		let g:showtabline = 2
	endif
	if !exists('g:tabline_path')
		let g:tabline_path = "name"
	endif
	if !exists('g:tabline_spacing')
		let g:tabline_spacing = "transition"
	endif
	if !exists('g:tabline_modified')
		let g:tabline_modified = v:true
	endif
	if !exists('g:tabline_icons')
		let g:tabline_icons = v:true
	endif
	if !exists('g:tabline_pressable')
		let g:tabline_icons = v:true
	endif
	if !exists('g:enable_mouse')
		let g:enable_mouse = v:true
	endif
	if !exists('g:mouse_focus')
		let g:mouse_focus = v:true
	endif
	if !exists('g:use_nvim_cmp')
		let g:use_nvim_cmp = v:false
	endif
	if !exists('g:enable_fortune')
		let g:enable_fortune = v:false
	endif
	if !exists('g:quickui_icons')
		let g:quickui_icons = v:true
	endif
	if !exists('g:language')
		let g:language = 'auto'
	endif
	if !exists('g:fast_terminal')
		let g:fast_terminal = v:false
	endif
	if !exists('g:enable_which_key')
		let g:enable_which_key = v:true
	endif
	if !exists('g:compatible')
		let g:compatible = "no"
	endif
endfunction
call SetDefaultValuesForStartupOptionsAndDotfilesConfigOptions()

function! HandleDotfilesConfig()
	if g:background ==# "dark"
		set background=dark
	elseif g:background ==# "light"
		set background=light
	else
		echohl ErrorMsg
		if g:language ==# 'russian'
			echom "Dotfiles vim конфиг: блядь: неправильное значение заднего фона: ".g:background
		else
			echom "Dotfiles vim config: Error: wrong background value: ".g:background
		endif
		echohl Normal

		let g:background = "dark"
		set background=dark
	endif

	call DefineAugroups()
	if !g:linenr
		call STCNo()
	else
		call Numbertoggle()
	endif

	call UpdateShowtabline()

	if g:language ==# 'auto'
		if $LANG ==# 'ru_RU.UTF-8' || $TERMUX_LANG ==# 'ru_RU.UTF-8'
			let g:language = 'russian'
		else
			let g:language = 'english'
		endif
	endif
endfunction
call HandleDotfilesConfig()

let mapleader = " "

function! SetLocalSharePath()
	if !exists('g:LOCALSHAREPATH') || g:LOCALSHAREPATH ==# ''
		if !exists('$VIM_LOCALSHAREPATH')
			if has('nvim')
				let g:LOCALSHAREPATH = '~/.local/share/nvim'
			else
				let g:LOCALSHAREPATH = '~/.local/share/vim'
			endif
			let g:LOCALSHAREPATH = expand(g:LOCALSHAREPATH)
		else
			let g:LOCALSHAREPATH = $VIM_LOCALSHAREPATH
		endif
	endif
endfunction
call SetLocalSharePath()

if exists('g:CONFIG_ALREADY_LOADED')
	if g:CONFIG_ALREADY_LOADED
		call HandleBuftypeAll()
	endif
endif
let g:CONFIG_ALREADY_LOADED = v:true

if $PREFIX == ""
	call setenv('PREFIX', '/usr/')
endif


" Random options
set termguicolors
set encoding=utf-8
set helpheight=10
set splitbelow
set splitkeep=cursor
set nosplitright
set scrolloff=3
set notildeop
set errorfile=errors.err
set eventignore=
set noexrc
set fillchars=
set fixendofline
set cmdheight=1
set smoothscroll

" Bell signal options
set novisualbell
set belloff=all
set errorbells

" Search options
set nogdefault
set ignorecase
set smartcase
set incsearch
set magic

" Fold options
set foldclose=all
set foldenable
set foldexpr=0
set foldignore=#
set foldlevel=0
set foldmarker={{{,}}}
set foldmethod=marker
set foldnestmax=15
set foldcolumn=0

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

function! PrepareVital()
	let g:VitalModule#Random = vital#vital#import('Random')
endfunction
function! GetRandomName(length)
	let name = "Rnd_"
	for _ in range(a:length)
		if has('nvim')
			let r = g:VitalModule#Random.range(1, 4)
		else
			let r = rand() % 3 + 1
		endif
		if r ==# 1
			if has('nvim')
				let name .= nr2char(g:VitalModule#Random.range(48, 58))
			else
				let name .= nr2char(rand() % 10 + 48)
			endif
		elseif r ==# 2
			if has('nvim')
				let name .= nr2char(g:VitalModule#Random.range(65, 91))
			else
				let name .= nr2char(rand() % 26 + 65)
			endif
		elseif r ==# 3
			if has('nvim')
				let name .= nr2char(g:VitalModule#Random.range(97, 123))
			else
				let name .= nr2char(rand() % 26 + 97)
			endif
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
let g:please_do_not_close = v:false
function! MakeThingsThatRequireBeDoneAfterPluginsLoaded()
	au TermClose * if !g:please_do_not_close && !exists('g:bufnrforranger')|call IfOneWinDo("call OnQuit()")|call AfterSomeEvent('TermLeave', 'call Numbertoggle()')|quit|endif
endfunction

set nonu
set nornu
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

" Menus options
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
	if g:compatible !=# "helix_hard"
		let stl_name = '%<%t'
		let stl_name .= '%( %* %#StatusLinemod#%M%R%H%W%)%*'
	else
		let stl_name = '%* %<%t'
		let stl_name .= '%( %#StatusLinemod#%M%R%H%W%)%*'
	endif
	if g:compatible !=# "helix_hard"
		if &columns ># 40
			let stl_name .= '%( %#StatusLinemod#'
			let stl_name .= &syntax
			let stl_name .= '%)%*'
		endif
	endif
	if g:compatible !=# "helix_hard"
		if &columns ># 45
			let stl_name .= '%( %#Statuslinemod#'
			let stl_name .= '%{GetGitBranch()}'
			let stl_name .= '%)%*'
		endif
	endif
	let mode = mode('lololol')
	let strmode = ''
	if mode == 'n'
		if g:compatible !=# "helix" && g:compatible !=# "helix_hard"
			let strmode = '%#ModeNorm# '
		else
			if g:language ==# 'russian'
				let strmode = '%#ModeNorm# НОР '
			else
				let strmode = '%#ModeNorm# NOR '
			endif
		endif
	elseif mode == 'no'
		if g:language ==# 'russian'
			let strmode = 'ЖДУ_ОПЕР '
		else
			let strmode = 'OP_PEND '
		endif
	elseif mode == 'nov'
		if g:language ==# 'russian'
			let strmode = 'визуал ЖДУ_ОПЕР '
		else
			let strmode = 'visu OP_PEND '
		endif
	elseif mode == 'noV'
		if g:language ==# 'russian'
			let strmode = 'виз_лин ЖДУ_ОПЕР '
		else
			let strmode = 'vis_line OP_PEND '
		endif
	elseif mode == 'noCTRL-v'
		if g:language ==# 'russian'
			let strmode = 'виз_блок ЖДУ_ОПЕР '
		else
			let strmode = 'vis_block OP_PEND '
		endif
	elseif mode == 'niI'
		if g:language ==# 'russian'
			let strmode = '^o ВСТ '
		else
			let strmode = '^o INS '
		endif
	elseif mode == 'niR'
		if g:language ==# 'russian'
			let strmode = '^o ЗАМЕНА '
		else
			let strmode = '^o REPL '
		endif
	elseif mode == 'niV'
		if g:language ==# 'russian'
			let strmode = '^o визуал ЗАМЕНА '
		else
			let strmode = '^o visu REPL '
		endif
	elseif mode == 'nt'
		if g:language ==# 'russian'
			let strmode = '%#ModeNorm# НОРМ %#StatuslinestatNormTerm#%#ModeTerm# '
		else
			let strmode = '%#ModeNorm# NORM %#StatuslinestatNormTerm#%#ModeTerm# '
		endif
	elseif mode == 'ntT'
		if g:language ==# 'russian'
			let strmode = '^\^o норм ТЕРМ '
		else
			let strmode = '^\^o norm TERM '
		endif
	elseif mode == 'v'
		if g:compatible !=# "helix" && g:compatible !=# "helix_hard"
			let strmode = '%#ModeVisu# '
		else
			if g:pseudo_visual
				if g:compatible !=# "helix_hard"
					if g:language ==# 'russian'
						let strmode = '%#ModeVisu# НОР '
					else
						let strmode = '%#ModeVisu# NOR '
					endif
				else
					if g:language ==# 'russian'
						let strmode = '%#ModeNorm# НОР '
					else
						let strmode = '%#ModeNorm# NOR '
					endif
				endif
			else
				if g:language ==# 'russian'
					let strmode = '%#ModeVisu# ВЫБ '
				else
					let strmode = '%#ModeVisu# SEL '
				endif
			endif
		endif
	elseif mode == 'V'
		if g:language ==# 'russian'
			let strmode = 'ВИЗ_ЛИНИЯ '
		else
			let strmode = 'VIS_LINE '
		endif
	elseif mode == 'vs'
		if g:language ==# 'russian'
			let strmode = '^o визуал ВЫБ '
		else
			let strmode = '^o visu SEL '
		endif
	elseif mode == 'CTRL-V'
		if g:language ==# 'russian'
			let strmode = 'ВИЗ_БЛОК '
		else
			let strmode = 'VIS_BLOCK '
		endif
	elseif mode == 'CTRL-Vs'
		if g:language ==# 'russian'
			let strmode = '^o виз_блок ВЫБ '
		else
			let strmode = '^o vis_block SEL '
		endif
	elseif mode == 's'
		if g:language ==# 'russian'
			let strmode = 'ВЫБ '
		else
			let strmode = 'SEL '
		endif
	elseif mode == 'S'
		if g:language ==# 'russian'
			let strmode = 'ВЫБ ЛИНИЯ'
		else
			let strmode = 'SEL LINE '
		endif
	elseif mode == 'CTRL-S'
		if g:language ==# 'russian'
			let strmode = 'ВЫБ БЛОК '
		else
			let strmode = 'SEL BLOCK '
		endif
	elseif mode == 'i'
		if g:compatible !=# "helix" && g:compatible !=# "helix_hard"
			let strmode = '%#ModeIns# '
		else
			if g:language ==# 'russian'
				let strmode = '%#ModeIns# ВСТ '
			else
				let strmode = '%#ModeIns# INS '
			endif
		endif
	elseif mode == 'ic'
		if g:language ==# 'russian'
			let strmode = 'дополн ВСТ '
		else
			let strmode = 'compl INS '
		endif
	elseif mode == 'ix'
		if g:language ==# 'russian'
			let strmode = '%#ModeCom#^x дополн%#ModeIns#ВСТ '
		else
			let strmode = '%#ModeCom#^x compl%#ModeIns#INS '
		endif
	elseif mode == 'R'
		let strmode = '%#ModeRepl# '
	elseif mode == 'Rc'
		if g:language ==# 'russian'
			let strmode = 'дополн ЗАМЕНА '
		else
			let strmode = 'compl REPL '
		endif
	elseif mode == 'Rx'
		let strmode = '^x compl REPL '
	elseif mode == 'Rv'
		if g:language ==# 'russian'
			let strmode = '%#ModeIns#визуал%*%#ModeRepl#ЗАМЕНА '
		else
			let strmode = '%#ModeIns#visu%*%#ModeRepl#REPL '
		endif
	elseif mode == 'Rvc'
		let strmode = 'compl visu REPL '
	elseif mode == 'Rvx'
		let strmode = '^x compl visu REPL '
	elseif mode == 'c'
		if s:specmode == 'b'
			if g:language ==# 'russian'
				let strmode = 'КОМ_БЛОК '
			else
				let strmode = 'COM_BLOCK '
			endif
		else
			if g:compatible !=# "helix" && g:compatible !=# "helix_hard"
				let strmode = '%#ModeCom# '
			else
				if g:language ==# 'russian'
					let strmode = '%#ModeCom# КОМ '
				else
					let strmode = '%#ModeCom# COM '
				endif
			endif
		endif
	elseif mode == 'cv'
		if g:language ==# 'russian'
			let strmode = 'EX '
		else
			let strmode = 'EX '
		endif
	elseif mode == 'r'
		if g:language ==# 'russian'
			let strmode = 'НАЖ_ВОЗВР '
		else
			let strmode = 'HIT_RET '
		endif
	elseif mode == 'rm'
		if g:language ==# 'russian'
			let strmode = 'ДАЛЕЕ '
		else
			let strmode = 'MORE '
		endif
	elseif mode == 'r?'
		if g:language ==# 'russian'
			let strmode = 'ПОДТВЕРД '
		else
			let strmode = 'CONFIRM '
		endif
	elseif mode == '!'
		if g:language ==# 'russian'
			let strmode = 'ОБОЛОЧ '
		else
			let strmode = 'SHELL '
		endif
	elseif mode == 't'
		let strmode = '%#ModeTerm# '
	else
		if g:language ==# 'russian'
			if g:compatible !=# "helix" && g:compatible !=# "helix_hard"
				let strmode = '%#ModeVisu#визуал %#StatuslinestatVisuBlock#%#ModeBlock# БЛОК '
			else
				if g:pseudo_visual
					let strmode = '%#ModeVisu#нор %#StatuslinestatVisuBlock#%#ModeBlock# БЛОК '
				else
					let strmode = '%#ModeVisu#виз %#StatuslinestatVisuBlock#%#ModeBlock# БЛОК '
				endif
			endif
		else
			let strmode = '%#ModeVisu#visu %#StatuslinestatVisuBlock#%#ModeBlock# BLOCK '
		endif
	endif
	"let stl_time = '%{strftime("%b,%d %H:%M:%S")}'
	
	let stl_pos = ''
	let stl_pos .= '%l:%c'
	if &columns ># 35
		let stl_pos .= ' %LL'
	endif

	let stl_showcmd = '%(%#Statuslinemod#%S%*%)'
	if g:compatible !=# "helix_hard"
		let stl_buf = '#%n %p%%'
	endif
	let stl_mode_to_put = ''
	if &columns ># 20
		let stl_mode_to_put .= strmode
		let stl_mode_to_put .= s:custom_mode?' '.s:custom_mode:''
		let stl_mode_to_put .= ''
	endif

	let s:result = stl_mode_to_put
	let s:result .= stl_name
	if g:compatible !=# "helix_hard"
		if &columns ># 30
			let &showcmdloc = 'statusline'
			let s:result .= ' '
			let s:result .= stl_showcmd
		else
			let &showcmdloc = 'last'
		endif
	endif
	let s:result .= '%='
	if &columns ># 45
		if g:compatible !=# "helix_hard"
			let s:result .= '%#Statuslinestat01#'
			let s:result .= ''
			let s:result .= '%#Statuslinestat1#'
		endif
		let s:result .= ' '
	endif
	if &columns ># 30
		let s:result .= stl_pos
	endif
	if g:compatible !=# "helix_hard"
		if &columns ># 45
			let s:result .= ' '
		endif
		if &columns ># 45
			let s:result .= '%#Statuslinestat12#'
			let s:result .= ''
		endif
	endif
	if &columns ># 30
		if g:compatible !=# "helix_hard"
				let s:result .= '%#Statuslinestat2# '
				let s:result .= stl_buf
		endif
		let s:result .= ' '
	endif
	return s:result
endfunction
command! -nargs=0 Showtab set stl=%{%Showtab()%}

command! -nargs=* Pkg !pkg <args>
function! DotfilesCommit()
	!dotfiles commit --only-copy
	cd ~/dotfiles
	Git commit --all --verbose
endfunction
command! -nargs=0 DotfilesCommit call DotfilesCommit()

function! GenerateDotfilesConfig()
	tabnew
	call OpenTerm('dotfiles setup dotfiles vim')
endfunction
command! -nargs=0 GenerateDotfilesConfig call GenerateDotfilesConfig()
nnoremap <leader>G <cmd>GenerateDotfilesConfig<cr>

function! MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let original_buf_name = bufname(buflist[winnr - 1])
	let bufnr = bufnr(original_buf_name)
	if getbufvar(bufnr, '&buftype') ==# "terminal"
		if g:language ==# 'russian'
			let buf_name = '[Терм]'
		else
			let buf_name = '[Term]'
		endif
	elseif original_buf_name == ''
		if g:language ==# 'russian'
			let buf_name = '[БезИмени]'
		else
			let buf_name = '[NoName]'
		endif
	else
		let buf_name = original_buf_name
	endif
	if g:tabline_path ==# "name"
		return fnamemodify(buf_name, ':t')
	elseif g:tabline_path ==# "short"
		return fnamemodify(buf_name, ':~:.')
	elseif g:tabline_path ==# "shortdir"
		return fnamemodify(buf_name, ':~:.:gs?\([^/]\)[^/]*/?\1/?')
	elseif g:tabline_path ==# "full"
		return fnamemodify(buf_name, ':p')
	endif
endfunction
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    elseif (i - tabpagenr()) % 2 == 0
		let s ..= '%#TabLine#'
	elseif i !=# tabpagenr('$') - 1
		let s ..= '%#TabLineSec#'
    endif

	if g:tabline_pressable
		" set the tab page number (for mouse clicks)
		let s ..= '%' .. (i + 1) .. 'T'
	endif

	if g:tabline_spacing ==# 'full'
		let s ..= ' '
	elseif g:tabline_spacing ==# 'partial'
		if i !=# tabpagenr()
			let s ..= ' '
		endif
	elseif g:tabline_spacing ==# 'transition'
		if i ==# tabpagenr()
			let s ..= '%#TabLineFromSel#'
		elseif i !=# 0 && i !=# tabpagenr() - 1 && (i - tabpagenr() - 1) % 2 ==# 0
			let s ..= '%#TabLineToSec#'
		endif
		let s ..= ' '
	endif

    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    elseif (i - tabpagenr()) % 2 == 0
		let s ..= '%#TabLine#'
	else
		let s ..= '%#TabLineSec#'
    endif
	let bufnr = tabpagebuflist(i + 1)[tabpagewinnr(i + 1) - 1]
	let bufname = bufname(bufnr)

	if g:tabline_icons
		if v:false
		elseif getbufvar(bufnr, '&buftype') ==# 'terminal'
			let s ..= ' '
		elseif v:false
		\||isdirectory(bufname)
		\||getbufvar(bufnr, '&filetype') ==# 'neo-tree'
			let s ..= ' '
		elseif fnamemodify(bufname, ':t') ==# 'LICENSE'
			let s ..= ' '
		elseif v:false
		\||getbufvar(bufnr, '&filetype') ==# ''
		\||getbufvar(bufnr, '&filetype') ==# 'text'
			let s ..= '󰈙 '
		elseif getbufvar(bufnr, '&filetype') ==# 'python'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'c'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'cpp'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'vim'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'lua'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'cs'
			let s ..= '󰌛 '
		elseif getbufvar(bufnr, '&filetype') ==# 'sh'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'bash'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'rust'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'java'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'scala'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'kotlin'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'ruby'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'ocaml'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'r'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'javascript'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'typescript'
			let s ..= '󰛦 '
		elseif v:false
		\||getbufvar(bufnr, '&filetype') ==# 'javascriptreact'
		\||getbufvar(bufnr, '&filetype') ==# 'typescriptreact'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'perl'
			let s ..= ' '
		elseif v:false
		\||getbufvar(bufnr, '&filetype') ==# 'jproperties'
		\||getbufvar(bufnr, '&filetype') ==# 'conf'
		\||getbufvar(bufnr, '&filetype') ==# 'toml'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'json'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'html'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'css'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'sass'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'd'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'asm'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'r'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'go'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'fortran'
			let s ..= '󱈚 '
		elseif getbufvar(bufnr, '&filetype') ==# 'swift'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'php'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'dart'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'haskell'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'julia'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'gitcommit'
			let s ..= ' '
		elseif getbufvar(bufnr, '&filetype') ==# 'markdown'
			let s ..= ' '
		endif
	endif

    " the label is made by MyTabLabel()
    let s ..= '%{MyTabLabel(' .. (i + 1) .. ')}'

	if g:tabline_modified
		if getbufvar(bufnr, '&modified')
			let s ..= ' ●'
		endif
	endif
	
	if g:tabline_spacing ==# 'full'
		let s ..= ' '
	elseif g:tabline_spacing ==# 'partial'
		if i !=# tabpagenr() - 2
			let s ..= ' '
		endif
	elseif g:tabline_spacing ==# 'transition'
		let s ..= ' '
		if i ==# tabpagenr() - 2
			let s ..= '%#TabLineToSel#'
		elseif i !=# tabpagenr('$') - 1 && i !=# tabpagenr() - 1 && (i - tabpagenr()) % 2 !=# 0
			let s ..= '%#TabLineFromSec#'
		endif
	endif
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'

	" let s ..= '%=%#TabLine#%999Xclose'

  return s
endfunction
if g:compatible !=# "helix_hard"
	set tabline=%!MyTabLine()
endif

" Edit options
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

" Mappings and functions options
set matchpairs=(:),{:},[:],<:>
set noshowmatch
set matchtime=2
set maxfuncdepth=50
set maxmempattern=500
set history=10000
set modelineexpr
set updatetime=5000
set timeout
set timeoutlen=500
set ttimeout
set ttimeoutlen=750

" Mouse options
set cursorlineopt=screenline,number
if g:enable_mouse
	set mouse=a
else
	set mouse=
endif
let &mousefocus = g:mouse_focus
set nomousehide
set mousemodel=popup_setpos
set nomousemoveevent
if has('nvim')
	set mousescroll=ver:3,hor:6
endif
set mouseshape=i:beam,r:beam,s:updown,sd:cross,m:no,ml:up-arrow,v:rightup-arrow
set mousetime=400
set startofline

" Conceal options
set concealcursor=nc
set conceallevel=0

" Tab options
set tabstop=4
set shiftwidth=4
set smartindent
set smarttab
set noexpandtab

command! -nargs=0 SWrap if !&wrap|setl wrap linebreak nolist|else|setl nowrap nolinebreak list|endif
if g:compatible !=# "helix" && g:compatible !=# "helix_hard"
	nnoremap <leader>sW <cmd>SWrap<cr>
endif

if v:version >= 700
  au BufLeave * let b:winview = winsaveview()
  au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif

nnoremap <silent> dd ddk
nnoremap <silent> - dd
nnoremap <silent> + mzyyp`zj

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

nnoremap <leader>xg :grep -R <cword> .<cr>

let s:MOVING_UPDATE_TIME = 1000
let g:moving = v:false
let s:process_g_but_function_expression = "
\\nfunction! ProcessGBut(button)
\"
if g:fast_terminal
let s:process_g_but_function_expression .= "
\\n	if &buftype !=# 'terminal'
\\n		set lazyredraw
\\n	endif
\"
endif
let g:prev_time = reltime()
let s:process_g_but_function_expression .= "
\\n	exec \"lua << EOF
\\\nlocal button = vim.v.count == 0 and \'g\".a:button.\"\' or \'\".a:button.\"\'
\"
if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
let s:process_g_but_function_expression .= "
\\\nif vim.g.pseudo_visual then
\\\n    button = \\\"\\<esc>\\\"..button
\\\nend"
endif
let s:process_g_but_function_expression .= "
\\\nfor _=1,vim.v.count1,1 do
\\\nvim.api.nvim_feedkeys(button,\\\"n\\\",false)
\\\nend
\\\nEOF\"
\\n"

" FIXME: This code is a crutch
let s:process_g_but_function_expression .= "
\\n	normal! lh
\"

if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
	let s:process_g_but_function_expression .= "
	\\n	call ReorderRightLeft()
	\\n	call SavePosition()
	\"
endif

if g:fast_terminal
let s:process_g_but_function_expression .= "
\\n	if &buftype !=# 'terminal'
\\n		set nolazyredraw
\\n	endif
\"
endif
let s:process_g_but_function_expression .= "
\\nendfunction"
exec s:process_g_but_function_expression

function! JKWorkaroundAlpha()
	if has('nvim')
		noremap <buffer> j <cmd>call ProcessGBut('j')<cr>
		noremap <buffer> k <cmd>call ProcessGBut('k')<cr>
		noremap <down> <cmd>call ProcessGBut('j')<cr>
		noremap <up> <cmd>call ProcessGBut('k')<cr>
	endif
endfunction
function! JKWorkaround()
	if has('nvim')
		noremap k <cmd>call ProcessGBut('k')<cr>
	endif
endfunction
call JKWorkaround()

noremap <silent> <c-a> 0
noremap <silent> <c-e> $
inoremap <silent> <c-a> <home>
inoremap <silent> <c-e> <end>

cnoremap <silent> <c-a> <c-b>
cnoremap <c-g> <c-e><c-u><cr>
cnoremap <silent> jk <c-e><c-u><cr><cmd>echon ''<cr>
cnoremap <c-u> <c-e><c-u>
cnoremap <c-b> <S-left>

nnoremap <c-j> viwUe<space><esc>
vnoremap <c-j> iwUe<space>
inoremap <c-j> <esc>viwUe<esc>a

nnoremap <bs> X
noremap <leader><bs> <bs>


function! Findfile()
	if g:language ==# 'russian'
		let find_file_label = 'Найти файл: '
	else
		let find_file_label = 'Find file: '
	endif
	if !filereadable(g:LOCALSHAREPATH.'/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim')
		echohl Question
		let filename = input(find_file_label)
		echohl Normal
	else
		let filename = quickui#input#open(Pad(find_file_label, g:pad_amount_confirm_dialogue), fnamemodify(expand('%'), ':~:.'))
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
	if g:language ==# 'russian'
		let find_file_label = 'Найти файл (открыть в буфере): '
	else
		let find_file_label = 'Find file (open in buffer): '
	endif
	if !filereadable(g:LOCALSHAREPATH.'/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim')
		echohl Question
		let filename = input(find_file_label)
		echohl Normal
	else
		set lazyredraw
		let filename = quickui#input#open(Pad(find_file_label, g:pad_amount_confirm_dialogue), fnamemodify(expand('%'), ':~:.'))
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

function! SaveAsBase(command, invitation)
	if !filereadable(g:LOCALSHAREPATH.'/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim')
		echohl Question
		let filename = input(a:invitation)
		echohl Normal
	else
		let filename = quickui#input#open(Pad(a:invitation, g:pad_amount_confirm_dialogue), fnamemodify(expand('%'), ':~:.'))
	endif
	if filename !=# ''
		set lazyredraw
		exec a:command(filename)
		set nolazyredraw
	endif
endfunction
function! SaveAs()
	call SaveAsBase({filename -> "w ".filename}, 'Save as: ')
endfunction
function! SaveAsAndRename()
	call SaveAsBase({filename -> "saveas ".filename}, 'Save as and edit: ')
endfunction
command! -nargs=0 SaveAs call SaveAs()
command! -nargs=0 SaveAsAndRename call SaveAsAndRename()
noremap <leader><c-s> <cmd>SaveAs<cr>
noremap <leader><c-r> <cmd>SaveAsAndRename<cr>

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
			if g:language ==# 'russian'
				let select_position_label = 'Выберите позицию %s: '
			else
				let select_position_label = 'Select position %s: '
			endif
			echon printf(select_position_label, keys(a:positions))
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

			if g:language ==# 'russian'
				let select_position_label = 'Выбор позиции'
			else
				let select_position_label = 'Select position'
			endif
			let choice = quickui#confirm#open(select_position_label, button_label_string, 1, 'Confirm')

			let position = keys(a:positions)[choice-1]
		endif
		if char2nr(position) ==# 0
			continue
		endif
		if exists('a:positions[position]')
			exec a:positions[position]['command'](a:cmd)
		else
			echohl ErrorMsg
			if g:language ==# 'russian'
				echom "Блядь: Неправильная позиция: ".position
			else
				echom "Error: Wrong position: ".position
			endif
			echohl Normal
			return 1
		endif
		break
	endwhile
endfunction

if g:language ==# 'russian'
	let g:stdpos = {
		\ 'h': {'button_label': '&s:ГорРаздел', 'command': {cmd -> 'split '.cmd}},
		\ 'v': {'button_label': '&v:ВерРаздел', 'command': {cmd -> 'vsplit '.cmd}},
		\ 'b': {'button_label': '&b:Буффер', 'command': {cmd -> 'e '.cmd}},
		\ 't': {'button_label': '&t:НовВкладк', 'command': {cmd -> 'tabnew|e '.cmd}},
	\ }
	let g:neotreepos = {
		\ 'l': {'button_label': '&v:Слева', 'command': {cmd -> 'Neotree position=left '.cmd}},
		\ 'r': {'button_label': '&r:Справа', 'command': {cmd -> 'Neotree position=right '.cmd}},
		\ 'b': {'button_label': '&b:Буффер', 'command': {cmd -> 'Neotree position=current '.cmd}},
		\ 'f': {'button_label': '&f:Плавающее', 'command': {cmd -> 'Neotree position=float '.cmd}},
	\ }
	let g:termpos = {
		\ 'h': {'button_label': '&s:ГРазде', 'command': {cmd -> 'split|call OpenTerm("'.cmd.'")'}},
		\ 'v': {'button_label': '&v:ВРазде', 'command': {cmd -> 'vsplit|call OpenTerm("'.cmd.'")'}},
		\ 'b': {'button_label': '&b:Буффер', 'command': {cmd -> 'call OpenTerm("'.cmd.'")'}},
		\ 't': {'button_label': '&t:НовВкл', 'command': {cmd -> 'tabnew|call OpenTerm("'.cmd.'")'}},
		\ 'f': {'button_label': '&f:Плаваю', 'command': {cmd -> 'FloatermNew '.cmd}},
	\ }
else
	let g:stdpos = {
		\ 'h': {'button_label': '&Split', 'command': {cmd -> 'split '.cmd}},
		\ 'v': {'button_label': '&Vsplit', 'command': {cmd -> 'vsplit '.cmd}},
		\ 'b': {'button_label': '&Buffer', 'command': {cmd -> 'e '.cmd}},
		\ 't': {'button_label': 'New &tab', 'command': {cmd -> 'tabnew|e '.cmd}},
	\ }
	let g:neotreepos = {
		\ 'l': {'button_label': '&v:Left', 'command': {cmd -> 'Neotree position=left '.cmd}},
		\ 'r': {'button_label': '&Right', 'command': {cmd -> 'Neotree position=right '.cmd}},
		\ 'b': {'button_label': '&Buffer', 'command': {cmd -> 'Neotree position=current '.cmd}},
		\ 'f': {'button_label': '&Floating', 'command': {cmd -> 'Neotree position=float '.cmd}},
	\ }
	let g:termpos = {
		\ 'h': {'button_label': '&Split', 'command': {cmd -> 'split|call OpenTerm("'.cmd.'")'}},
		\ 'v': {'button_label': '&Vsplit', 'command': {cmd -> 'vsplit|call OpenTerm("'.cmd.'")'}},
		\ 'b': {'button_label': '&Buffer', 'command': {cmd -> 'call OpenTerm("'.cmd.'")'}},
		\ 't': {'button_label': 'New &tab', 'command': {cmd -> 'tabnew|call OpenTerm("'.cmd.'")'}},
		\ 'f': {'button_label': '&Floating', 'command': {cmd -> 'FloatermNew '.cmd}},
	\ }
endif

augroup AlphaNvim_CinnamonNvim_JK_Workaround
	autocmd!
	autocmd FileType alpha exec "noremap <buffer> j j" | exec "noremap <buffer> k k" | noremap <down> <down> | noremap <up> <up> | call AfterSomeEvent('BufLeave', 'call JKWorkaround()')
augroup END

let g:LUA_REQUIRE_GOTO_PREFIX = [$HOME]
function! Lua_Require_Goto_Workaround_Wincmd_f()
	if !filereadable(expand(g:LOCALSHAREPATH).'/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim')
		echohl Question
		if g:language ==# 'russian'
			let lua_require_goto_workaround_wincmd_f_dialogue_label = 'Выберите способ перехода %s: '
		else
			let lua_require_goto_workaround_wincmd_f_dialogue_label = 'Select goto way %s: '
		endif
		echon printf(lua_require_goto_workaround_wincmd_f_dialogua_label, ["n", "r"])
		echohl Normal
		let goto_way = nr2char(getchar())
		echon goto_way
		if v:false
		elseif goto_way ==# 'n'
			let choice = 1
		elseif goto_way ==# 'r'
			let choice = 2
		else
			echohl ErrorMsg
			echomsg "Wrong goto way"
			echohl Normal
		endif
		redraw
	else
		if g:language ==# 'russian'
			let dialogue_label = 'Выберите способ перехода'
		else
			let dialogue_label = 'Select goto way'
		endif
		let choice = quickui#confirm#open(dialogue_label, "Normal\n`require`", 1, 'Confirm')
	endif
	if choice ==# 0
		echohl ErrorMsg
		echomsg "Goto way is null"
		echohl Normal
		return
	endif
	if v:false
	elseif choice ==# 1
		exec printf("split %s", expand("<cword>"))
	elseif choice ==# 2
		let line = getline(line('.'))
		let col = col('.')
		let colend = col('$')
		let startcol = 2
		while startcol <# colend
			let start = startcol
			let start_found = v:false
			while start <# colend
				let character = line[start]
				if v:false
				\|| character ==# "\""
				\|| character ==# "'"
					let endsymbol = character
					let start_found = v:true
					break
				endif
				let start += 1
			endwhile
			if !start_found
				echohl ErrorMsg
				echomsg "Start symbol was not found"
				echohl Normal
				return
			endif
			let end_found = v:false
			let end = start + 1
			while end <# colend
				let character = line[end]
				if character ==# endsymbol
					let end_found = v:true
					break
				endif
				let end += 1
			endwhile
			if !end_found
				echohl ErrorMsg
				echomsg "End symbol was not found"
				echohl Normal
				return
			endif
			if col <# start || col ># end
				continue
			endif
			let filename = strpart(line, start + 1, end - start - 1)
			let filename = substitute(filename, '\.', '\/', 'g')
			let file_found = v:false
			for i in g:LUA_REQUIRE_GOTO_PREFIX
				if !filereadable(expand(i).filename.'.lua')
					continue
				endif
				exec printf("split %s", i.filename.'.lua')
				let file_found = v:true
				return
			endfor
			echohl ErrorMsg
			echomsg "file not found, editing a new file"
			echohl Normal
			exec printf("split %s", g:LUA_REQUIRE_GOTO_PREFIX[0].filename.'.lua')
			return
		endwhile
		echohl ErrorMsg
		echomsg "dotfiles: Lua_Require_Goto_Workaround_Wincmd_f: Internal error: unreachable code"
		echohl Normal
	else
		echohl ErrorMsg
		echomsg printf("Wrong goto way: %s", choice)
		echohl Normal
	endif
endfunction
augroup Lua_Require_Goto_Workaround
	autocmd!
	autocmd FileType lua exec "noremap <buffer> <c-w>f <cmd>call Lua_Require_Goto_Workaround_Wincmd_f()<cr>"
augroup END

function! HandleDotfilesOptionsInComment()
	if !exists('g:default_comment_string')
		return
	endif
	let default_comment_string_len = g:default_comment_string
	let i = 1
	let lastline = line('$')
	while i <# lastline + 1
		let line = getline(i)
		let line = Trim(line)
		if !StartsWith(line, g:default_comment_string)
			let i += 1
			continue
		endif
		let line = line[default_comment_string_len+2:]
		let line = Trim(line)
		let end_option = 1
		while end_option <# len(line)
			let character = line[end_option]
			if character ==# ' '
				let end_option -= 1
				break
			endif
			let end_option += 1
		endwhile
		let option = line[0:end_option]
		if option !=# 'DotfilesOptionInComment'
			let i += 1
			continue
		endif
		let line = line[end_option+1:]
		let line = Trim(line)
		let end_option = 1
		while end_option <# len(line)
			let character = line[end_option]
			if character ==# ' '
				let end_option -= 1
				break
			endif
			let end_option += 1
		endwhile
		let option_name = line[0:end_option]
		let line = line[end_option+1:]
		let line = Trim(line)
		let option_value = line
		if v:false
		\|| option_name ==# 'LUA_REQUIRE_GOTO_PREFIX'
			exec printf("let g:%s = %s", option_name, option_value)
		endif
		let i += 1
	endwhile
endfunction
augroup DotfilesOptionsInComment
	autocmd!
	autocmd BufAdd * call HandleDotfilesOptionsInComment()
augroup END

nnoremap <silent> * *:noh<cr>
nnoremap <silent> <c-*> *
nnoremap <silent> # #:noh<cr>
nnoremap <silent> <c-#> #

noremap <leader>l 5zl5zl5zl
noremap <leader>h 5zh5zh5zh
inoremap <c-l> <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>set lazyredraw<cr><cmd>normal! 10zl<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr><cmd>call HandleBuftype(winnr())<cr>
inoremap <c-h> <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>set lazyredraw<cr><cmd>normal! 10zh<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr><cmd>call HandleBuftype(winnr())<cr>
let s:SCROLL_FACTOR = 2
let s:SCROLL_UP_FACTOR = s:SCROLL_FACTOR
let s:SCROLL_DOWN_FACTOR = s:SCROLL_FACTOR
let s:SCROLL_C_E_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_C_Y_FACTOR = s:SCROLL_DOWN_FACTOR
let s:SCROLL_MOUSE_UP_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_MOUSE_DOWN_FACTOR = s:SCROLL_DOWN_FACTOR
exec printf("noremap <silent> <expr> <c-Y> \"%s<c-e>\"", s:SCROLL_C_E_FACTOR)
exec printf("noremap <silent> <expr> <c-y> \"%s<c-y>\"", s:SCROLL_C_Y_FACTOR)
let s:SCROLL_UPDATE_TIME = 1000
call timer_start(s:SCROLL_UPDATE_TIME, {->STCUpd()}, {'repeat': -1})
exec printf("noremap <ScrollWheelDown> %s<c-e>", s:SCROLL_MOUSE_DOWN_FACTOR)
exec printf("noremap <ScrollWheelUp> %s<c-y>", s:SCROLL_MOUSE_UP_FACTOR)

noremap <silent> <leader>st <cmd>lua require('spectre').toggle()<cr><cmd>call Numbertoggle()<cr>
nnoremap <silent> <leader>sw <cmd>lua require('spectre').open_visual({select_word = true})<cr><cmd>call Numbertoggle()<cr>
vnoremap <silent> <leader>sw <cmd>lua require('spectre').open_visual()<cr><cmd>call Numbertoggle()<cr>
noremap <silent> <leader>sp <cmd>lua require('spectre').open_file_search({select_word = true})<cr><cmd>call Numbertoggle()<cr>

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

exec printf('noremap <silent> <leader>vj <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:DOTFILES_CONFIG_PATH)
exec printf('noremap <silent> <leader>sj <cmd>call LoadDotfilesConfig("%s", v:true)<cr><cmd>call HandleDotfilesConfig()<cr><cmd>call HandleBuftypeAll()<cr>', expand(g:DOTFILES_CONFIG_PATH))

" .dotfiles-script.sh FILE
noremap <silent> <leader>b <cmd>call SelectPosition("~/.dotfiles-script.sh", g:stdpos)<cr>

autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exec "normal! g`\"" |
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
	\\n CONFIGS:
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
	\\n SPECIAL:
	\\n   ; - Switch to command mode (:)
	\\n   LEAD - Show possible keyboard shortcuts
	\\n   LEAD LEAD or F10 or F9 - Open quickui menu
	\\n   LEAD CTRL-f or F3 - Toggle fullscreen mode
	\\n   INSERT: jk - Exit from Insert Mode and save
	\\n   INSERT: jK - Exit from Insert Mode
	\\n   INSERT: ju - Make current word uppercase
	\\n   INSERT: ji - Make current word lowercase
	\\n   CTRL-a - Move to start of line
	\\n   CTRL-e - Move to end of line
	\\n   LEAD h - Move screen 10 symbols left
	\\n   LEAD l - Move screen 10 symbols right
	\\n   INSERT: CTRL-h - Move screen 10 symbols left
	\\n   INSERT: CTRL-l - Move screen 10 symbols right
	\\n   CTRL-h - Toggle Neo-tree
	\\n   CTRL-n - Enter multicursor mode
	\\n   ci_ - Edit word from start to first _
	\\n   LEAD d  - Hide search highlightings
	\\n   s - Delete (d) without copying
	\\n   q - Quit window
	\\n   Q - Quit window without saving
	\\n   LEAD r - Open ranger to select file to edit
	\\n   LEAD CTRL-s - \"Save as\" dialogue
	\\n   LEAD u - Update plugins using packer.nvim
	\\n   LEAD Cu - Update coc.nvim language servers
	\\n   LEAD tu - Update nvim-treesitter parsers
	\\n   LEAD sw - Find work under cursor using nvim-spectre
	\\n   LEAD t - \"Open Terminal\" dialogue
	\\n   LEAD m - \"Open Far/MC\" dialogue
	\\n   LEAD z - \"Open lazygit\" dialogue
	\\n   CTRL-t - Toggle ctags tagbar
	\\n Tmux-like keybindings:
	\\n   CTRL-c c - Find file
	\\n   CTRL-c C - Find file in buffer
	\\n   CTRL-c % - Split window horizontally
	\\n   CTRL-c \" - Split window vertically
	\\n   CTRL-c w - Quit from window
	\\n   CTRL-c 1-9 - Jump to tab 1-9
	\\n   LEAD so - Toggle scrolloff (see :h 'scrolloff')
	\\n Emacs-like keybindings:
	\\n   ALT-x - Switch to command mode (:)
	\\n   CTRL-x CTRL-c - Close All windows
	\\n   CTRL-x s - Save current buffer
	\\n   CTRL-x CTRL-s - Save current buffer
	\\n   CTRL-x S - Save all buffers
	\\n   CTRL-x k - Kill (delete) current buffer dialogue
	\\n   CTRL-x 0 - Close current window
	\\n   CTRL-x 1 - Close all but current window
	\\n   CTRL-x 2 - Split window
	\\n   CTRL-x 3 - Vertically split window
	\\n   CTRL-x o - Next tab
	\\n   CTRL-x O - Previous tab
	\\n   CTRL-x CTRL-f - See CTRL-c c
	\\n   CTRL-x t 0 - Close current tab
	\\n   CTRL-x t 1 - Close all but current tab
	\\n   CTRL-x t 2 - New tab
	\\n   CTRL-x t o - Next tab
	\\n   CTRL-x t O - Previous tab
	\\n   CTRL-x h - Select all text and save position to register y
	\\n   CTRL-x CTRL-h - See help (:h)
	\\n   CTRL-x CTRL-c - Exit
	\\n   CTRL-x CTRL-q - Exit without confirmation
	\\n   CTRL-x CTRL-b - \"List buffers\" dialogue
	\\n QUOTES AROUND (deprecated, use surround.vim):
	\\n   LEAD \" - Put \'\"\' around word
	\\n   LEAD \' - Put \"\'\" around word
	\\n  TELESCOPE plugin:
	\\n    LEAD ff - Find files
	\\n    LEAD fg - Live grep
	\\n    LEAD fb - Buffers
	\\n    LEAD fh - Help tags
	\\n  ABOUT:
	\\n    Author: TwoSpikes (2023 - 2024)
	\\n    Github repository: https://github.com/TwoSpikes/dotfiles
	\"
endfunction
command! -nargs=0 DotfilesCheatSheet call DotfilesCheatSheet()
noremap <silent> <leader>? <cmd>DotfilesCheatSheet<cr>

" FAST COMMANDS
"noremap ; :
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
inoremap <c-c> <c-c><cmd>call Numbertoggle()<cr>

" TERMINAL
function! OpenTerm(cmd)
	if a:cmd ==# ""
		exec printf("terminal %s", $SHELL)
	else
		exec printf("terminal %s", a:cmd)
	endif
	startinsert
	return bufnr()
endfunction
noremap <silent> <leader>t <cmd>call SelectPosition($SHELL, g:termpos)<cr>

" COLORSCHEME
noremap <silent> <leader>C <cmd>call SelectPosition($VIMRUNTIME."/colors", g:neotreepos)<cr>
noremap <silent> <leader>Cy <cmd>set lazyredraw<cr>yy:<c-f>pvf]o0"_dxicolo <esc>$x$x$x$x<cr>jzb<cmd>set nolazyredraw<cr>

noremap <silent> <leader>Cu <cmd>CocUpdate<cr>
noremap <silent> <leader>tu <cmd>TSUpdate<cr>

function! CommentOut(comment_string)
	mark z
	if mode() !~? 'v.*' && mode() !~? "\<c-v>.*"
		return "0i".a:comment_string." \<esc>"
	else
		let cmd = ''
		if mode() !~? "\<c-v>.*"
			let cmd .= "\<c-v>"
		endif
		let cmd .= "0I".a:comment_string."\<esc>"
		return cmd
	endif
	normal! `z
endfunction
function! CommentOutDefault()
	if exists('g:default_comment_string')
		return CommentOut(g:default_comment_string)
	else
		echohl ErrorMsg
		if g:language ==# 'russian'
			echo "Блядь: Комментарии недоступны"
		else
			echo "Error: Comments are not available"
		endif
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
		if g:language ==# 'russian'
			echo "Блядь: Комментарии недоступны"
		else
			echo "Error: Comments are not available"
		endif
		echohl Normal
	endif
endfunction
noremap <expr> <leader>/d CommentOutDefault()
noremap <leader>/u <cmd>call UncommentOutDefault()<cr>
augroup cpp
	au!
	au filetype cpp let g:default_comment_string = "//"
	au filetype cpp noremap <silent> <buffer> <leader>N viwo<esc>i::<esc>hi
augroup END
augroup java
	au!
	au filetype java let g:default_comment_string = "//"
augroup END
augroup javascript
	au!
	au filetype javascript let g:default_comment_string = "//"
augroup END
augroup javascriptreact
	au!
	au filetype javascriptreact let g:default_comment_string = "//"
augroup END
augroup vim
	au!
	au filetype vim let g:default_comment_string = '"'
augroup END
augroup lua
	au!
	au filetype lua let g:default_comment_string = '--'
augroup END
augroup haskell
	au!
	au filetype haskell let g:default_comment_string = '--'
augroup END
augroup googol
	au!
	au syntax googol let g:default_comment_string = "//"
augroup END
augroup php
	au!
	au filetype php let g:default_comment_string = "//"
	au filetype php noremap <silent> <buffer> <leader>g viwoviGLOBALS['<esc>ea']<esc>
augroup END
augroup sh
	au!
	au filetype bash,sh let g:default_comment_string = "#"
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
augroup neo-tree
	if exists('g:default_comment_string')
		unlet g:default_comment_string
	endif
	au filetype neo-tree setlocal nocursorcolumn | call Numbertoggle()
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

		let pre_cursorcolumn = (mode() !~# "[vVirco]" && mode() !~# "\<c-v>") && !s:fullscreen && filetype !=# 'netrw' && buftype !=# 'terminal' && filetype !=# 'neo-tree' && buftype !=# 'nofile'
		if exists('g:cursorcolumn')
			let pre_cursorcolumn = pre_cursorcolumn && g:cursorcolumn
		endif
		call setwinvar(a:winnum, '&cursorcolumn', pre_cursorcolumn)

		let pre_cursorline = !s:fullscreen
		if g:cursorline_style ==# "reverse"
			let pre_cursorline = pre_cursorline && mode() !~# "[irco]"
			let pre_cursorline = pre_cursorline && (buftype !=# 'nofile' || filetype ==# 'neo-tree') && filetype !=# 'TelescopePrompt' && filetype !=# 'spectre_panel' && filetype !=# 'packer'
		endif
		let pre_cursorline = pre_cursorline && buftype !=# 'terminal' && filetype !=# 'alpha'
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
	lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({winblend = 0 }))
endfunction
nnoremap <silent> <leader>ff <cmd>call FuzzyFind()<cr>
nnoremap <silent> <leader>fg :lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fb :lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fh :lua require('telescope.builtin').help_tags(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fr <cmd>lua require('telescope').extensions.recent_files.pick()<CR>

" vnoremap <c-/> <esc>v:q:s/.*/# \0
" vnoremap <c-?> <esc>:s/.*/\/\/ \0

function! IsYes(string)
	return v:false
	\|| a:string =~? '^y *!* *$'
	\|| a:string =~? '^yes *!* *$'
	\|| a:string =~? '^yea *!* *$'
	\|| a:string =~? '^yeah *!* *$'
	\|| a:string =~? '^yep *!* *$'
	\|| a:string =~? '^yup *!* *$'
	\|| a:string =~? '^of *course *!* *$'
	\|| a:string =~? '^\%(сука*\)* *\%(бля*\%(дь\)\?\)* *\%(кон\%(\%(еч\)\|\%(че\)\)но\? *\)*\%(да* *\)*!* *$'
	\|| a:string =~? '^\%(сука*\)* *\%(бля*\%(дь\)\?\)* *\%(дыа\? *\)\+!* *$'
	\|| a:string =~? '^\%(сука*\)* *\%(бля*\%(дь\)\?\)* *офк *!* *$'
	\|| a:string =~? '^\%(сука*\)* *\%(бля*\%(дь\)\?\)* *офкорз *!* *$'
endfunction
function! IsNo(string)
	return v:false
	\|| a:string =~? '^n *!* *$'
	\|| a:string =~? '^no *!* *$'
	\|| a:string =~? '^nope *!* *$'
	\|| a:string =~? '^of *course *not\? *!* *$'
	\|| a:string =~? '^\%(сука *\)*\%(блядь *\)*\%(кон\%(\%(че\)\|\%(еч\)\)но\? *\)*\%(да *\)*нет\? *!* *$'
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
	if g:language ==# 'russian'
		let kill_buffer_label = 'Убить буфер'
	else
		let kill_buffer_label = 'Kill buffer'
	endif
	if !filereadable(g:LOCALSHAREPATH.'/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim')
		let user_input = input(kill_buffer_label." (Y/n): ")
		echohl Normal
	else
		let choice = quickui#confirm#open(kill_buffer_label, "&Yes\n&No", 1, 'Confirm')
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
		if g:language ==# 'russian'
			echo " "
			echo "Пожалуйста ответь "
			echohl Title
			echon "да"
			echohl ErrorMsg
			echon " или "
			echohl Title
			echon "нет"
			echohl ErrorMsg
			echon " или оставь бланк пустым"
		else
			echo " "
			echo "Please answer "
			echohl Title
			echon "yes"
			echohl ErrorMsg
			echon " or "
			echohl Title
			echon "no"
			echohl ErrorMsg
			echon " or leave blank empty"
		endif
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
	if g:language ==# 'russian'
		echom 'Предыдущая позиция отмечена как "y"'
	else
		echom 'Previous position marked as "y"'
	endif
endfunction
noremap <silent> <c-x>h <cmd>call SelectAll()<cr>
noremap <silent> <c-x><c-h> <cmd>h<cr>
noremap <silent> <c-x><c-g> <cmd>echo "Quit"<cr>

noremap mz <cmd>echohl ErrorMsg<cr><cmd>echom "mz is used for commands"<cr><cmd>echohl Normal<cr>
noremap my <cmd>echohl ErrorMsg<cr><cmd>echom "my is used for commands"<cr><cmd>echohl Normal<cr>

noremap <leader>q q
noremap <leader>Q Q

inoremap <silent> jk <esc><cmd>update<cr>
inoremap <silent> jK <esc>
inoremap <silent> JK <esc><cmd>update<cr>
inoremap <silent> Jk <esc>
" FIXME: Bicycle is invented, but the problem is not solved
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
tnoremap <silent> jK <c-\><c-n><cmd>let g:please_do_not_close=v:true<cr><cmd>:bd!<cr><cmd>tabnew<cr><cmd>call OpenTerm("")<cr><cmd>let g:please_do_not_close=v:false<cr>
command! -nargs=* W w <args>

inoremap <silent> ju <esc>viwUea
inoremap <silent> ji <esc>viwuea

inoremap <silent> ( <cmd>call HandleKeystroke('(')<cr>
inoremap <silent> [ <cmd>call HandleKeystroke('[')<cr>
inoremap <silent> { <cmd>call HandleKeystroke('{')<cr>
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
	endif
	if a:keystroke ==# '"'
	\|| a:keystroke ==# "'"
		return a:keystroke.a:keystroke."\<left>"
	endif
	if v:false
	elseif a:keystroke ==# '('
		normal! h
		normal! a()
		call Numbertoggle(mode())
	elseif a:keystroke ==# '['
		normal! h
		normal! a[]
		call Numbertoggle(mode())
	elseif a:keystroke ==# '{'
		normal! h
		normal! a{}
		call Numbertoggle(mode())
	else
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
	exec printf("so %s", g:CONFIG_PATH.'/vim/plugins/setup.vim')

	if executable('git')
		exec printf("luafile %s", g:PLUGINS_INSTALL_FILE_PATH)
	endif
	PackerInstall
	set nolazyredraw
	exec printf("luafile %s", g:PLUGINS_SETUP_FILE_PATH)
endif

if has('nvim') && exists('g:setup_lsp')
	if g:setup_lsp
		lua M = {}
		lua servers = { gopls = {}, html = {}, jsonls = {}, pyright = {}, rust_analyzer = {}, sumneko_lua = {}, tsserver = {}, vimls = {}, }
		lua on_attach = function(client, bufnr) vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc") vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()") require("config.lsp.keymaps").setup(client, bufnr) end
		lua opts = { on_attach = on_attach, flags = { debounce_text_changes = 150, }, }
		lua setup = function() require("config.lsp.installer").setup(servers, opts) end
	endif
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

noremap <silent> <leader>so :let &scrolloff = 999 - &scrolloff<cr>

nnoremap s "_d

noremap <silent> <f10> <cmd>call quickui#menu#open()<cr>
noremap <silent> <f9> <cmd>call quickui#menu#open()<cr>

nnoremap <silent> <c-x><c-b> <cmd>call quickui#tools#list_buffer('e')<cr>

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
	if g:language ==# 'russian'
		echom "Окно: ".&lines."столбцов, ".&columns."колонок"
	else
		echom "Window: ".&lines."rows, ".&columns."cols"
	endif
endfunction

let g:floaterm_width = 1.0
noremap <leader>z <cmd>call SelectPosition('lazygit', g:termpos)<cr>
noremap <leader>m <cmd>call SelectPosition(g:far_or_mc, g:termpos)<cr>

function! EnablePagerMode()
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

	let g:cursorline

	call feedkeys("\<c-\>\<c-n>")
endfunction
function! DisablePagerMode()
	let s:fullscreen = v:false
	let &cursorline = s:old_cursorline
	let &cursorcolumn = s:old_cursorcolumn
	let &showtabline = s:old_showtabline
	let &laststatus = s:old_laststatus
	let &showcmdloc = s:old_showcmdloc
	let &showmode = s:old_showmode
	let &ruler = s:old_ruler
	echon ''
endfunction

function! TogglePagerMode()
	if g:PAGER_MODE
		call DisablePagerMode()
	else
		call EnablePagerMode()
	endif
	let g:PAGER_MODE = !g:PAGER_MODE
endfunction
command! -nargs=0 TogglePagerMode call TogglePagerMode()
noremap <leader>xp <cmd>TogglePagerMode<cr>

augroup xdg_open
	autocmd!
	function! OpenWithXdg(filename)
		if !filereadable(g:LOCALSHAREPATH.'/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim')
			echohl Question
			if g:language ==# 'russian'
				echon 'Открыть через xdg-open (y/N): '
			else
				echon 'Open with xdg-open (y/N): '
			endif
			echohl Normal
			let choice = nr2char(getchar())
		else
			if g:language ==# 'russian'
				let choice = quickui#confirm#open('Открыть через xdg-open?', "&Да\n&Отмена", 1, 'Confirm')
			else
				let choice = quickui#confirm#open('Open with xdg-open?', "&OK\n&Cancel", 1, 'Confirm')
			endif
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
			call system(["chmod", "+x", TMPFILE])
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

" Copied from StackOverflow: https://stackoverflow.com/questions/59583931/vim-how-do-i-determine-the-status-of-a-process-within-a-terminal-tab
function! TermRunning(buf)
	return getbufvar(a:buf, '&buftype') !=# 'terminal' ? 0 :
		\ has('terminal') ? term_getstatus(a:buf) =~# 'running' :
		\ has('nvim') ? jobwait([getbufvar(a:buf, '&channel')], 0)[0] == -1 :
		\ 0
endfunction

function! OpenRanger(path)
	if has('nvim')
		let TMPFILE = trim(system(["mktemp", "-u"]))
	else
		let TMPFILE = trim(system("mktemp -u"))
	endif
	let g:bufnrforranger = OpenTerm("ranger --choosefile=".TMPFILE." ".a:path)
	augroup oncloseranger
		autocmd! oncloseranger
		if has('nvim')
			exec 'autocmd TermClose * let filename=system("cat '.TMPFILE.'")|if bufnr()==#'.g:bufnrforranger."|if filereadable(filename)==#1|bdelete|exec 'edit '.filename|call Numbertoggle()|filetype detect|call AfterSomeEvent(\"ModeChanged\", \"doautocmd BufEnter \".expand(\"%\"))|unlet g:bufnrforranger|else|call IfOneWinDo(\"call OnQuit()\")|quit|endif|endif|call delete('".TMPFILE."')|unlet filename"
		else
			function! CheckRangerStopped(timer_id, TMPFILE)
				let bufnr = bufnr()
				if bufnr ==# g:bufnrforranger && !TermRunning(bufnr)
					let filename=system("cat ".a:TMPFILE)
					call delete(a:TMPFILE)
					if filereadable(filename) ==# 1
						bdelet
						exec 'edit '.filename
						call Numbertoggle()
						filetype detect
						call AfterSomeEvent("ModeChanged", "doautocmd BufEnter ".expand("%"))
						if exists('g:bufnrforranger')
							unlet g:bufnrforranger
						endif
						call timer_stop(a:timer_id)
					else
						call IfOneWinDo("call OnQuit()")
						quit
					endif
					unlet filename
				endif
			endfunction
			exec "call timer_start(0, {timer_id -> CheckRangerStopped(timer_id, '".TMPFILE."')}, {'repeat': -1})"
		endif
		exec "autocmd BufWinLeave * let f=expand(\"<afile>\")|let n=bufnr(\"^\".f.\"$\")|if n==#".g:bufnrforranger."|unlet f|unlet n|au!oncloseranger|call AfterSomeEvent(\"BufEnter,BufLeave,WinEnter,WinLeave\", \"".g:bufnrforranger."bw!\")|unlet g:bufnrforranger|endif"
	augroup END
	unlet TMPFILE
endfunction
function! OpenRangerCheck()
	if executable('ranger')
		call OpenRanger('./')
	else
		echohl ErrorMsg
		if g:language ==# 'russian'
			echom "Блядь: Не открывается ranger: не установлен"
		else
			echom "Error: Cannot open ranger: ranger not installed"
		endif
		echohl Normal
	endif
endfunction
nnoremap <leader>r <cmd>call OpenRangerCheck()<cr>

function! RunAlphaIfNotAlphaRunning()
	if &filetype !=# 'alpha'
		Alpha
	else
		AlphaRedraw
		AlphaRemap
	endif
endfunction
nnoremap <leader>A <cmd>call RunAlphaIfNotAlphaRunning()<cr>

nnoremap <c-h> <cmd>Neotree<cr>

function! OpenOnStart()
	if exists('g:open_menu_on_start')
		if g:open_menu_on_start ==# v:true
			call ChangeNames()
			call RebindMenus()
			call timer_start(0, {->quickui#menu#open()})
		endif
	endif

	if argc() && isdirectory(argv(0))
		if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/neo-tree.nvim")
			bwipeout!
			exec 'Neotree' argv(0)
			silent only
		else
			exec "edit ".argv(0)
		endif
	endif
	if expand('%') == '' || isdirectory(expand('%'))
		let to_open = v:true
		let to_open = to_open && !g:DO_NOT_OPEN_ANYTHING
		let to_open = to_open && !g:PAGER_MODE
		if to_open
			if g:open_on_start ==# 'alpha' && has('nvim') && !isdirectory(expand('%'))
				Alpha
			elseif g:open_on_start ==# "explorer" || (!has('nvim') && g:open_on_start ==# 'alpha')
			\||executable('ranger') !=# 1
				edit ./
			elseif g:open_on_start ==# "ranger"
				if argc() ># 0
					call OpenRanger(argv(0))
				else
					call OpenRanger("./")
				endif
			endif
		endif
	endif
	call Numbertoggle()
endfunction

nnoremap <leader>n <cmd>Neogen<cr>

if isdirectory(expand(g:LOCALSHAREPATH)."/site/pack/packer/start/vim-fugitive")
	nnoremap <leader>gc <cmd>Git commit --verbose<cr>
	nnoremap <leader>ga <cmd>Git commit --verbose --all<cr>
	nnoremap <leader>gA <cmd>Git commit --verbose --amend<cr>
	nnoremap <leader>gp <cmd>Git pull<cr>
	nnoremap <leader>gP <cmd>Git push<cr>
	nnoremap <leader>gr <cmd>Git reset --soft<cr>
	nnoremap <leader>gR <cmd>Git reset --hard<cr>
	nnoremap <leader>gm <cmd>Git reset --mixed<cr>
	nnoremap <leader>gs <cmd>Git status<cr>
endif

function! DoPackerUpdate(args)
	call BeforeUpdatingPlugins()
	exec "lua require('packer').update(".a:args.")"
	call AfterUpdatingPlugins()
endfunction
if has('nvim')
	command! -nargs=* PackerUpdate exec "call DoPackerUpdate('".<f-args>."')"
endif
function! BeforeUpdatingPlugins()
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/which-key.nvim/lua/which-key")
		exec "cd ".g:LOCALSHAREPATH."/site/pack/packer/start/which-key.nvim/lua/which-key"
		exec "!git stash"
		cd -
	endif
endfunction
function! AfterUpdatingPlugins()
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/which-key.nvim/lua/which-key")
		exec "cd ".g:LOCALSHAREPATH."/site/pack/packer/start/which-key.nvim/lua/which-key/"
		exec "!git stash pop"
		cd -
	endif
endfunction

function! PrepareWhichKey()
	let g:which_key_timeout = 100
	if filereadable(g:LOCALSHAREPATH.'/site/pack/packer/start/which-key.nvim/lua/which-key/util.lua')
		edit ~/.local/share/nvim/site/pack/packer/start/which-key.nvim/lua/which-key/util.lua
		if getline(189) =~# 'if not ("nvsxoiRct"):find(mode) then'
			silent 189,192delete
			silent write
		endif
		bwipeout!
	endif
	nnoremap <silent> <leader> <cmd>lua require('which-key').show(vim.g.mapleader)<cr>
	nnoremap <silent> <c-x> <cmd>lua require('which-key').show("\24", {mode = "n", auto = true})<cr>
	nnoremap <silent> <c-w> <cmd>lua require('which-key').show("\23", {mode = "n", auto = true})<cr>
endfunction

function! LoadLastSelected()
	if filereadable(expand(g:LOCALSHAREPATH).'/dotfiles/last_selected.txt')
		let g:last_selected = readfile(expand(g:LOCALSHAREPATH).'/dotfiles/last_selected.txt')[0]
	endif
endfunction
function! SaveLastSelected()
	if g:last_selected !=# ''
		if !isdirectory(expand(g:LOCALSHAREPATH).'/dotfiles')
			call mkdir(expand(g:LOCALSHAREPATH).'/dotfiles', 'p')
		endif
		call writefile([g:last_selected], expand(g:LOCALSHAREPATH).'/dotfiles/last_selected.txt')
	endif
endfunction

function! HelpOnFirstTime()
	if !filereadable(expand(g:LOCALSHAREPATH).'/dotfiles/not_first_time.null')
		if !isdirectory(expand(g:LOCALSHAREPATH).'/dotfiles')
			call mkdir(expand(g:LOCALSHAREPATH).'/dotfiles', 'p')
		endif
		call writefile([], expand(g:LOCALSHAREPATH).'/dotfiles/not_first_time.null')

		if !filereadable(g:LOCALSHAREPATH.'/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim')
			if g:language ==# 'russian'
				echom 'Чтобы посмотреть помощь, нажмите SPC-?. Вы больше не увидите это сообщение'
			else
				echom 'To see help, press SPC-?. You will not see this message again'
			endif
		else
			call timer_start(0, {timer_id -> quickui#confirm#open('To see help, press SPC-?')})
		endif
	endif
endfunction
function! OnStart()
	call SetDotfilesConfigPath()
	call SetLocalSharePath()
	call SetConfigPath()
	if has('nvim')
		call PrepareVital()
		call MakeThingsThatRequireBeDoneAfterPluginsLoaded()
	endif
	call TermuxSaveCursorStyle()
	if has('nvim') && g:enable_which_key
		call PrepareWhichKey()
	endif
	Showtab
	exec "so ".g:CONFIG_PATH."/vim/init.vim"
	call DefineAugroups()
	call UpdateShowtabline()
	if g:PAGER_MODE
		call EnablePagerMode()
	endif
	call HelpOnFirstTime()
	call OpenOnStart()
	if has('nvim') && g:compatible !=# "helix_hard"
		exec printf('luafile %s', fnamemodify(g:PLUGINS_SETUP_FILE_PATH, ':h').'/noice/setup.lua')
	endif
	if v:false
	\|| g:compatible ==# "helix"
	\|| g:compatible ==# "helix_hard"
		call LoadLastSelected()
	endif
endfunction
function! OnQuit()
	call TermuxLoadCursorStyle()
	if v:false
	\|| g:compatible ==# "helix"
	\|| g:compatible ==# "helix_hard"
		call SaveLastSelected()
	endif
endfunction
function! IfOneWinDo(cmd)
	let s = 0
	tabdo let s += winnr('$')
	if s==# 1
		exec a:cmd
	endif
	unlet s
endfunction

au! VimEnter * call OnStart()
au! VimLeave * call OnQuit()
