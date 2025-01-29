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

hi Loading0 ctermfg=0 ctermbg=9 cterm=bold guifg=#303030 guibg=#ff0000 gui=bold
set statusline=%#Loading0#Loading\ 0%%
mode

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
let g:termux_cursor_style = "bar"
function! TermuxLoadCursorStyle()
	let g:old_guicursor = &guicursor
	if $TERMUX_VERSION !=# "" && filereadable(expand("~/.termux/termux.properties"))
		if g:termux_cursor_style ==# 'block'
			let &guicursor = 'a:block'
		elseif g:termux_cursor_style ==# 'bar'
			let &guicursor = 'a:ver25'
		elseif g:termux_cursor_style ==# 'underline'
			let &guicursor = 'a:hor25'
		endif
	endif
endfunction
function! OnQuit()
	call TermuxLoadCursorStyle()
	if g:compatible =~# "^helix"
		call SaveVars()
	endif
endfunction
augroup exnvim_vim_leave
	autocmd!
	autocmd VimLeave * call OnQuit()
augroup END

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

function! SetTermuxConfigPath()
	if !exists('g:TERMUX_CONFIG_PATH') || g:TERMUX_CONFIG_PATH ==# ""
		if $TERMUX_VERSION !=# ""
			let g:TERMUX_CONFIG_DIRECTORY = expand('$HOME').'/.termux'
			let g:TERMUX_CONFIG_PATH = g:TERMUX_CONFIG_DIRECTORY.'/termux.properties'
		endif
	endif
endfunction
call SetTermuxConfigPath()

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
		\'ani_cli_options',
		\'cd_after_git_clone',
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

let reloading_config = exists('g:CONFIG_ALREADY_LOADED')
let g:CONFIG_ALREADY_LOADED = v:true

call LoadExNvimConfig(g:EXNVIM_CONFIG_PATH, reloading_config)

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
	if !exists('g:setup_lsp')
		let g:setup_lsp = v:false
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
	if !exists('g:open_menu_on_start')
		let g:open_menu_on_start = v:false
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
		let g:open_cmd_on_up = "no"
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
	if !exists('g:ani_cli_options')
		let g:ani_cli_options = ""
	endif
	if !exists('g:cd_after_git_clone')
		let g:cd_after_git_clone = v:true
	endif
endfunction
call SetDefaultValuesForStartupOptionsAndExNvimConfigOptions()

hi Loading25 ctermfg=0 ctermbg=208 cterm=bold guifg=#303030 guibg=#ff8000 gui=bold
set statusline=%#Loading25#Loading\ 25%%
mode

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

function! SetGitBranch()
	let g:gitbranch = split(system('git rev-parse --abbrev-ref HEAD 2> /dev/null'))
	if len(g:gitbranch) > 0
		let g:gitbranch = g:gitbranch[0]
	else
		let g:gitbranch = ''
	endif
endfunction
call SetGitBranch()
function! GetGitBranch()
	return g:gitbranch
endfunction

let g:exnvim_fully_loaded = 0
let g:specloading=" 50 "

let s:custom_mode = ''
let s:specmode = ''
function! Showtab()
	if v:false
	elseif v:false
	\|| &filetype ==# 'neo-tree'
	\|| &filetype ==# 'musicplayer'
		return bufname('')
	endif
	if g:compatible !~# "^helix_hard"
		let stl_name = '%<%t'
		let stl_name .= '%( %* %#StatusLinemod#%M%R%H%W%)%*'
	else
		let stl_name = '%* %<%t'
		let stl_name .= '%( %#StatusLinemod#%M%R%H%W%)%*'
	endif
	if g:compatible !~# "^helix_hard"
		if &columns ># 40
			let stl_name .= '%( %#StatusLinemod#'
			let stl_name .= &syntax
			let stl_name .= '%)%*'
		endif
	endif
	if g:compatible !~# "^helix_hard"
		if &columns ># 45
			let stl_name .= '%( %#Statuslinemod#'
			let stl_name .= '%{GetGitBranch()}'
			let stl_name .= '%)%*'
		endif
	endif
	let mode = mode('lololol')
	let strmode = ''
	if mode == 'n'
		if g:compatible ==# "no"
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
		if g:compatible ==# "no"
			let strmode = '%#ModeVisu# '
		else
			if g:pseudo_visual
				if g:compatible !~# "^helix_hard"
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
			if g:compatible ==# "no"
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
		if g:compatible ==# "no"
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
			if g:compatible ==# "no"
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
	if g:compatible !~# "^helix_hard"
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
	if g:compatible !~# "^helix_hard"
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
		let s:result .= '%#Statusline0mac#'
		if &columns ># 45
			let s:result .= ''
		endif
		if is_macro_recording =~# '^\u$'
			let s:result .= '%#Statuslinemac# REC '.is_macro_recording.' '
		else
			let s:result .= '%#Statuslinemac# rec '.is_macro_recording.' '
		endif
	endif
	let virtual_env = $VIRTUAL_ENV
	let enough_space_for_pyenv = v:false
	\|| &columns ># 70
	\|| is_macro_recording ==# ''
	\&& &columns ># 65
	if virtual_env !=# '' && enough_space_for_pyenv
		let virtual_env = fnamemodify(virtual_env, ':h')
		let virtual_env = fnamemodify(virtual_env, ':t')
		if is_macro_recording !=# ''
			let s:result .= '%#Statuslinemacvenv#'
		else
			let s:result .= '%#Statusline0venv#'
		endif
		let s:result .= '%#Statuslinevenv# '.virtual_env.' '
	endif
	if &columns ># 45
		if virtual_env !=# '' && enough_space_for_pyenv
			let s:result .= '%#Statuslinevenv1#'
		else
			if g:compatible !~# "^helix_hard"
				if is_macro_recording !=# ''
					let s:result .= '%#Statuslinemac1#'
				else
					let s:result .= '%#Statuslinestat01#'
				endif
			endif
		endif
		if g:compatible !~# "^helix_hard"
			let s:result .= ''
		endif
	endif
	unlet enough_space_for_pyenv
	unlet is_macro_recording
	unlet virtual_env
	if &columns ># 30
		if g:compatible !~# "^helix_hard"
			let s:result .= '%#Statuslinestat1#'
			if &columns ># 45
				let s:result .= ' '
			endif
		endif
		let s:result .= stl_pos
	endif
	if g:compatible !~# "^helix_hard"
		if &columns ># 45
			let s:result .= ' '
		endif
		if &columns ># 45
			let s:result .= '%#Statuslinestat12#'
			let s:result .= ''
		endif
	endif
	if &columns ># 30
		if g:compatible !~# "^helix_hard"
				let s:result .= '%#Statuslinestat2# '
				let s:result .= stl_buf
		endif
		let s:result .= ' '
	endif
	if g:exnvim_fully_loaded !=# 3
		let s:result .= '%#Loading#'.g:specloading
	endif
	return s:result
endfunction
command! -nargs=0 Showtab set statusline=%{%Showtab()%}

let g:specloading=" 75 "
mode
function! ReturnHighlightTerm(group, term)
   " Store output of group to variable
   let output = execute('hi ' . a:group)

   " Find the term we're looking for
   return matchstr(output, a:term.'=\zs\S*')
endfunction
runtime colors/exnvim_base_init.vim
execute 'colorscheme' g:selected_colorscheme
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
	if has('nvim') || has('gui_running')
		execute printf("hi %s gui=%s", a:dst, gui)
	endif
endfunction
Showtab
mode

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

if $PREFIX == ""
	call setenv('PREFIX', '/usr')
endif

if has('nvim')
	execute "luafile ".expand(g:CONFIG_PATH)."/lua/lib/vim/plugins.lua"
endif

" NVIMRC FILE
let g:PLUGINS_INSTALL_FILE_PATH = '~/.config/nvim/lua/packages/plugins.lua'
let g:PLUGINS_SETUP_FILE_PATH = '~/.config/nvim/lua/packages/plugins_setup.lua'
let g:LSP_PLUGINS_SETUP_FILE_PATH = '~/.config/nvim/lua/packages/lsp/plugins.lua'

let g:sneak#s_next = 1

function! RestoreCursorFix()
    let s:line = line("'^")
    if v:true
    \&& s:line >= 1
    \&& s:line <= line("$")
    \&& &filetype !~# 'commit'
    \&& index(['xxd', 'gitrebase'], &filetype) == -1
    	execute "normal! g`^"
    endif
endfunction

if argc() >=# 1
	call timer_start(0, {->execute('argument 1')})
	call timer_start(0, {->execute('call RestoreCursorFix()|delfunction RestoreCursorFix')})
endif

let g:specloading=" 87 "
mode
function! Update_Cursor_Style_wrapper()
	if exists('g:updating_cursor_style_supported')
		call Update_Cursor_Style()
	else
		execute "colorscheme" g:colors_name
	endif
endfunction
function! OnQuitDisable()
	let &guicursor = g:old_guicursor
	unlet g:old_guicursor
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
function! PleaseDoNotCloseWrapper(cmd, cond=v:true)
	if a:cond
		let g:please_do_not_close_always = v:true
	endif
	execute a:cmd
	if a:cond
		let g:please_do_not_close_always = v:false
	endif
endfunction
let g:please_do_not_close = []
let g:please_do_not_close_always = v:false
execute "
\function! PleaseDoNotCloseIfOneWin(cmd)
\\n".s:MACRO_IS_ONE_WIN."
\\n	if s ==# 1
\\n		let g:please_do_not_close_always = v:true
\\n	endif
\\n	execute a:cmd
\\n	if s ==# 1
\\n		let g:please_do_not_close_always = v:false
\\n	endif
\\nendfunction"
execute "
\function! PleaseDoNotCloseIfNotOneWin(cmd)
\\n".s:MACRO_IS_ONE_WIN."
\\n	if s !=# 1
\\n		let g:please_do_not_close_always = v:true
\\n	endif
\\n	execute a:cmd
\\n	if s !=# 1
\\n		let g:please_do_not_close_always = v:false
\\n	endif
\\nendfunction"

if !reloading_config
	if g:language ==# "russian"
		let g:specloading=" ПОСЛЕ "
	else
		let g:specloading=" AFTER "
	endif
else
	let g:specloading=""
endif

function! FixShaDa()
	let g:PAGER_MODE = 0
	let g:DO_NOT_OPEN_ANYTHING = 0
	let g:LUA_REQUIRE_GOTO_PREFIX = g:LUA_REQUIRE_GOTO_PREFIX_DEFAULT
endfunction
augroup exnvim_fix_sha_da
	autocmd!
	autocmd VimLeavePre * call FixShaDa()
augroup END

function! PluginDelete(name)
	call delete(expand(g:LOCALSHAREPATH)."/site/pack/pckr/opt/".a:name, "rf")
endfunction
function! PluginExists(name)
	return isdirectory(g:LOCALSHAREPATH.'/site/pack/pckr/opt/'.a:name)
endfunction
if g:compatible =~# "^helix"
	if PluginExists('vim-gitgutter')
		call PluginDelete('vim-gitgutter')
	endif
endif

if has('nvim')
	function! PluginInstalled(name)
		return luaeval('plugin_installed(_A[1])', [a:name])
	endfunction
else
	function! PluginInstalled(name)
		return v:false
	endfunction
endif

function! InitPckr()
	execute "source ".g:CONFIG_PATH.'/vim/plugins/setup.vim'

	if has('nvim')
		execute printf("luafile %s", g:PLUGINS_INSTALL_FILE_PATH)
	endif
endfunction

autocmd VimEnter * call timer_start(0, {->execute('source '.g:CONFIG_PATH.'/after/init.vim')})
call inputrestore()
