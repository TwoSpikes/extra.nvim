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

	let s:custom_mode = ''
	let s:specmode = ''
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
	command! -nargs=0 Showtab set stl=%{%Showtab()%}
	Showtab

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
else
	function! Numbertoggle_stcabs(mode='', winnr=winnr())
		call STCNo(a:winnr)
	endfunction	
endif

