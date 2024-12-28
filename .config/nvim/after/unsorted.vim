function! InitPacker()
	execute "source ".g:CONFIG_PATH.'/vim/plugins/setup.vim'

	execute printf("luafile %s", g:PLUGINS_INSTALL_FILE_PATH)
	PackerInstall
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

if exists('*Pad')
	noremap <silent> <c-x><c-f> <cmd>Findfilebuffer<cr>
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
	function! Numbertoggle_stcabs(mode='', winnr=winnr())
		if &modifiable && &buftype !=# 'terminal' && &buftype !=# 'nofile' && &filetype !=# 'netrw' && &filetype !=# 'neo-tree' && &filetype !=# 'TelescopePrompt' && &filetype !=# 'packer' && &filetype !=# 'spectre_panel' && &filetype !=# 'alpha' && g:linenr
			call STCAbs(a:mode, a:winnr)
		else
			call STCNo(a:winnr)
		endif
	endfunction	
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
else
	function! Numbertoggle_stcabs(mode='', winnr=winnr())
		call STCNo(a:winnr)
	endfunction	
endif

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

let g:LUA_REQUIRE_GOTO_PREFIX_DEFAULT = [$HOME.'/']
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
				let has_globbing = v:false
				for char in i
					if char ==# '*'
						let has_globbing = v:true
						break
					endif
				endfor
				if executable('find') && has_globbing
					unlet has_globbing
					let found = systemlist('find ~/ -wholename '.Repr_Shell(i).'/'.Repr_Shell(filename))
					if len(found) ==# 0
						let found = systemlist('find ~/ -wholename '.Repr_Shell(i).'/'.Repr_Shell(filename).'.lua')
					endif
					if len(found) ==# 0
						let startcol = end
						continue
					endif
					let foundfilename = found[0]
				else
					unlet has_globbing
					let current_filename = i.'/'.filename.'.lua'
					if !filereadable(current_filename)
						let startcol = end
						continue
					endif
					let foundfilename = current_filename
				endif
				if isdirectory(foundfilename)
					execute "Neotree position=right" foundfilename
				else
					split
					let goto_buffer = bufadd(foundfilename)
					call bufload(goto_buffer)
					exec goto_buffer."buffer"
					normal! `"
				endif
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
	\\n   LEAD : - Switch to visual selection wise command mode (:'<,'>)
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
	let prev_filetype = g:prev_filetype
	execute "noremap <buffer> q <cmd>execute bufnr().\"bwipeout!\"<bar>".(prev_filetype==#"alpha"?"Alpha":old_bufnr."buffer")."<cr>"
endfunction
command! -nargs=0 ExNvimCheatSheet call ExNvimCheatSheet()
noremap <silent> <leader>? <cmd>ExNvimCheatSheet<cr>

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

if has('nvim')
	if g:setup_lsp
		lua M = {}
		lua servers = { gopls = {}, html = {}, jsonls = {}, pyright = {}, rust_analyzer = {}, sumneko_lua = {}, tsserver = {}, vimls = {}, }
		lua on_attach = function(client, bufnr) vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc") vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()") require("config.lsp.keymaps").setup(client, bufnr) end
		lua opts = { on_attach = on_attach, flags = { debounce_text_changes = 150, }, }
		lua setup = function() require("config.lsp.installer").setup(servers, opts) end
	endif
endif

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
unlet s:select_all_definition

command! -nargs=* Write write <args>

let handle_keystroke_function_expression = "
\function! HandleKeystroke(keystroke)
\\n	let l = line('.')
\\n	let line = getline(l)
\\n	let col = col('.')
\\n	let prev_c = line[col-2]
\\n	let c = line[col-1]
\\n	if a:keystroke ==# \"\\<bs>\"
\\n		if prev_c ==# '('
\ && c ==# ')'
\ || prev_c ==# '{'
\ && c ==# '}'
\ || prev_c ==# '['
\ && c ==# ']'
\ || prev_c ==# \"'\"
\ && c ==# \"'\"
\ || prev_c ==# '\"'
\ && c ==# '\"'
\ || prev_c ==# \"`\"
\ && c ==# \"`\"
\ || prev_c ==# '<'
\ && c ==# '>'
\\n			return \"\\<del>\\<bs>\"
\\n		else
\\n			return \"\\<bs>\"
\\n		endif
\\n	endif
\\n	if a:keystroke ==# ')'
\ && c ==# ')'
\ || a:keystroke ==# ']'
\ && c ==# ']'
\ || a:keystroke ==# '}'
\ && c ==# '}'
\ || a:keystroke ==# \"'\"
\ && c ==# \"'\"
\ || a:keystroke ==# '\"'
\ && c ==# '\"'
\ || a:keystroke ==# \"`\"
\ && c ==# \"`\"
\\n		return \"\\<right>\"
\\n	endif
\\n	if a:keystroke ==# '\"'
\	|| a:keystroke ==# \"'\"
\	|| a:keystroke ==# \"`\"
\\n		if v:false
\ || c =~# \"[a-zA-Z0-9]\"
\ || prev_c =~# \"[a-zA-Z0-9]\"
\\n			return a:keystroke
\\n		else
\\n			return a:keystroke.a:keystroke.\"\\<left>\"
\\n		endif
\\n	endif
\\n	let mode = mode()
\\n	if v:false
\\n	elseif a:keystroke ==# '('
\\n		if c =~# \"[a-zA-Z0-9]\"
\\n			execute \"normal! i(\\<right>\"
\\n		else
\\n			normal! i()
\\n		endif
\\n	elseif a:keystroke ==# '['
\\n		if c =~# \"[a-zA-Z0-9]\"
\\n			execute \"normal! i[\\<right>\"
\\n		else
\\n			normal! i[]
\\n		endif
\\n	elseif a:keystroke ==# '{'
\\n		if c =~# \"[a-zA-Z0-9]\"
\\n			execute \"normal! i{\\<right>\"
\\n		else
\\n			normal! i{}
\\n		endif
\\n	else
\\n		return a:keystroke
\\n	endif
\"
if exists(':Numbertoggle') && exists(':STCAbs')
let handle_keystroke_function_expression .= "
\\n	call Numbertoggle(mode)"
endif
let handle_keystroke_function_expression .= "
\\nendfunction"
execute handle_keystroke_function_expression
unlet handle_keystroke_function_expression

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
	let g:fullscreen = v:false
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

function! TermuxSaveCursorStyle()
	if $TERMUX_VERSION !=# "" && filereadable(expand("~")."/.termux/termux.properties")
		if !filereadable(expand("~/.cache/extra.nvim/termux/terminal_cursor_style"))
			let TMPFILE=trim(system(["mktemp", "-u"]))
			call system(["cp", expand("~/.termux/termux.properties"), TMPFILE])
			call system(["sed", "-i", "s/ *= */=/", TMPFILE])
			call system(["sed", "-i", "s/-/_/g", TMPFILE])
			call system(["chmod", "+x", TMPFILE])
			call writefile(["echo $terminal_cursor_style"], TMPFILE, "a")
			let termux_cursor_style = trim(system(TMPFILE))
			if termux_cursor_style !=# ""
				let g:termux_cursor_style = termux_cursor_style
				unlet termux_cursor_style
				if !isdirectory(expand("~/.cache/extra.nvim/termux"))
					call mkdir(expand("~/.cache/extra.nvim/termux"), "p", 0700)
				endif
				call writefile([g:termux_cursor_style], expand("~/.cache/extra.nvim/termux/terminal_cursor_style"), "")
			endif
			call system(["rm", TMPFILE])
		else
			let g:termux_cursor_style = trim(readfile(expand("~/.cache/extra.nvim/termux/terminal_cursor_style"))[0])
		endif
	elseif $TERMUX_VERSION
		let g:termux_cursor_style = 'bar'
	endif
endfunction
call TermuxSaveCursorStyle()

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
			execute 'autocmd TermClose * let filename=system("cat '.TMPFILE.'")|if bufnr()==#'.g:bufnrforranger."|if v:shell_error!=#0|call OnQuit()|quit|call OnQuitDisable()|endif|if filereadable(filename)==#1|let old_bufnr=bufnr()|enew|execute old_bufnr.\"bdelete\"|unlet old_bufnr|let bufnr=bufadd(filename)|call bufload(bufnr)|execute bufnr.'buffer'|call Numbertoggle()|filetype detect|call AfterSomeEvent(\"ModeChanged\", \"doautocmd BufEnter \".expand(\"%\"))|unlet g:bufnrforranger|else|endif|endif|call delete('".TMPFILE."')|unlet filename"
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

function! OpenOnStart()
	if g:open_menu_on_start ==# v:true
		call ChangeNames()
		call RebindMenus()
		call timer_start(0, {->quickui#menu#open()})
	endif

	if argc() <= 0 && expand('%') == '' || isdirectory(expand('%'))
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
endfunction

function! LoadVars()
	if filereadable(expand(g:LOCALSHAREPATH).'/extra.nvim/last_selected.txt')
		let g:last_selected = readfile(expand(g:LOCALSHAREPATH).'/extra.nvim/last_selected.txt')[0]
	endif
	if filereadable(expand(g:LOCALSHAREPATH).'/extra.nvim/last_open_term_program.txt')
		let g:last_open_term_program = readfile(expand(g:LOCALSHAREPATH).'/extra.nvim/last_open_term_program.txt')[0]
	endif
endfunction

if v:false
\|| g:compatible ==# "helix"
\|| g:compatible ==# "helix_hard"
	call LoadVars()
endif

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

let &showtabline = g:showtabline

if g:PAGER_MODE
	call EnablePagerMode()
endif

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
if g:compatible !=# "helix_hard"
	set tabline=%!MyTabLine()
endif

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

let g:fullscreen = v:false
function! ToggleFullscreen()
	if !g:fullscreen
		let g:fullscreen = v:true
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
		let g:fullscreen = v:false
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

command! -nargs=0 SWrap if !&wrap|setl wrap linebreak nolist|else|setl nowrap nolinebreak list|endif

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
		noremap <buffer> <up> <cmd>call ProcessGBut('k')<cr>
	endif
	noremap <buffer> <down> <cmd>call ProcessGBut('j')<cr>
endfunction
function! JKWorkaround()
	noremap k <cmd>call ProcessGBut('k')<cr>
	if !g:open_cmd_on_up
	  noremap <up> <cmd>call ProcessGBut('k')<cr>
    endif
	if !isdirectory(g:LOCALSHAREPATH.'/site/pack/packer/start/endscroll.nvim')
		noremap j <cmd>call ProcessGBut('j')<cr>
		if !g:open_cmd_on_up
		  noremap <down> <cmd>call ProcessGBut('j')<cr>
		endif
	endif
endfunction
call JKWorkaround()

if !g:linenr
	call STCNo()
else
	call Numbertoggle()
endif

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
if has('nvim') && g:enable_which_key
	call PrepareWhichKey()
endif

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
call OnFirstTime()

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
	if !has('nvim')
	  wincmd k
	  wincmd c
	endif
	startinsert
	return bufnr()
endfunction

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
delfunction CommentOutDefault_Define
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
delfunction UncommentOutDefault_Define

function! HandleBuftypeAll()
	tabdo windo call HandleBuftype(winnr())
endfunction

" TELESCOPE
function! FuzzyFind()
	lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({winblend = 0 }))
endfunction

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

let g:floaterm_width = 1.0

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
	
	if isdirectory(g:LOCALSHAREPATH.'/site/pack/packer/start/persisted.nvim')
		execute "cd ".g:LOCALSHAREPATH."/site/pack/packer/start/persisted.nvim"
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

	if isdirectory(g:LOCALSHAREPATH.'/site/pack/packer/start/persisted.nvim')
		execute "cd ".g:LOCALSHAREPATH."/site/pack/packer/start/persisted.nvim"
		execute "!git stash pop"
		cd -
	endif
endfunction

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

function! Remove(a)
	let v:errmsg=""
	if a:a!=#''
		let g:exnvim_tmp=a:a
		call execute(['unsilent call delete(g:exnvim_tmp)', 'let g:exnvim_tmp=v:errmsg'], "silent!")
		let e=g:exnvim_tmp
		unlet g:exnvim_tmp
		let f=a:a
	else
		let f=expand('%')
		if filereadable(f)
			call execute(['unsilent call delete(expand(''%''))', 'let g:exnvim_tmp=v:errmsg'], "silent!")
			let e=g:exnvim_tmp
			unlet g:exnvim_tmp
		else
			let e='no such file'
		endif
	endif
	if f!=#''
		let f=fnamemodify(expand('%'), ':t')
	else
		let f="empty filename"
	endif
	if e==#""
		echohl Title
		echo "remove success: ".f
	else
		echohl ErrorMsg
		if f!=#"empty filename"
			echomsg "remove error: ".f.": ".e
		else
			echomsg "remove error: ".f
		endif
	endif
	echohl Normal
endfunction
command! -nargs=? -complete=file Rm call Remove(expand("<args>"))

call OpenOnStart()

let g:exnvim_fully_loaded += 1
let g:specloading = ' OK '
doautocmd User ExNvimLoaded