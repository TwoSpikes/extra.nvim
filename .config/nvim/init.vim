#!/bin/env -S nvim -u

" Main file of Vim/NeoVim config

" plugin: plug-in
" ExNvim, exnvim: extra.nvim
" stc: statuscolumn
" linenr: line numbers
" STCRel: enable stc with relative linenr (template for function name)
" STCAbs: enable stc with absolute linenr (template for function name)
" STCNo: disable stc (template for function name)
" STCUpd: update stc (template for function name)
" autocmd: autocommand
" augroup: autocmd group
" buf: buffer
" buftype: buf type
" filetype: file type
" hlgroup: highlight group
" specmode: special mode
" stl: statusline
" lang: language
" cmd: command
" showcmd: current Vim cmd
" stl_pos: current line, current column and number of lines in buffer, buffer number and position in buffer in percent
" stl_mode_to_put: current mode
" SWrap: toggle soft wrapping (template to match function name)
" win: window
" but: button
" ProcessGBut: process `gj`, `gk`, `j` and `k` commands (template to match function name)
" Alpha: `alpha.nvim` plugin
" JKWorkaroundAlpha: fix `j` and `k` buttons for `alpha.nvim` plugin (template to match function name)
" JKWorkaround: return to normal from JKWorkaroundAlpha function (template to match function name)
" Findfile: find file and open in a new tab (template to match Ex command and function name)
" Findfilebuffer: find file and open in this window (template to match Ex command and function name)
" term: terminal
" neotree: `Neo-tree.nvim` plugin
" std: standart
" col: column
" goto: go to
" var: variable
" c: character
" floaterm: `floaterm.nvim` plugin
" xdg_open: open files with `xdg-open` shell command (template for augroup name)
" TMPFILE: temporary file name
" filename: file name
" config: configuration

if has('nvim')
	lua vim.loader.enable()
endif

call inputsave()

if !has('nvim')
	set nocompatible
endif

set statusline=%#Loading0#Loading\ 0%%
hi Loading0 ctermfg=0 ctermbg=9 cterm=bold guifg=#303030 guibg=#ff0000 gui=bold
mode

function! SetExNvimConfigPath()
	if !exists('g:EXNVIM_CONFIG_PATH') || g:EXNVIM_CONFIG_PATH ==# ""
		if !exists('$EXNVIM_CONFIG_PATH')
			let g:EXNVIM_CONFIG_PATH = "$HOME/.config/exnvim/config.json"
		else
			let g:EXNVIM_CONFIG_PATH = $EXNVIM_CONFIG_PATH
		endif
		let g:EXNVIM_CONFIG_PATH = expand(g:EXNVIM_CONFIG_PATH)
	endif
endfunction
call SetExNvimConfigPath()

function! LoadExNvimConfig(path, reload=v:false)
	if !filereadable(a:path)
		echohl ErrorMsg
		echomsg "error: no extra.nvim config"
		echohl Normal
		return 1
	endif
	let l:exnvim_config_str = join(readfile(a:path, ''), '')
	silent! execute "let g:exnvim_config = json_decode(l:exnvim_config_str)"
	if type(g:exnvim_config) !=# v:t_dict
		echohl ErrorMsg
		echomsg "error: failed to parse extra.nvim config"
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
		\'enable_nvim_treesitter_context',
		\'do_not_save_previous_column_position_when_going_up_or_down',
		\'use_codeium',
		\'open_cmd_on_up',
		\'insert_exit_on_jk',
		\'insert_exit_on_jk_save',
		\'selected_colorscheme',
		\'disable_cinnamon',
		\'disable_animations',
		\'prefer_far_or_mc',
		\'automatically_open_neo_tree_instead_of_netrw',
		\'edit_new_file',
	\]
	if keys(g:exnvim_config) ==# ['_TYPE', '_VAL']
		for item in g:exnvim_config['_VAL']
			let option = item[0]
			let g:value = item[1]
			if index(l:option_list, option) !=# -1
				if !exists("g:".option) || a:reload
					execute "let g:".option." = g:value"
				endif
			endif
		endfor
		unlet g:value
	else
		for option in l:option_list
			if exists('g:exnvim_config["'.option.'"]')
				if !exists("g:".option) || a:reload
					execute "let g:".option." = g:exnvim_config[option]"
				endif
			endif
		endfor
	endif
endfunction

call LoadExNvimConfig(g:EXNVIM_CONFIG_PATH, exists('g:CONFIG_ALREADY_LOADED'))

function! SetDefaultValuesForStartupOptionsAndExNvimConfigOptions()
	" Default values for startup options
	if !exists('g:PAGER_MODE')
		let g:PAGER_MODE = v:false
	endif
	if !exists('g:DO_NOT_OPEN_ANYTHING')
		let g:DO_NOT_OPEN_ANYTHING = v:false
	endif

	" Default vars
	let g:last_selected = ''
	let g:last_open_term_program = ''

	" Default values for options
	if !exists('g:use_transparent_bg')
		let g:use_transparent_bg = "dark"
	endif
	if !exists('g:use_italic_style')
		let g:use_italic_style = v:true
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
	if !exists('g:quickui_border_style')
		let g:quickui_border_style = 4
	endif
	if !exists('g:quickui_color_scheme')
		let g:quickui_color_scheme = "papercol dark"
	endif
	if !exists('g:open_on_start')
		let g:open_on_start = "alpha"
	endif
	if !exists('g:use_github_copilot')
		let g:use_github_copilot = v:false
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
		let g:tabline_pressable = v:true
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
	if !exists('g:enable_nvim_treesitter_context')
		let g:enable_nvim_treesitter_context = v:true
	endif
	if !exists('g:do_not_save_previous_column_position_when_going_up_or_down')
		let g:do_not_save_previous_column_position_when_going_up_or_down = v:false
	endif
	if !exists('g:use_codeium')
		let g:use_codeium = v:false
	endif
	if !exists('g:open_cmd_on_up')
		let g:open_cmd_on_up = v:false
	endif
	if !exists('g:insert_exit_on_jk')
		let g:insert_exit_on_jk = v:true
	endif
	if !exists('g:insert_exit_on_jk_save')
		let g:insert_exit_on_jk_save = v:true
	endif
	if !exists('g:selected_colorscheme')
		let g:selected_colorscheme = "blueorange"
	endif
	if !exists('g:disable_cinnamon')
		let g:disable_cinnamon = v:false
	endif
	if !exists('g:disable_animations')
		let g:disable_animations = v:false
	endif
	if !exists('g:prefer_far_or_mc')
		let g:prefer_far_or_mc = "far"
	endif
	if !exists('g:automatically_open_neo_tree_instead_of_netrw')
		let g:automatically_open_neo_tree_instead_of_netrw = v:true
	endif
	if !exists('g:edit_new_file')
		let g:edit_new_file = v:false
	endif
endfunction
call SetDefaultValuesForStartupOptionsAndExNvimConfigOptions()

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

function! IsHightlightGroupDefined(group)
	silent! let output = execute('hi '.a:group)
	return output !~# 'E411:'
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
	execute printf("hi %s ctermfg=%s", a:dst, ctermfg)
	execute printf("hi %s ctermbg=%s", a:dst, ctermbg)
	execute printf("hi %s cterm=%s", a:dst, cterm)
	execute printf("hi %s guifg=%s", a:dst, guifg)
	execute printf("hi %s guibg=%s", a:dst, guibg)
	execute printf("hi %s gui=%s", a:dst, gui)
endfunction
function! ApplyColorscheme(colorscheme)
	execute "colorscheme ".a:colorscheme
	if !IsHightlightGroupDefined('StatementNorm')
		call CopyHighlightGroup('Statement', 'StatementNorm')
	endif
	if !IsHightlightGroupDefined('StatementIns')
		call CopyHighlightGroup('Statement', 'StatementIns')
	endif
	if !IsHightlightGroupDefined('StatementVisu')
		call CopyHighlightGroup('Statement', 'StatementVisu')
	endif
endfunction
call ApplyColorscheme(g:selected_colorscheme)

augroup colorscheme_manage
	autocmd!
	function! ColorSchemeManagePre()
		if exists('g:cursorline_style_supported')
			if exists('g:cursorline_style')
				let g:cursorline_style = g:cursorline_style_supported[g:cursorline_style]
			endif
			unlet g:cursorline_style_supported
			if exists('g:updating_cursorline_supported')
				unlet g:updating_cursorline_supported
			endif
		endif
		if exists('g:updating_cursor_style_supported')
			unlet g:updating_cursor_style_supported
		endif
	endfunction
	autocmd ColorSchemePre * call ColorSchemeManagePre()
augroup END

if has('nvim')
	augroup LineNrForInactive
		autocmd!
		function! s:SaveStc(clear_stc, winnr=winnr())
			execute printf("let g:stc_was_%d = &l:stc", win_getid(a:winnr))
			if a:clear_stc
				call setwinvar(a:winnr, '&stc', '')
			endif
		endfunction
		autocmd! WinLeave * call s:SaveStc(v:true)
		function! s:LoadStc(winnr=winnr())
			if exists("g:stc_was_"..win_getid(a:winnr))==#1
				call setwinvar(a:winnr, '&stc', eval("g:stc_was_"..win_getid(a:winnr)))
			else
				call setwinvar(a:winnr, '&stc', '')
			endif
		endfunction
		autocmd! WinEnter * call s:LoadStc()
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
set statusline=%#Loading13#Loading\ 12.5%%
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
		execute old_tabpagenr 'tabnext'
	endif
	if a:preserve_win
		execute old_winnr 'wincmd w'
	endif
endfunction

function! DefineAugroupVisual()
	augroup Visual
		autocmd!
		if g:linenr
			execute "autocmd! ModeChanged {\<c-v>*,[vV]*}:* call Numbertoggle(mode())"
			execute "autocmd! ModeChanged *:{\<c-v>*,[vV]*} call Numbertoggle('v')"
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
function! HandleExNvimConfig()
	if g:background ==# "dark"
		set background=dark
	elseif g:background ==# "light"
		set background=light
	else
		echohl ErrorMsg
		if g:language ==# 'russian'
			echomsg "extra.nvim конфиг: блядь: неправильное значение заднего фона: ".g:background
		else
			echomsg "extra.nvim config: Error: wrong background value: ".g:background
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
call HandleExNvimConfig()
function! Update_CursorLine_Style()
	if exists('g:updating_cursorline_supported')
		call Update_CursorLine()
	else
		execute "colorscheme" g:colors_name
	endif
endfunction
function! RehandleExNvimConfig()
	if exists('g:cursorline_style_supported')
		let g:cursorline_style = index(g:cursorline_style_supported, g:cursorline_style)
		if g:cursorline_style ==# -1
			let g:cursorline_style = 0
		endif
		call Update_CursorLine_Style()
	endif
endfunction

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

if has('nvim')
	execute "luafile ".expand(g:CONFIG_PATH)."/lua/lib/vim/plugins.lua"
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
endfunction
function! WhenceGroup()
	let l:s = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
	execute "verbose hi ".l:s
endfunction

function! GetRandomName(length)
	let name = "Rnd_"
	for _ in range(a:length)
		let r = rand() % 3 + 1
		if v:false
		elseif r ==# 1
			let name .= nr2char(rand() % 10 + 48)
		elseif r ==# 2
			let name .= nr2char(rand() % 26 + 65)
		elseif r ==# 3
			let name .= nr2char(rand() % 26 + 97)
		else
			echohl ErrorMsg
			echomsg "Internal error"
			echohl Normal
		endif
	endfor
	unlet r
	return name
endfunction
function! GenerateTemporaryAutocmd(event, pattern, command, delete_when)
	let random_name = GetRandomName(20)
	exec 'augroup '.random_name
		autocmd!
		execute "autocmd ".a:event." ".a:pattern." ".a:command."|".a:delete_when(random_name)
	augroup END
endfunction
function! AfterSomeEvent(event, command, delete_when={name -> 'au! '.name})
	call GenerateTemporaryAutocmd(a:event, '*', a:command, a:delete_when)
endfunction
let g:please_do_not_close = v:false
function! MakeThingsThatRequireBeDoneAfterPluginsLoaded()
	autocmd TermClose * if !g:please_do_not_close && !exists('g:bufnrforranger')|call AfterSomeEvent('TermLeave', 'call Numbertoggle()')|call OnQuit()|exec "confirm quit"|call OnQuitDisable()|endif
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
function! SetGitBranch()
	let s:gitbranch = split(system('git rev-parse --abbrev-ref HEAD 2> /dev/null'))
	if len(s:gitbranch) > 0
		let s:gitbranch = s:gitbranch[0]
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
	if v:false
	elseif v:false
	\|| &filetype ==# 'neo-tree'
	\|| &filetype ==# 'musicplayer'
		return bufname('')
	endif
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
	elseif mode == "\<c-v>"
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
		echohl ErrorMsg
		if g:language ==# 'russian'
			echomsg "блядь: Неправильный режим: ".mode()
		else
			echomsg "error: Wrong mode: ".mode()
		endif
		echohl Normal
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
	let is_macro_recording = reg_recording()
	if is_macro_recording !=# ''
		let s:result .= '%#Statusline0mac#'
		if is_macro_recording =~# '^\u$'
			let s:result .= '%#Statuslinemac# REC '.is_macro_recording.' '
		else
			let s:result .= '%#Statuslinemac# rec '.is_macro_recording.' '
		endif
	endif
	if &columns ># 45
		if g:compatible !=# "helix_hard"
			if is_macro_recording !=# ''
				let s:result .= '%#Statuslinemac1#'
			else
				let s:result .= '%#Statuslinestat01#'
			endif
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
set statusline=%#Loading25#Loading\ 25%%
command! -nargs=0 Showtab set stl=%{%Showtab()%}

command! -nargs=* Pkg !pkg <args>
function! DotfilesCommit()
	cd ~/dotfiles
	!dotfiles commit --only-copy
	Git commit --all --verbose
endfunction
command! -nargs=0 DotfilesCommit call DotfilesCommit()
function! ExNvimCommit()
	cd ~/extra.nvim
	!exnvim commit --only-copy
	Git commit --all --verbose
endfunction
command! -nargs=0 ExNvimCommit call ExNvimCommit()

function! GenerateExNvimConfig()
	tabnew
	if !executable('exnvim')
		echohl ErrorMsg
		echomsg "error: exnvim not installed"
		echohl Normal
		return
	endif
	call OpenTerm('exnvim setup')
endfunction
command! -nargs=0 GenerateExNvimConfig call GenerateExNvimConfig()
nnoremap <leader>G <cmd>GenerateExNvimConfig<cr>

function! MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let original_buf_name = bufname(buflist[winnr - 1])
	let bufnr = bufnr(original_buf_name)
	let buftype = getbufvar(bufnr, '&buftype')
	let filetype = getbufvar(bufnr, '&filetype')
	if v:false
	elseif buftype ==# "terminal"
		if g:language ==# 'russian'
			let buf_name = '[Терм]'
		else
			let buf_name = '[Term]'
		endif
	elseif filetype ==# "alpha"
		if g:language ==# 'russian'
			let buf_name = '[Меню]'
		else
			let buf_name = '[Menu]'
		endif
	elseif filetype ==# "spectre_panel"
		if g:language ==# 'russian'
			let buf_name = '[Spectre]'
		else
			let buf_name = '[Spectre]'
		endif
	elseif filetype ==# "neo-tree"
		if g:language ==# 'russian'
			let buf_name = '[NeoTree]'
		else
			let buf_name = '[NeoTree]'
		endif
	elseif filetype ==# "TelescopePrompt"
		if g:language ==# 'russian'
			let buf_name = '[Телескоп]'
		else
			let buf_name = '[Telescope]'
		endif
	elseif filetype ==# "gitcommit"
		if g:language ==# 'russian'
			let buf_name = '[Коммит]'
		else
			let buf_name = '[Commit]'
		endif
	elseif v:false
	\|| filetype ==# "packer"
		let buf_name = original_buf_name
	elseif buftype ==# "nofile"
		if g:language ==# 'russian'
			let buf_name = '[НеФайл]'
		else
			let buf_name = '[NoFile]'
		endif
	elseif original_buf_name == ''
		if g:language ==# 'russian'
			let buf_name = '[БезИмени]'
		else
			let buf_name = '[NoName]'
		endif
	else
		let buf_name = original_buf_name
		if g:tabline_path ==# "name"
			return fnamemodify(buf_name, ':t')
		elseif g:tabline_path ==# "short"
			return fnamemodify(buf_name, ':~:.')
		elseif g:tabline_path ==# "shortdir"
			return fnamemodify(buf_name, ':~:.:gs?\([^/]\)[^/]*/?\1/?')
		elseif g:tabline_path ==# "full"
			return fnamemodify(buf_name, ':p')
		endif
		echohl ErrorMsg
		echomsg "extra.nvim: config: error: wrong tabline_path: ".g:tabline_path
		echohl Normal
		return 0
	endif
	return buf_name
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
		elseif getbufvar(bufnr, '&filetype') ==# 'erlang'
			let s ..= ' '
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
set statusline=%#Loading38#Loading\ 37.5%%
if g:compatible !=# "helix_hard"
	set tabline=%!MyTabLine()
endif

" Edit options
set hidden
set nowrap
set nolinebreak
let &breakat = "    !¡@*-+;:,./?¿{}[]^%&"
if has('nvim')
	set nolist
else
	set list
endif
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
  autocmd BufLeave * let b:winview = winsaveview()
  autocmd BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif

nnoremap <silent> dd ddk
nnoremap <silent> - dd
nnoremap <silent> + mz<cmd>let line=getline('.')<bar>call append(line('.'), line)<cr>`zj

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

nnoremap <leader>xg <cmd>grep <cword> .<cr>

function! RedefineProcessGBut()
let process_g_but_function_expression = "
\function! ProcessGBut(button)
\"
if !g:disable_animations
if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
let process_g_but_function_expression .= "
\\n	let old_c=col('.')
\\n	let old_l=line('.')
\"
endif
if g:fast_terminal
let process_g_but_function_expression .= "
\\n	if &buftype !=# 'terminal'
\\n		set lazyredraw
\\n	endif
\"
endif
if has('nvim')
let process_g_but_function_expression .= "
\\n	execute \"lua << EOF
\\\nlocal button ="
if g:do_not_save_previous_column_position_when_going_up_or_down&&g:compatible ==# "helix" || g:compatible ==# "helix_hard"
let process_g_but_function_expression .= "\\\"mz`z\\\".."
endif
let process_g_but_function_expression .= "
\(vim.v.count == 0 and \'g\".a:button.\"\' or \'\".a:button.\"\')
\"
if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
let process_g_but_function_expression .= "
\\\nif vim.g.pseudo_visual then
\\\n    button = \\\"\\<esc>\\\"..button
\\\nend"
endif
let process_g_but_function_expression .= "
\\\nfor _=1,vim.v.count1,1 do
\\\nvim.api.nvim_feedkeys(button,\\\"n\\\",false)
\\\nend
\\\nEOF\"
\\n"
else
let process_g_but_function_expression .= "
\\nif v:count ==# 0
\\nexe \"norm! g\".a:button
\\nelse
\\nexe \"norm! \".v:count1.a:button
\\nendif
\\n"
if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
let process_g_but_function_expression .= "
\\nif g:pseudo_visual
\\n	call feedkeys(\"\\<c-\\>\\<c-n>\")
\\nendif
\\n"
endif
endif

if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
	let process_g_but_function_expression .= "
	\\n	call ReorderRightLeft()
	\\n	call SavePosition(old_c, old_l, col('.'), line('.'))
	\"
endif

if g:fast_terminal
let process_g_but_function_expression .= "
\\n	if &buftype !=# 'terminal'
\\n		set nolazyredraw
\\n	endif
\"
endif
else
let process_g_but_function_expression .= "
\\n	let button=v:count==#0?\"g\".a:button:a:button
\"
if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
let process_g_but_function_expression .= "
\\n	let old_c=col('.')
\\n	let old_l=line('.')
\"
endif
let process_g_but_function_expression .= "
\\n	execute \"norm! \".v:count1.button
\"
if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
let process_g_but_function_expression .= "
\\n	if g:pseudo_visual
\\n		call feedkeys(\"\\<c-\\>\\<c-n>\")
\\n	endif
\\n	call ReorderRightLeft()
\\n	call SavePosition(old_c, old_l, col('.'), line('.'))
\"
endif
endif
let process_g_but_function_expression .= "
\\nendfunction"
execute process_g_but_function_expression
endfunction
call RedefineProcessGBut()

function! JKWorkaroundAlpha()
	noremap <buffer> j <cmd>call ProcessGBut('j')<cr>
	noremap <buffer> k <cmd>call ProcessGBut('k')<cr>
	if !g:open_cmd_on_up
		noremap <up> <cmd>call ProcessGBut('k')<cr>
	endif
	noremap <down> <cmd>call ProcessGBut('j')<cr>
endfunction
function! JKWorkaround()
	noremap k <cmd>call ProcessGBut('k')<cr>
	if !isdirectory(g:LOCALSHAREPATH.'/site/pack/packer/start/endscroll.nvim')
		noremap j <cmd>call ProcessGBut('j')<cr>
	endif
endfunction
call JKWorkaround()

noremap <c-a> 0
noremap <c-e> $
inoremap <c-a> <home>
inoremap <c-e> <end>

cnoremap <c-a> <c-b>
cnoremap <c-g> <c-e><c-u><cr>
if g:insert_exit_on_jk
	cnoremap jk <c-e><c-u><cr><cmd>echon ''<cr>
endif
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
		if luaeval("plugin_installed(_A[1])", ["neo-tree.nvim"]) && isdirectory(expand(filename))
			tabedit
			execute printf("Neotree position=current %s", filename)
		else
			execute printf("tabedit %s", filename)
		endif
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
		if luaeval("plugin_installed(_A[1])", ["neo-tree.nvim"]) && isdirectory(expand(filename))
			execute printf("Neotree position=current %s", filename)
		else
			execute printf("edit %s", filename)
		endif
	endif
endfunction
command! -nargs=0 Findfilebuffer call Findfilebuffer()
noremap <c-c>C <cmd>Findfilebuffer<cr>
noremap <c-c>% <cmd>split<cr>
noremap <c-c>" <cmd>vsplit<cr>
noremap <c-c>w <cmd>confirm quit<cr>
for i in range(1, 9)
	execute "noremap <c-c>".i." <cmd>tabnext ".i."<cr>"
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
		execute a:command(filename)
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
	if g:prefer_far_or_mc ==# "far"
		if executable("far")
			let g:far_or_mc = 'far'
		elseif executable("far2l")
			let g:far_or_mc = 'far2l'
		else
			let g:far_or_mc = 'mc'
		endif
	elseif g:prefer_far_or_mc ==# "mc"
		if executable("mc")
			let g:far_or_mc = 'far'
		elseif executable("far")
			let g:far_or_mc = 'far'
		else
			let g:far_or_mc = 'far2l'
		endif
	else
		echohl ErrorMsg
		if g:language ==# "russian"
			echomsg "блядь: конфиг: неправильное значение опции \"prefer_far_or_mc\": ".g:prefer_far_or_mc
		else
			echomsg "error: config: wrong option \"prefer_far_or_mc\" value: ".g:prefer_far_or_mc
		endif
		echohl Normal
		let g:prefer_far_or_mc = 'far'
		call FarOrMc()
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
			execute a:positions[position]['command'](a:cmd)
		else
			echohl ErrorMsg
			if g:language ==# 'russian'
				echomsg "Блядь: Неправильная позиция: ".position
			else
				echomsg "Error: Wrong position: ".position
			endif
			echohl Normal
			return 1
		endif
		break
	endwhile
endfunction
set statusline=%#Loading50#Loading\ 50%%

if has('nvim') && luaeval("plugin_installed(_A[1])", ["neo-tree.nvim"])
	let s:dir_position_left =
		\{cmd -> 'Neotree position=left '.cmd}
	let s:dir_position_right =
		\{cmd -> 'Neotree position=right '.cmd}
	let s:dir_position_current =
		\{cmd -> 'Neotree position=current '.cmd}
	let s:dir_position_float =
		\{cmd -> 'Neotree position=float '.cmd}
else
	let s:dir_position_left =
		\{cmd -> 'Neotree position=left '.cmd}
	let s:dir_position_right =
		\{cmd -> 'Neotree position=right '.cmd}
	let s:dir_position_current =
		\{cmd -> 'Explore'.cmd}
	if g:language ==# 'russian'
		let s:messagefloating_windows_are_not_supported_in_vim = 'блядь: Плавающие окна не поддерживаются в Vim''е'
	else
		let s:messagefloating_windows_are_not_supported_in_vim = 'error: Floating windows are not supported in Vim'
	endif
	let s:dir_position_float =
		\{cmd -> 'echohl ErrorMsg|echomsg "'.s:messagefloating_windows_are_not_supported_in_vim.'"|echohl Normal'.cmd}
	unlet s:messagefloating_windows_are_not_supported_in_vim
endif
if g:language ==# 'russian'
	let g:stdpos = {
		\ 'h': {'button_label': '&s:ГорРаздел', 'command': {cmd -> 'split '.cmd}},
		\ 'v': {'button_label': '&v:ВерРаздел', 'command': {cmd -> 'vsplit '.cmd}},
		\ 'b': {'button_label': '&b:Буффер', 'command': {cmd -> 'e '.cmd}},
		\ 't': {'button_label': '&t:НовВкладк', 'command': {cmd -> 'tabnew|e '.cmd}},
	\ }
	let g:dirpos = {
		\ 'l': {'button_label': '&v:Слева', 'command': s:dir_position_left},
		\ 'r': {'button_label': '&r:Справа', 'command': s:dir_position_right},
		\ 'b': {'button_label': '&b:Буффер', 'command': s:dir_position_current},
		\ 'f': {'button_label': '&f:Плавающее', 'command': s:dir_position_float},
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
	let g:dirpos = {
		\ 'l': {'button_label': '&v:Left', 'command': s:dir_position_left},
		\ 'r': {'button_label': '&Right', 'command': s:dir_position_right},
		\ 'b': {'button_label': '&Buffer', 'command': s:dir_position_current},
		\ 'f': {'button_label': '&Floating', 'command': s:dir_position_float},
	\ }
	let g:termpos = {
		\ 'h': {'button_label': '&Split', 'command': {cmd -> 'split|call OpenTerm("'.cmd.'")'}},
		\ 'v': {'button_label': '&Vsplit', 'command': {cmd -> 'vsplit|call OpenTerm("'.cmd.'")'}},
		\ 'b': {'button_label': '&Buffer', 'command': {cmd -> 'call OpenTerm("'.cmd.'")'}},
		\ 't': {'button_label': 'New &tab', 'command': {cmd -> 'tabnew|call OpenTerm("'.cmd.'")'}},
		\ 'f': {'button_label': '&Floating', 'command': {cmd -> 'FloatermNew '.cmd}},
	\ }
endif
unlet s:dir_position_left
unlet s:dir_position_right
unlet s:dir_position_current
unlet s:dir_position_float

augroup AlphaNvim_CinnamonNvim_JK_Workaround
	autocmd!
	autocmd FileType alpha call JKWorkaroundAlpha()  | call AfterSomeEvent('BufLeave', 'call JKWorkaround()')
augroup END

let g:LUA_REQUIRE_GOTO_PREFIX_DEFAULT = [$HOME]
let g:LUA_REQUIRE_GOTO_PREFIX = g:LUA_REQUIRE_GOTO_PREFIX_DEFAULT
function! Lua_Require_Goto_Workaround_Wincmd_f()
	if !filereadable(expand(g:LOCALSHAREPATH).'/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim')
		echohl Question
		if g:language ==# 'russian'
			let lua_require_goto_workaround_wincmd_f_dialogue_label = 'Выберите способ перехода %s: '
		else
			let lua_require_goto_workaround_wincmd_f_dialogue_label = 'Select goto way %s: '
		endif
		echon printf(lua_require_goto_workaround_wincmd_f_dialogue_label, ["n", "r"])
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
		let choice = quickui#confirm#open(dialogue_label, "&Normal\n`&require`", 1, 'Confirm')
	endif
	if choice ==# 0
		echohl ErrorMsg
		echomsg "Goto way is null"
		echohl Normal
		return
	endif
	if v:false
	elseif choice ==# 1
		execute printf("split %s", expand("<cword>"))
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
				let startcol = end + 1
				continue
			endif
			let filename = strpart(line, start + 1, end - start - 1)
			let filename = substitute(filename, '\.', '\/', 'g')
			let file_found = v:false
			for i in g:LUA_REQUIRE_GOTO_PREFIX
				if !filereadable(i.filename.'.lua')
					let startcol = end
					continue
				endif
				split
				let goto_buffer = bufadd(i.filename.'.lua')
				call bufload(goto_buffer)
				exec goto_buffer."buffer"
				normal! `"
				let file_found = v:true
				return
			endfor
			echohl ErrorMsg
			echomsg "file not found, editing a new file"
			echohl Normal
			let goto_buffer = bufadd(g:LUA_REQUIRE_GOTO_PREFIX[0].filename.'.lua')
			call bufload(goto_buffer)
			exec goto_buffer."buffer"
			normal! `"
			return
		endwhile
		echohl ErrorMsg
		echomsg "extra.nvim: Lua_Require_Goto_Workaround_Wincmd_f: Internal error: unreachable code"
		echohl Normal
	else
		echohl ErrorMsg
		if g:language ==# 'russian'
			echomsg printf("Неправильный способ перехода: %s", choice)
		else
			echomsg printf("Wrong goto way: %s", choice)
		endif
		echohl Normal
	endif
endfunction
augroup Lua_Require_Goto_Workaround
	autocmd!
	autocmd FileType lua exec "noremap <buffer> <c-w>f <cmd>call Lua_Require_Goto_Workaround_Wincmd_f()<cr>"
augroup END

function! HandleExNvimOptionsInComment()
	if !exists('*Trim') || !exists('*StartsWith')
		echohl ErrorMsg
		if g:language ==# 'russian'
			echomsg "блядь: библиотеку со строками импортируй"
		else
			echomsg "error: library with strings is not imported"
		endif
		echohl Normal
		return
	endif
	let commentstring = substitute(&commentstring, '%s', '', '')
	if commentstring ==# ''
		return
	endif
	let default_comment_string_len = commentstring
	let LUA_REQUIRE_GOTO_PREFIX_idx = 0
	let i = 1
	let lastline = line('$')
	while i <# lastline + 1
		let line = getline(i)
		let line = Trim(line)
		if !StartsWith(line, commentstring)
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
		if option !=# 'ExNvimOptionInComment'
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
		let option_value_len = len(option_value)
		let option_calculated = ''
		let vartype = ''
		let varname = ''
		let wrong_var = v:false
		let j = 0
		while j < option_value_len
			let c = option_value[j]
			if c ==# '%'
				if v:false
				elseif vartype ==# ''
					let vartype = 'vim'
					let varname = ''
				elseif vartype ==# 'vim'
					let vartype = ''
					if varname ==# ''
						let option_calculated .= '%'
					else
						if varname !~# '^[a-zA-Z0-9_]\+$'
							echohl ErrorMsg
							echomsg "error: Using special symbols in vim variable is not allowed"
							echohl Normal
							let wrong_var = v:true
							break
						endif
						execute "let option_calculated .= expand(g:".varname.")"
					endif
				elseif vartype ==# 'shell'
					echohl ErrorMsg
					echomsg "error: Cannot use '%' in shell variables"
					echohl Normal
					let wrong_var = v:true
					break
				else
					echohl ErrorMsg
					echomsg "extra.nvim: internal error: wrong vartype: ".vartype
					echohl Normal
					let wrong_var = v:true
					break
				endif
			elseif c ==# '$'
				if v:false
				elseif vartype ==# ''
					let vartype = 'shell'
					let varname = ''
				elseif vartype ==# 'vim'
					echohl ErrorMsg
					echomsg "error: Cannot use '$' in vim variables"
					echohl Normal
					let wrong_var = v:true
					break
				elseif vartype ==# 'shell'
					let vartype = ''
					if varname ==# ''
						let option_calculated .= '$'
					else
						if varname !~# '^[a-zA-Z0-9_]\+$'
							echohl ErrorMsg
							echomsg "error: Using special symbols in shell variable is not allowed"
							echohl Normal
							let wrong_var = v:true
							break
						endif
						let option_calculated .= getenv(varname)
					endif
				else
					echohl ErrorMsg
					echomsg "extra.nvim: internal error: wrong vartype: ".vartype
					echohl Normal
					let wrong_var = v:true
					break
				endif
			else
				if v:false
				elseif vartype ==# ''
					let option_calculated .= c
				elseif vartype ==# 'vim'
					let varname .= c
				elseif vartype ==# 'shell'
					let varname .= c
				else
					echohl ErrorMsg
					echomsg "extra.nvim: internal error: wrong vartype: ".vartype
					echohl Normal
					let wrong_var = v:true
					break
				endif
			endif
			let j += 1
		endwhile
		if v:false
		elseif vartype ==# ''
			execute
		elseif vartype ==# 'vim'
			let option_calculated .= '%'
		elseif vartype ==# 'shell'
			let option_calculated .= '$'
		else
			echohl ErrorMsg
			echomsg "extra.nvim: internal error: wrong vartype: ".vartype
			echohl Normal
		endif
		if vartype !=# ''
			let option_calculated .= varname
		endif
		if !wrong_var
			if v:false
			\|| option_name ==# 'LUA_REQUIRE_GOTO_PREFIX'
				if LUA_REQUIRE_GOTO_PREFIX_idx ==# 0
					let g:LUA_REQUIRE_GOTO_PREFIX = []
				endif
				call add(g:LUA_REQUIRE_GOTO_PREFIX, option_calculated)
				let LUA_REQUIRE_GOTO_PREFIX_idx += 1
			endif
		endif
		let i += 1
	endwhile
endfunction
augroup ExNvimOptionsInComment
	autocmd!
	autocmd BufEnter * if v:vim_did_enter|call HandleExNvimOptionsInComment()|endif
augroup END

nnoremap * *<cmd>noh<cr>
nnoremap <c-*> *
nnoremap # #:noh<cr>
nnoremap <c-#> #

noremap <leader>l 2zl2zl2zl2zl2zl2zl
noremap <leader>h 2zh2zh2zh2zh2zh2zh
if g:fast_terminal
	inoremap <c-l> <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>set lazyredraw<cr><cmd>normal! 10zl<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr><cmd>call HandleBuftype(winnr())<cr>
	inoremap <c-h> <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>set lazyredraw<cr><cmd>normal! 10zh<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr><cmd>call HandleBuftype(winnr())<cr>
else
	inoremap <c-l> <cmd>exe"norm! 10zl"<cr>
	inoremap <c-h> <cmd>exe"norm! 10zh"<cr>
endif
let s:SCROLL_FACTOR = 2
let s:SCROLL_UP_FACTOR = s:SCROLL_FACTOR
let s:SCROLL_DOWN_FACTOR = s:SCROLL_FACTOR
let s:SCROLL_C_E_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_C_Y_FACTOR = s:SCROLL_DOWN_FACTOR
let s:SCROLL_MOUSE_UP_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_MOUSE_DOWN_FACTOR = s:SCROLL_DOWN_FACTOR
execute printf("noremap <silent> <expr> <c-Y> \"%s<c-e>\"", s:SCROLL_C_E_FACTOR)
execute printf("noremap <silent> <expr> <c-y> \"%s<c-y>\"", s:SCROLL_C_Y_FACTOR)
let s:SCROLL_UPDATE_TIME = 1000
call timer_start(s:SCROLL_UPDATE_TIME, {->STCUpd()}, {'repeat': -1})
execute printf("noremap <ScrollWheelDown> %s<c-e>", s:SCROLL_MOUSE_DOWN_FACTOR)
execute printf("noremap <ScrollWheelUp> %s<c-y>", s:SCROLL_MOUSE_UP_FACTOR)

noremap <silent> <leader>st <cmd>lua require('spectre').toggle()<cr><cmd>call Numbertoggle()<cr>
nnoremap <silent> <leader>sw <cmd>lua require('spectre').open_visual({select_word = true})<cr><cmd>call Numbertoggle()<cr>
vnoremap <silent> <leader>sw <cmd>lua require('spectre').open_visual()<cr><cmd>call Numbertoggle()<cr>
noremap <silent> <leader>sp <cmd>lua require('spectre').open_file_search({select_word = true})<cr><cmd>call Numbertoggle()<cr>

" NVIMRC FILE
let g:PLUGINS_INSTALL_FILE_PATH = '~/.config/nvim/lua/packages/plugins.lua'
let g:PLUGINS_SETUP_FILE_PATH = '~/.config/nvim/lua/packages/plugins_setup.lua'
let g:LSP_PLUGINS_SETUP_FILE_PATH = '~/.config/nvim/lua/packages/lsp/plugins.lua'

set statusline=%#Loading63#Loading\ 62.5%%
execute printf('noremap <silent> <leader>ve <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:CONFIG_PATH."/init.vim")
execute printf("noremap <silent> <leader>se <esc>:so %s<cr>", g:CONFIG_PATH.'/vim/exnvim/reload.vim')

execute printf('noremap <silent> <leader>vi <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:PLUGINS_INSTALL_FILE_PATH)
execute printf("noremap <silent> <leader>si <esc>:so %s<cr>", g:PLUGINS_INSTALL_FILE_PATH)

execute printf('noremap <silent> <leader>vs <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:PLUGINS_SETUP_FILE_PATH)
execute printf("noremap <silent> <leader>ss <esc>:so %s<cr>", g:PLUGINS_SETUP_FILE_PATH)

execute printf('noremap <silent> <leader>vl <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:LSP_PLUGINS_SETUP_FILE_PATH)
execute printf("noremap <silent> <leader>sl <esc>:so %s<cr>", g:LSP_PLUGINS_SETUP_FILE_PATH)

execute printf('noremap <silent> <leader>vj <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:EXNVIM_CONFIG_PATH)
execute printf('noremap <silent> <leader>sj <cmd>call LoadExNvimConfig("%s", v:true)<cr><cmd>call HandleExNvimConfig()<cr><cmd>call HandleBuftypeAll()<cr>', expand(g:EXNVIM_CONFIG_PATH))

" .dotfiles-script.sh FILE
" See https://github.com/TwoSpikes/dotfiles.git
if filereadable(expand("~/.dotfiles-script.sh"))
	noremap <silent> <leader>vb <cmd>call SelectPosition("~/.dotfiles-script.sh", g:stdpos)<cr>
endif

autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   execute "normal! g`\"" |
     \ endif

" MY .nvimrc HELP
function! ExNvimCheatSheet()
	let old_bufnr = bufnr()
	let bufnr = bufadd('help')
	call bufload(bufnr)
	execute bufnr.'buffer'
	call append(line('$'), split("
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
	\\n    LEAD vj - Open extra.nvim config
	\\n    LEAD sj - Reload extra.nvim config
	\\n    LEAD vb - Open .dotfiles-script.sh
	\\n        See: https://github.com/TwoSpikes/dotfiles.git
	\\n    LEAD vc - Open colorschemes
	\\n    LEAD vC - Apply colorscheme under cursor
	\\n SPECIAL:
	\\n   ; - Switch to command mode (:)
	\\n   LEAD 1 - Switch to command mode (:)
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
	\\n   LEAD c - Comment selected / current line
	\\n   LEAD C - Uncomment selected / current line
	\\n   INSERT: CTRL-h - Move screen 10 symbols left
	\\n   INSERT: CTRL-l - Move screen 10 symbols right
	\\n   CTRL-h - Toggle Neo-tree
	\\n   CTRL-n - Enter multicursor mode
	\\n   ci_ - Edit word from start to first `_`
	\\n   LEAD d  - Hide search highlightings
	\\n   s - Jump to a 2-character label
	\\n   q - Quit window
	\\n   Q - Quit window without saving
	\\n   LEAD r - Open ranger to select file to edit
	\\n   LEAD CTRL-s - \"Save as\" dialogue
	\\n   LEAD up - Update plugins using packer.nvim
	\\n   LEAD uc - Update coc.nvim language servers
	\\n   LEAD ut - Update nvim-treesitter parsers
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
	\\n   CTRL-x h - Select all text and save position to register `y`
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
	\\n  Helix-compatible mode commands:
	\\n    p - Paste after and set cursor at the end of pasted text
	\\n    P - Paste before and set cursor at the end of pasted text
	\\n    gp - Paste after and set cursor at the start of pasted text
	\\n    gP - Paste before and set cursor at the start of pasted text
	\\n    LEAD xo - See :h v_o
	\\n    LEAD xO - See :h v_O
	\\n    g. - See :h g;
	\\n    gw - See :h sneak|50
	\\n  ABOUT:
	\\n    Author: TwoSpikes (2023 - 2024)
	\\n    Github repository: https://github.com/TwoSpikes/extra.nvim
	\\n    Also see: https://github.com/TwoSpikes/dotfiles
	\", "\n"))
	1delete
	setlocal nomodified
	setlocal nomodifiable
	setlocal buftype=nofile
	setlocal filetype=book
	call Numbertoggle('n')
	execute "noremap <buffer> q <cmd>execute bufnr().\"bwipeout!\"<bar>".old_bufnr."buffer<cr>"
endfunction
command! -nargs=0 ExNvimCheatSheet call ExNvimCheatSheet()
noremap <silent> <leader>? <cmd>ExNvimCheatSheet<cr>

" FAST COMMANDS
"noremap ; :
noremap <silent> <leader>: :<c-f>a
"noremap <leader>= :tabe 
"noremap <leader>- :e 
noremap <leader>= <cmd>ec"use \<c-c\>c"<cr>
noremap <leader>- <cmd>ec"use \<c-c\>C"<cr>
noremap <leader>1 :!
nnoremap <leader>up <cmd>lua require('packer').sync()<cr>

" QUOTES AROUND (DEPRECATED BECAUSE OF surround.vim)
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

" SPECIAL
nnoremap ci_ yiwct_
noremap <silent> <leader>d <cmd>nohlsearch<cr>
nnoremap <silent> <esc> <cmd>let @/ = ""<cr>
inoremap <c-c> <c-c><cmd>call Numbertoggle()<cr>

" TERMINAL
function! OpenTerm(cmd)
	if !&modifiable
		wincmd p
		let prevwinid = win_getid(winnr(), tabpagenr())
		wincmd p
		new
		wincmd p
		close
		wincmd p
		call win_gotoid(prevwinid)
		wincmd p
	endif
	if a:cmd ==# ""
		execute printf("terminal %s", $SHELL)
	else
		execute printf("terminal %s", a:cmd)
	endif
	startinsert
	return bufnr()
endfunction
noremap <silent> <leader>t <cmd>call SelectPosition($SHELL, g:termpos)<cr>

" COLORSCHEME
noremap <silent> <leader>vc <cmd>call SelectPosition($VIMRUNTIME."/colors", g:dirpos)<cr>
noremap <silent> <leader>vC <cmd>set lazyredraw<cr>yy:<c-f>pvf]o0"_dxicolo <esc>$x$x$x$x<cr>jzb<cmd>set nolazyredraw<cr>

noremap <silent> <leader>uc <cmd>CocUpdate<cr>
noremap <silent> <leader>ut <cmd>TSUpdate<cr>

function! Save_WW_and_Do(cmd)
	let old_whichwrap = &whichwrap
	let &whichwrap = 'b,s'
	execute a:cmd
	let &whichwrap = old_whichwrap
endfunction
function! Comment_Move_Left(comment_string)
	call Save_WW_and_Do('normal! '.Defone(len(a:comment_string)).'h')
endfunction
function! Comment_Move_Right(comment_string)
	call Save_WW_and_Do('normal! '.Defone(len(a:comment_string)).'l')
endfunction
function! N_CommentOut(comment_string)
	let l=line('.')
	call setline(l, substitute(a:comment_string, '%s', Repr_Vim_Grep(getline(l)), ''))
	call Comment_Move_Right(substitute(a:comment_string, '%s', '', ''))
endfunction
function! X_CommentOut(comment_string)
	let line_start = getpos("'<")[1]
	let line_end = getpos("'>")[1]
	for line in range(line_start, line_end)
		call setline(line, substitute(a:comment_string, '%s', Repr_Vim_Grep(getline(line)), ''))
	endfor
	call Comment_Move_Right(substitute(a:comment_string, '%s', '', ''))
	call PV()
endfunction
function! CommentOutDefault_Define(mode)
	execute "
	\function! ".a:mode."_CommentOutDefault()
	\\n	if &commentstring !=# ''
	\\n		return ".a:mode."_CommentOut(&commentstring)
	\\n	else
	\\n		echohl ErrorMsg
	\\n		if g:language ==# 'russian'
	\\n			echo \"Блядь: Комментарии недоступны\"
	\\n		else
	\\n			echo \"Error: Comments are not available\"
	\\n		endif
	\\n		echohl Normal
	\\n	endif
	\\nendfunction"
endfunction
call CommentOutDefault_Define('N')
call CommentOutDefault_Define('X')
function! DoCommentOutDefault()
	execute "normal! ".CommentOutDefault()
endfunction
function! N_UncommentOut(comment_string)
	let l=line('.')
	let line=getline(l)
	let comment=substitute(a:comment_string, '%s', '', '')
	call setline(l, substitute(line, comment, '', ''))
	call Comment_Move_Left(comment)
endfunction
function! X_UncommentOut(comment_string)
	let comment=substitute(a:comment_string, '%s', '', '')
	for l:idx in range(line("'>")-line("'<")+1)
		let l = line("'<") + l:idx
		let line=getline(l)
		call setline(l, substitute(line, comment, '', ''))
	endfor
	call Comment_Move_Left(comment)
	call PV()
endfunction
function! UncommentOutDefault_Define(mode)
	execute "
	\function! ".a:mode."_UncommentOutDefault()
	\\n	if &commentstring !=# ''
	\\n		call ".a:mode."_UncommentOut(&commentstring)
	\\n	else
	\\n		echohl ErrorMsg
	\\n		if g:language ==# 'russian'
	\\n			echomsg \"Блядь: Комментарии недоступны\"
	\\n		else
	\\n			echomsg \"Error: Comments are not available\"
	\\n		endif
	\\n		echohl Normal
	\\n	endif
	\\nendfunction"
endfunction
call UncommentOutDefault_Define('N')
call UncommentOutDefault_Define('X')
nnoremap <leader>c <cmd>call N_CommentOutDefault()<cr>
xnoremap <leader>c <c-\><c-n><cmd>call X_CommentOutDefault()<cr>
nnoremap <leader>C <cmd>call N_UncommentOutDefault()<cr>
xnoremap <leader>C <c-\><c-n><cmd>call X_UncommentOutDefault()<cr>
augroup netrw
	autocmd!
	autocmd filetype netrw setlocal nocursorcolumn | call Numbertoggle()
augroup END
augroup neo-tree
	autocmd!
	autocmd filetype neo-tree setlocal nocursorcolumn | call Numbertoggle()
augroup END
augroup terminal
	autocmd!
	if has('nvim')
		autocmd termopen * setlocal nocursorline nocursorcolumn | call STCNo()
	endif
augroup END
augroup visual
	function! HandleBuftype(winnum)
		let filetype = getwinvar(a:winnum, '&filetype', 'ERROR')
		let buftype = getwinvar(a:winnum, '&buftype', 'ERROR')

		let pre_cursorcolumn = (mode() !~# "[vVirco]" && mode() !~# "\<c-v>") && !s:fullscreen && filetype !=# 'netrw' && buftype !=# 'terminal' && filetype !=# 'neo-tree' && buftype !=# 'nofile'
		let pre_cursorcolumn = pre_cursorcolumn && g:cursorcolumn
		call setwinvar(a:winnum, '&cursorcolumn', pre_cursorcolumn)

		let pre_cursorline = !s:fullscreen
		if exists('g:cursorline_style_supported') && g:cursorline_style_supported[g:cursorline_style] ==# "reverse"
			let pre_cursorline = pre_cursorline && mode() !~# "[irco]"
			let pre_cursorline = pre_cursorline && (buftype !=# 'nofile' || filetype ==# 'neo-tree') && filetype !=# 'TelescopePrompt' && filetype !=# 'spectre_panel' && filetype !=# 'packer'
		endif
		let pre_cursorline = pre_cursorline && buftype !=# 'terminal' && filetype !=# 'alpha' && filetype !=# "notify"
		let pre_cursorline = pre_cursorline && g:cursorline
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
noremap <silent> q <cmd>confirm quit<cr>
noremap <silent> Q <cmd>quit!<cr>
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
		call PleaseDoNotCloseIfNotOneWin('bdelete!')
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
set statusline=%#Loading75#Loading\ 75%%
noremap <silent> <c-x><c-f> <cmd>Findfilebuffer<cr>
noremap <silent> <c-x>t0 <cmd>tabclose<cr>
noremap <silent> <c-x>t1 <cmd>tabonly<cr>
noremap <silent> <c-x>t2 <cmd>tabnew<cr>
noremap <silent> <c-x>to <cmd>tabnext<cr>
noremap <silent> <c-x>tO <cmd>tabprevious<cr>
noremap <silent> <c-x>5 <cmd>echo "Frames are only in Emacs/GNU Emacs"<cr>
noremap <m-x> :
let s:select_all_definition = ""
let s:select_all_definition .= "
\function! SelectAll()
\\n	mark y
\\n	normal! gg
\\n	let mode = mode()
\\n	if mode !~# '^v'
\\n		normal! v
\\n	else
\\n		normal! o
\\n	endif
\\n	normal! G$
\\n	echohl MsgArea
\\n	if g:language ==# 'russian'
\\n		echomsg 'Предыдущая позиция отмечена как \"y\"'
\\n	else
\\n		echomsg 'Previous position marked as \"y\"'
\\n	endif"
if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
let s:select_all_definition .= "
\\n	if mode !~? '^v'
\\n		let g:pseudo_visual = v:true
\\n		Showtab
\\n	endif
\\n	let g:visual_mode = \"char\"
\\n	let g:lx = 1
\\n	let g:ly = 1
\\n	let l:l = line('$')
\\n	let g:rx = l:l
\\n	let g:ry = len(getline(l:l))
\\n	call ReorderRightLeft()"
endif
let s:select_all_definition .= "
\\nendfunction"
exec s:select_all_definition
noremap <silent> <c-x>h <cmd>call SelectAll()<cr>
noremap <silent> <c-x><c-h> <cmd>h<cr>
noremap <silent> <c-x><c-g> <cmd>echo "Quit"<cr>

noremap mz <cmd>echohl ErrorMsg<cr><cmd>echom "mz is used for commands"<cr><cmd>echohl Normal<cr>
noremap my <cmd>echohl ErrorMsg<cr><cmd>echom "my is used for commands"<cr><cmd>echohl Normal<cr>

noremap <leader>q q
noremap <leader>Q Q

if g:insert_exit_on_jk
	if g:insert_exit_on_jk_save
		inoremap <silent> jk <esc><cmd>update<cr>
		inoremap <silent> JK <esc><cmd>update<cr>
	else
		inoremap <silent> jk <esc>
		inoremap <silent> JK <esc>
	endif
	inoremap <silent> jK <esc>
	inoremap <silent> Jk <esc>
endif
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

" tnoremap <silent> jk <c-\><c-n>
" tnoremap <silent> jK <c-\><c-n><cmd>let g:please_do_not_close=v:true<cr><cmd>:bd!<cr><cmd>tabnew<cr><cmd>call OpenTerm("")<cr><cmd>let g:please_do_not_close=v:false<cr>
" tnoremap <silent> <nowait> jj jj
command! -nargs=* Write write <args>

inoremap <silent> ju <esc>viwUea
inoremap <silent> ji <esc>viwuea

inoremap <silent> ( <cmd>call HandleKeystroke('(')<cr>
inoremap <silent> [ <cmd>call HandleKeystroke('[')<cr>
inoremap <silent> { <cmd>call HandleKeystroke('{')<cr>
function! HandleKeystroke(keystroke)
	let l = line('.')
	let line = getline(l)
	let col = col('.')
	let prev_c = line[col-2]
	let c = line[col-1]
	if a:keystroke ==# "\\\<bs>"
		if prev_c ==# '('
		\&& c ==# ')'
		\|| prev_c ==# '{'
		\&& c ==# '}'
		\|| prev_c ==# '['
		\&& c ==# ']'
		\|| prev_c ==# "'"
		\&& c ==# "'"
		\|| prev_c ==# '"'
		\&& c ==# '"'
		\|| prev_c ==# "`"
		\&& c ==# "`"
		\|| prev_c ==# '<'
		\&& c ==# '>'
			return "\<del>\<bs>"
		else
			return "\<bs>"
		endif
	endif
	if a:keystroke ==# ')'
	\&& c ==# ')'
	\|| a:keystroke ==# ']'
	\&& c ==# ']'
	\|| a:keystroke ==# '}'
	\&& c ==# '}'
	\|| a:keystroke ==# "'"
	\&& c ==# "'"
	\|| a:keystroke ==# '"'
	\&& c ==# '"'
	\|| a:keystroke ==# "`"
	\&& c ==# "`"
		return "\<right>"
	endif
	if a:keystroke ==# '"'
	\|| a:keystroke ==# "'"
	\|| a:keystroke ==# "`"
		if v:false
		\|| c =~# "[a-zA-Z0-9]"
		\|| prev_c =~# "[a-zA-Z0-9]"
			return a:keystroke
		else
			return a:keystroke.a:keystroke."\<left>"
		endif
	endif
	let mode = mode()
	if v:false
	elseif a:keystroke ==# '('
		if c =~# "[a-zA-Z0-9]"
			execute "normal! i(\<right>"
		else
			normal! i()
		endif
	elseif a:keystroke ==# '['
		if c =~# "[a-zA-Z0-9]"
			execute "normal! i[\<right>"
		else
			normal! i[]
		endif
	elseif a:keystroke ==# '{'
		if c =~# "[a-zA-Z0-9]"
			execute "normal! i{\<right>"
		else
			normal! i{}
		endif
	else
		return a:keystroke
	endif
	call Numbertoggle(mode)
endfunction
inoremap <expr> ) HandleKeystroke(')')
inoremap <expr> ] HandleKeystroke(']')
inoremap <expr> } HandleKeystroke('}')
inoremap <expr> ' HandleKeystroke("'")
inoremap <expr> " HandleKeystroke('"')
inoremap <expr> ` HandleKeystroke("`")
inoremap <expr> <bs> HandleKeystroke('\<bs>')

function! InitPacker()
	execute "source ".g:CONFIG_PATH.'/vim/plugins/setup.vim'

	execute printf("luafile %s", g:PLUGINS_INSTALL_FILE_PATH)
	PackerInstall
	execute printf("luafile %s", g:PLUGINS_SETUP_FILE_PATH)
endfunction

set nolazyredraw
if has('nvim')
	if executable('git')
		if !isdirectory(g:LOCALSHAREPATH.."/site/pack/packer/start/packer.nvim")
			echomsg "Installing packer.nvim"
			!git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
		endif
		call InitPacker()
	else
		echohl ErrorMsg
		echomsg "Please install Git"
		echohl Normal
	endif
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

noremap <silent> <f10> <cmd>call ChangeNames()<bar>call RebindMenus()<bar>call quickui#menu#open()<cr>
noremap <silent> <f9> <cmd>call ChangeNames()<bar>call RebindMenus()<bar>call quickui#menu#open()<cr>

nnoremap <silent> <c-x><c-b> <cmd>call quickui#tools#list_buffer('e')<cr>

function! SwapHiGroup(group)
    let id = synIDtrans(hlID(a:group))
    for mode in ['cterm', 'gui']
        for g in ['fg', 'bg']
            execute 'let '. mode.g. "=  synIDattr(id, '".
                        \ g."#', '". mode. "')"
            execute "let ". mode.g. " = empty(". mode.g. ") ? 'NONE' : ". mode.g
        endfor
    endfor
    execute printf('hi %s ctermfg=%s ctermbg=%s guifg=%s guibg=%s', a:group, ctermbg, ctermfg, guibg, guifg)
endfunction

augroup on_resized
	au!
	au VimResized * mode
augroup END

let g:floaterm_width = 1.0
noremap <leader>z <cmd>call SelectPosition('lazygit', g:termpos)<cr>
noremap <leader>m <cmd>call SelectPosition(g:far_or_mc, g:termpos)<cr>

function! OpenTermProgram()
	if has('nvim') && luaeval("plugin_installed(_A[1])", ["vim-quickui"])
		let select = quickui#input#open(Pad('Open terminal program:', 40), g:last_open_term_program)
	else
		let hcm_select_label = 'Open in terminal'.(g:last_open_term_program!=#''?' (default: '.g:last_open_term_program.')':'').': '
		let select = input(hcm_select_label)
		execute "normal! \<esc>"
	endif
	if select ==# ''
		let select = g:last_open_term_program
	else
		let g:last_open_term_program = select
	endif
	call SelectPosition(select, g:termpos)
endfunction
noremap <leader>xx <cmd>call OpenTermProgram()<cr>

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
			execute "!xdg-open -- ".a:filename
		endif
	endfunction
	autocmd BufEnter *.jpg,*.png,*.jpeg,*.bmp if v:vim_did_enter | call OpenWithXdg(Repr_Shell(expand('%'))) | endif
augroup END

function! TermuxSaveCursorStyle()
	if $TERMUX_VERSION !=# "" && filereadable(expand("~/.termux/termux.properties"))
		if !filereadable(expand("~/.cache/extra.nvim/termux/terminal_cursor_style"))
			let TMPFILE=trim(system(["mktemp", "-u"]))
			call system(["cp", expand("~/.termux/termux.properties"), TMPFILE])
			call system(["sed", "-i", "s/ *= */=/", TMPFILE])
			call system(["sed", "-i", "s/-/_/g", TMPFILE])
			call system(["chmod", "+x", TMPFILE])
			call writefile(["echo $terminal_cursor_style"], TMPFILE, "a")
			let g:termux_cursor_style = trim(system(TMPFILE))
			if !isdirectory(expand("~/.cache/extra.nvim/termux"))
				call mkdir(expand("~/.cache/extra.nvim/termux"), "p", 0700)
			endif
			call writefile([g:termux_cursor_style], expand("~/.cache/extra.nvim/termux/terminal_cursor_style"), "")
			call system(["rm", TMPFILE])
		else
			let g:termux_cursor_style = trim(readfile(expand("~/.cache/extra.nvim/termux/terminal_cursor_style"))[0])
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
			execute 'autocmd TermClose * let filename=system("cat '.TMPFILE.'")|if bufnr()==#'.g:bufnrforranger."|if v:shell_error!=#0|call OnQuit()|confirm quit|call OnQuitDisable()|endif|if filereadable(filename)==#1|let old_bufnr=bufnr()|enew|execute old_bufnr.\"bdelete\"|unlet old_bufnr|let bufnr=bufadd(filename)|call bufload(bufnr)|execute bufnr.'buffer'|call Numbertoggle()|filetype detect|call AfterSomeEvent(\"ModeChanged\", \"doautocmd BufEnter \".expand(\"%\"))|unlet g:bufnrforranger|else|endif|endif|call delete('".TMPFILE."')|unlet filename"
		else
			function! CheckRangerStopped(timer_id, TMPFILE)
				if !exists('g:bufnrforranger')
					return
				endif
				let bufnr = bufnr()
				if bufnr ==# g:bufnrforranger && !TermRunning(bufnr)
					let filename=system("cat ".a:TMPFILE)
					call delete(a:TMPFILE)
					if filereadable(filename) ==# 1
						bwipeout!
						execute 'edit '.filename
						call Numbertoggle()
						filetype detect
						call AfterSomeEvent("ModeChanged", "doautocmd BufEnter ".expand("%"))
						if exists('g:bufnrforranger')
							unlet g:bufnrforranger
						endif
						call timer_stop(a:timer_id)
					else
						call IfOneWinDo('call OnQuit()')
						quit
					endif
					unlet filename
				endif
			endfunction
			execute "call timer_start(0, {timer_id -> CheckRangerStopped(timer_id, '".TMPFILE."')}, {'repeat': -1})"
		endif
		execute "autocmd BufWinLeave * let f=expand(\"<afile>\")|let n=bufnr(\"^\".f.\"$\")|if n==#".g:bufnrforranger."|unlet f|unlet n|autocmd!oncloseranger|call AfterSomeEvent(\"BufEnter,BufLeave,WinEnter,WinLeave\", \"".g:bufnrforranger."bwipeout!\")|unlet g:bufnrforranger|endif"
	augroup END
	unlet TMPFILE
endfunction
function! OpenRangerCheck()
	if executable('ranger')
		call OpenRanger('./')
	else
		echohl ErrorMsg
		if g:language ==# 'russian'
			echomsg "Блядь: Не открывается ranger: не установлен"
		else
			echomsg "Error: Cannot open ranger: ranger not installed"
		endif
		echohl Normal
	endif
endfunction
set statusline=%#Loading88#Loading\ 87.5%%
nnoremap <leader>r <cmd>call OpenRangerCheck()<cr>

function! RunAlphaIfNotAlphaRunning()
	if !isdirectory(g:LOCALSHAREPATH.'/site/pack/packer/start/alpha-nvim')
		echohl ErrorMsg
		if g:language ==# 'russian'
			echomsg "Блядь: alpha-nvim не установлен"
		else
			echomsg "Error: alpha-nvim is not installed"
		endif
		echohl Normal
		return
	endif
	if &filetype !=# 'alpha'
		Alpha
	else
		AlphaRedraw
		AlphaRemap
	endif
endfunction
if has('nvim') && luaeval("plugin_installed(_A[1])", ["alpha-nvim"])
	nnoremap <leader>A <cmd>call RunAlphaIfNotAlphaRunning()<cr>
endif

if has('nvim') && luaeval("plugin_installed(_A[1])", ["neo-tree.nvim"])
	nnoremap <c-h> <cmd>Neotree<cr>
endif

function! OpenOnStart()
	if exists('g:open_menu_on_start')
		if g:open_menu_on_start ==# v:true
			call ChangeNames()
			call RebindMenus()
			call timer_start(0, {->quickui#menu#open()})
		endif
	endif

	if argc()
		argument 1
	elseif expand('%') == '' || isdirectory(expand('%'))
		let to_open = v:true
		let to_open = to_open && !g:DO_NOT_OPEN_ANYTHING
		let to_open = to_open && !g:PAGER_MODE
		if to_open
			if g:open_on_start ==# 'alpha' && has('nvim') && !isdirectory(expand('%')) && luaeval("plugin_installed(_A[1])", ["alpha-nvim"])
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

if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
	nnoremap <c-w>nv <cmd>vsplit<bar>enew<cr>
	nnoremap <c-w>n<c-v> <cmd>vsplit<bar>enew<cr>
	nnoremap <c-w>ns <cmd>split<bar>enew<cr>
	nnoremap <c-w>n<c-s> <cmd>split<bar>enew<cr>
else
	nnoremap <c-w>n <cmd>execute v:count1."wincmd n"<cr>
	nnoremap <c-w><c-n> <cmd>execute v:count1."wincmd n"<cr>
endif
nnoremap <c-w>o <cmd>silent only<cr>
nnoremap <c-w><c-o> <cmd>silent only<cr>
nnoremap <c-w>q <cmd>quit<cr>
nnoremap <c-w><c-q> <cmd>quit<cr>
nnoremap <c-w>f <cmd>wincmd f<cr>
nnoremap <c-w>F <cmd>wincmd F<cr>
nnoremap <c-w>gf <cmd>wincmd gf<cr>
nnoremap <c-w>gF <cmd>wincmd gF<cr>
nnoremap <c-w>gt <cmd>tabnext<cr>
nnoremap <c-w>gT <cmd>tabprevious<cr>
nnoremap <c-w>j <cmd>execute v:count1."wincmd j"<cr>
nnoremap <c-w><down> <cmd>execute v:count1."wincmd j"<cr>
nnoremap <c-w>k <cmd>execute v:count1."wincmd k"<cr>
nnoremap <c-w><up> <cmd>execute v:count1."wincmd k"<cr>
nnoremap <c-w>h <cmd>execute v:count1."wincmd h"<cr>
nnoremap <c-w><left> <cmd>execute v:count1."wincmd h"<cr>
nnoremap <c-w>l <cmd>execute v:count1."wincmd l"<cr>
nnoremap <c-w><right> <cmd>execute v:count1."wincmd l"<cr>
nnoremap <c-w>t <cmd>execute v:count1."wincmd t"<cr>
nnoremap <c-w>b <cmd>execute v:count1."wincmd b"<cr>
nnoremap <c-w>J <cmd>execute v:count1."wincmd J"<cr>
nnoremap <c-w>K <cmd>execute v:count1."wincmd K"<cr>
nnoremap <c-w>H <cmd>execute v:count1."wincmd H"<cr>
nnoremap <c-w>L <cmd>execute v:count1."wincmd L"<cr>
nnoremap <c-w>+ <cmd>execute v:count1."wincmd +"<cr>
nnoremap <c-w>- <cmd>execute v:count1."wincmd -"<cr>
nnoremap <c-w>< <cmd>execute v:count1."wincmd <"<cr>
nnoremap <c-w>> <cmd>execute v:count1."wincmd >"<cr>
nnoremap <c-w>= <cmd>wincmd ><cr>
nnoremap <c-w>P <cmd>wincmd P<cr>
nnoremap <c-w><c-p> <cmd>wincmd P<cr>
nnoremap <c-w>R <cmd>execute v:count1."wincmd R"<cr>
nnoremap <c-w><c-r> <cmd>execute v:count1."wincmd R"<cr>
nnoremap <c-w>s <cmd>execute v:count1."wincmd s"<cr>
nnoremap <c-w>S <cmd>execute v:count1."wincmd s"<cr>
nnoremap <c-w>T <cmd>wincmd T<cr>
nnoremap <c-w>w <cmd>execute v:count1."wincmd w"<cr>
nnoremap <c-w>x <cmd>execute v:count1."wincmd x"<cr>
nnoremap <c-w>W <cmd>execute v:count1."wincmd W"<cr>
nnoremap <c-w>] <cmd>wincmd ]<cr>
nnoremap <c-w>^ <cmd>execute v:count1."wincmd ^"<cr>
nnoremap <c-w><c-^> <cmd>execute v:count1."wincmd ^"<cr>
nnoremap <c-w>_ <cmd>execute v:count1."wincmd _"<cr>
nnoremap <c-w><c-_> <cmd>execute v:count1."wincmd _"<cr>
nnoremap <c-w>c <cmd>wincmd c<cr>
nnoremap <c-w>d <cmd>wincmd d<cr>
nnoremap <c-w>g<c-]> <cmd>execute "wincmd g\<c-]>"<cr>
nnoremap <c-w>g] <cmd>wincmd g]<cr>
nnoremap <c-w>g} <cmd>wincmd g}<cr>
nnoremap <c-w>g<tab> <cmd>execute "wincmd g\<tab>"<cr>
nnoremap <c-w>i <cmd>wincmd i<cr>
nnoremap <c-w>p <cmd>wincmd p<cr>
nnoremap <c-w>r <cmd>execute v:count1."wincmd r"<cr>
nnoremap <c-w>z <cmd>wincmd z<cr>
nnoremap <c-w>\| <cmd>execute v:count1."wincmd \|"<cr>

nnoremap <c-p> :<up>
vnoremap <c-p> :<up>
if g:open_cmd_on_up
	nnoremap <up> :<up>
	vnoremap <up> :<up>
endif

function! Do_N_Tilde()
	let l = line('.')
	let line = getline(l)
	let col = col('.')
	let c = line[col-1]
	let ll = strpart(line, 0, col-1)
	let lr = strpart(line, col)
	unlet line
	if c ==# "0"
		call setline(l, ll.'1'.lr)
		return
	elseif c ==# "1"
		call setline(l, ll.'0'.lr)
		return
	elseif c ==# "("
		call setline(l, ll.')'.lr)
		return
	elseif c ==# "["
		call setline(l, ll.']'.lr)
		return
	elseif c ==# "<"
		call setline(l, ll.'>'.lr)
		return
	elseif c ==# ")"
		call setline(l, ll.'('.lr)
		return
	elseif c ==# "]"
		call setline(l, ll.'['.lr)
		return
	elseif c ==# ">"
		call setline(l, ll.'<'.lr)
		return
	elseif c ==# "-"
		call setline(l, ll.'+'.lr)
		return
	elseif c ==# "+"
		call setline(l, ll.'-'.lr)
		return
	elseif c ==# "^"
		call setline(l, ll.'$'.lr)
		return
	elseif c ==# "$"
		call setline(l, ll.'^'.lr)
		return
	elseif c ==# "*"
		call setline(l, ll.'/'.lr)
		return
	elseif c ==# "/"
		call setline(l, ll.'*'.lr)
		return
	elseif c ==# "\\"
		call setline(l, ll.'|'.lr)
		return
	elseif c ==# "|"
		call setline(l, ll.'\'.lr)
		return
	elseif c ==# "\""
		call setline(l, ll.''''.lr)
		return
	elseif c ==# "'"
		call setline(l, ll.'"'.lr)
		return
	elseif c ==# "."
		call setline(l, ll.','.lr)
		return
	elseif c ==# ","
		call setline(l, ll.'.'.lr)
		return
	elseif c ==# ";"
		call setline(l, ll.':'.lr)
		return
	elseif c ==# ":"
		call setline(l, ll.';'.lr)
		return
	endif
	let n = char2nr(c)
	if n >= 97 && n <= 122
		call setline(l, ll.toupper(c).lr)
	elseif n >= 65 && n <= 90
		call setline(l, ll.tolower(c).lr)
	endif
endfunction
function! Do_V_Tilde()
	let [ls, cs] = getpos("'<")[1:2]
	let [le, ce] = getpos("'>")[1:2]
	for l in range(ls, le)
		let ln = getline(l)
		let col = len(ln)
		let line = ''
		if l ==# le
			let lr = strpart(ln, ce)
		endif
		if l ==# ls
			let ll = strpart(ln, 0, cs-1)
		endif
		for c in range(l!=#ls?0:cs-1, l!=#le?col:ce-1)
			let c = ln[c]
			let n = char2nr(c)
			if n >= 97 && n <= 122
				let line .= toupper(c)
			elseif n >= 65 && n <= 90
				let line .= tolower(c)
			else
				let line .= c
			endif
		endfor
		call setline(l, (l==#ls?ll:'').line.(l==#le?lr:''))
	endfor
endfunction

if g:compatible !=# "helix" && g:compatible !=# "helix_hard"
	nnoremap ~ <cmd>call Do_N_Tilde()<cr><space>
	xnoremap ~ <c-\><c-n><cmd>call Do_V_Tilde()<cr>
endif

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
	execute "lua require('packer').update(".a:args.")"
	call AfterUpdatingPlugins()
endfunction
if has('nvim')
	command! -nargs=* PackerUpdate exec "call DoPackerUpdate('".<f-args>."')"
endif
function! BeforeUpdatingPlugins()
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/which-key.nvim/lua/which-key")
		execute "cd ".g:LOCALSHAREPATH."/site/pack/packer/start/which-key.nvim/lua/which-key"
		execute "!git stash"
		cd -
	endif
endfunction
function! AfterUpdatingPlugins()
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/which-key.nvim/lua/which-key")
		execute "cd ".g:LOCALSHAREPATH."/site/pack/packer/start/which-key.nvim/lua/which-key/"
		execute "!git stash pop"
		cd -
	endif
endfunction

function! PrepareWhichKey()
	let g:which_key_timeout = 0
	if filereadable(g:LOCALSHAREPATH.'/site/pack/packer/start/which-key.nvim/lua/which-key/util.lua')
		edit ~/.local/share/nvim/site/pack/packer/start/which-key.nvim/lua/which-key/util.lua
		if getline(189) =~# 'if not ("nvsxoiRct"):find(mode) then'
			silent 189,192delete
			silent write
		endif
		bwipeout!
	endif
endfunction

function! LoadVars()
	if filereadable(expand(g:LOCALSHAREPATH).'/extra.nvim/last_selected.txt')
		let g:last_selected = readfile(expand(g:LOCALSHAREPATH).'/extra.nvim/last_selected.txt')[0]
	endif
	if filereadable(expand(g:LOCALSHAREPATH).'/extra.nvim/last_open_term_program.txt')
		let g:last_open_term_program = readfile(expand(g:LOCALSHAREPATH).'/extra.nvim/last_open_term_program.txt')[0]
	endif
endfunction
function! SaveVars()
	if v:false
	\|| g:last_selected !=# ''
	\|| g:last_open_term_program !=# ''
		if !isdirectory(expand(g:LOCALSHAREPATH).'/extra.nvim')
			call mkdir(expand(g:LOCALSHAREPATH).'/extra.nvim', 'p')
		endif
	endif
	if g:last_selected !=# ''
		call writefile([g:last_selected], expand(g:LOCALSHAREPATH).'/extra.nvim/last_selected.txt')
	endif
	if g:last_open_term_program !=# ''
		call writefile([g:last_open_term_program], expand(g:LOCALSHAREPATH).'/extra.nvim/last_open_term_program.txt')
	endif
endfunction

function! OnFirstTime()
	if !filereadable(expand(g:LOCALSHAREPATH).'/extra.nvim/not_first_time.null')
		if !isdirectory(expand(g:LOCALSHAREPATH).'/extra.nvim')
			call mkdir(expand(g:LOCALSHAREPATH).'/extra.nvim', 'p')
		endif
		call writefile([], expand(g:LOCALSHAREPATH).'/extra.nvim/not_first_time.null')

		if !filereadable(g:LOCALSHAREPATH.'/site/pack/packer/start/vim-quickui/autoload/quickui/confirm.vim')
			if g:language ==# 'russian'
				echomsg 'Чтобы посмотреть помощь, нажмите SPC-?. Вы больше не увидите это сообщение'
			else
				echomsg 'To see help, press SPC-?. You will not see this message again'
			endif
		else
			call quickui#confirm#open('To see help, press SPC-?')
		endif

		if !filereadable(g:EXNVIM_CONFIG_PATH)
			GenerateExNvimConfig
		endif
	endif
endfunction
function! OnStart()
	if has('nvim')
		call timer_start(0, {->OpenOnStart()})
	else
		call OpenOnStart()
	endif
	call SetExNvimConfigPath()
	call SetLocalSharePath()
	call SetConfigPath()
	if has('nvim') && luaeval("plugin_installed(_A[1])", ["neo-tree.nvim"]) && g:automatically_open_neo_tree_instead_of_netrw
		autocmd! FileExplorer *
		augroup auto_neo_tree
			autocmd!
			autocmd BufEnter * if isdirectory(expand(expand("%")))|let prev_bufnr=bufnr()|execute "Neotree position=current" expand("%")|execute prev_bufnr."bwipeout!"|endif
		augroup END
	endif
	if has('nvim') && g:enable_which_key
		call PrepareWhichKey()
	endif
	if has('nvim')
		call timer_start(0, {->MakeThingsThatRequireBeDoneAfterPluginsLoaded()})
	endif
	call timer_start(0, {->TermuxSaveCursorStyle()})
	execute "source ".g:CONFIG_PATH."/vim/init.vim"
	call DefineAugroups()
	call UpdateShowtabline()
	if g:PAGER_MODE
		call EnablePagerMode()
	endif
	if has('nvim') && g:compatible !=# "helix_hard" && isdirectory(g:LOCALSHAREPATH.'/site/pack/packer/start/nvim-notify')
		execute printf('luafile %s', fnamemodify(g:PLUGINS_SETUP_FILE_PATH, ':h').'/noice/setup.lua')
	endif
	if v:false
	\|| g:compatible ==# "helix"
	\|| g:compatible ==# "helix_hard"
		call LoadVars()
	endif
	call timer_start(0, {->execute('Showtab')})
	call timer_start(0, {->OnFirstTime()})
endfunction
function! OnQuit()
	call TermuxLoadCursorStyle()
	if v:false
	\|| g:compatible ==# "helix"
	\|| g:compatible ==# "helix_hard"
		call SaveVars()
	endif
endfunction
function! Update_Cursor_Style_wrapper()
	if exists('g:updating_cursor_style_supported')
		call Update_Cursor_Style()
	else
		execute "colorscheme" g:colors_name
	endif
endfunction
function! OnQuitDisable()
	call Update_Cursor_Style_wrapper()
endfunction
let s:MACRO_IS_ONE_WIN = "
\	let s = 0
\\n	let t = 1
\\n	while s <=# 1 && t <=# tabpagenr()
\\n		let s += tabpagewinnr(t, '$')
\\n		let t += 1
\\n	endwhile"
execute "
\function! IsOneWin()
\\n".s:MACRO_IS_ONE_WIN."
\\n	return s ==# 1
\\nendfunction"
execute "
\function! IfOneWinDo(cmd)
\\n".s:MACRO_IS_ONE_WIN."
\\n	if s ==# 1
\\n		execute a:cmd
\\n	endif
\\nendfunction"
execute "
\function! IfOneWinDoElse(cmd1, cmd2)
\\n".s:MACRO_IS_ONE_WIN."
\\n	if s ==# 1
\\n		execute a:cmd1
\\n	else
\\n		execute a:cmd2
\\n	endif
\\nendfunction"
function! PleaseDoNotCloseWrapper(cmd, cond)
	if a:cond
		let g:please_do_not_close = v:true
	endif
	execute a:cmd
	if a:cond
		let g:please_do_not_close = v:false
	endif
endfunction
execute "
\function! PleaseDoNotCloseIfOneWin(cmd)
\\n".s:MACRO_IS_ONE_WIN."
\\n	if s ==# 1
\\n		let g:please_do_not_close = v:true
\\n	endif
\\n	execute a:cmd
\\n	if s ==# 1
\\n		let g:please_do_not_close = v:false
\\n	endif
\\nendfunction"
execute "
\function! PleaseDoNotCloseIfNotOneWin(cmd)
\\n".s:MACRO_IS_ONE_WIN."
\\n	if s !=# 1
\\n		let g:please_do_not_close = v:true
\\n	endif
\\n	execute a:cmd
\\n	if s !=# 1
\\n		let g:please_do_not_close = v:false
\\n	endif
\\nendfunction"

function! FixShaDa()
	let g:PAGER_MODE = 0
	let g:DO_NOT_OPEN_ANYTHING = 0
	let g:LUA_REQUIRE_GOTO_PREFIX = g:LUA_REQUIRE_GOTO_PREFIX_DEFAULT
endfunction
autocmd! VimLeavePre * call FixShaDa()

autocmd! VimEnter * call OnStart()
autocmd! VimLeave * call OnQuit()
set statusline=%#Loading100#Loading\ 100%%
call inputrestore()
