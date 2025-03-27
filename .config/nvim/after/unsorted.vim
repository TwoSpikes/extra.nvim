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

function! SetGitBranch()
	let g:gitbranch = split(system('git rev-parse --abbrev-ref HEAD 2> /dev/null'))
	if len(g:gitbranch) > 0
		let g:gitbranch = g:gitbranch[0]
	else
		let g:gitbranch = ''
	endif
endfunction
call SetGitBranch()
autocmd DirChanged * call SetGitBranch()

if has('nvim')
	let g:please_do_not_close = []
	let g:please_do_not_close_always = v:false
endif

function! RelNu(winnr=winnr())
	if mode() =~? '^v' || mode() ==# "\<c-v>"
		call CopyHighlightGroup('CursorLineNrVisu', 'CursorLineNr')
		call CopyHighlightGroup('LineNrVisu', 'LineNr')
		call CopyHighlightGroup("StatementVisu", "Statement")
		return
	endif
	call CopyHighlightGroup('CursorLineNrNorm', 'CursorLineNr')
	call CopyHighlightGroup('LineNrNorm', 'LineNr')
	call CopyHighlightGroup("StatementNorm", "Statement")
	call setwinvar(a:winnr, '&number', v:true)
	call setwinvar(a:winnr, '&relativenumber', v:true)
endfunction
function! NoNu(winnr=winnr())
	call setwinvar(a:winnr, '&number', v:false)
	call setwinvar(a:winnr, '&relativenumber', v:false)
endfunction
function! NoNuAll()
	tabdo windo call NoNu(winnr())
endfunction

function! Numbertoggle_RelNu(winnr)
	if &modifiable && &buftype !=# 'terminal' && &buftype !=# 'nofile' && &filetype !=# 'netrw' && &filetype !=# 'neo-tree' && &filetype !=# 'TelescopePrompt' && &filetype !=# 'vim-plug' && &filetype !=# 'pkgman' && &filetype !=# 'spectre_panel' && &filetype !=# 'alpha' && g:linenr
		call RelNu(a:winnr)
	else
		call NoNu(a:winnr)
	endif
endfunction
function! Numbertoggle(mode='', winnr=winnr())
	if a:mode =~? 'i' || a:mode =~? 'r' || g:linenr_style ==# 'absolute'
		call Numbertoggle_AbsNu(a:mode, a:winnr)
	else
		call Numbertoggle_RelNu(a:winnr)
	endif
endfunction
function! NumbertoggleAll(mode='')
	tabdo windo call Numbertoggle(a:mode, winnr())
endfunction

function! AbsNu(actual_mode, winnr=winnr())
	if a:actual_mode ==# '' || a:actual_mode =~? 'n'
		call CopyHighlightGroup('CursorLineNrNorm', 'CursorLineNr')
		call CopyHighlightGroup('LineNrNorm', 'LineNr')
		call CopyHighlightGroup("StatementNorm", "Statement")
	elseif a:actual_mode =~? 'r' || a:actual_mode ==# 'v' && mode() ==# 'R'
		call CopyHighlightGroup('CursorLineNrRepl', 'CursorLineNr')
		call CopyHighlightGroup('LineNrRepl', 'LineNr')
	elseif a:actual_mode =~? 'v' && getwinvar(a:winnr, '&modifiable')
		call CopyHighlightGroup('CursorLineNrVisu', 'CursorLineNr')
		call CopyHighlightGroup('LineNrVisu', 'LineNr')
	else
		call CopyHighlightGroup('CursorLineNrIns', 'CursorLineNr')
		call CopyHighlightGroup('LineNrIns', 'LineNr')
		call CopyHighlightGroup("StatementIns", "Statement")
	endif
	call setwinvar(a:winnr, '&number', v:true)
	call setwinvar(a:winnr, '&relativenumber', v:false)
endfunction
function! Numbertoggle_AbsNu(mode='', winnr=winnr())
	if &modifiable && &buftype !=# 'terminal' && &buftype !=# 'nofile' && &filetype !=# 'netrw' && &filetype !=# 'neo-tree' && &filetype !=# 'TelescopePrompt' && &filetype !=# 'vim-plug' && &filetype !=# 'pkgman' && &filetype !=# 'spectre_panel' && &filetype !=# 'alpha' && g:linenr
		call AbsNu(a:mode, a:winnr)
	else
		call NoNu(a:winnr)
	endif
endfunction
if exists('*Pad')
	function! Findfile()
		if g:language ==# 'russian'
			let find_file_label = 'Найти файл: '
		else
			let find_file_label = 'Find file: '
		endif
		echohl Question
		let filename = input(find_file_label, fnamemodify(expand("%:p"), ":~:.:h").'/', "file")
		echohl Normal

		if len(filename) ==# 0
			echohl ErrorMsg
			echomsg "extra.nvim: Findfile: cancelled by user"
			echohl Normal
			return
		endif

		if has('nvim') && PluginInstalled("neo-tree") && isdirectory(expand(filename))
			tabedit
			execute "Neotree" "position=current" filename
		else
			execute "tabedit" filename
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
		echohl Question
		let filename = input(find_file_label, fnamemodify(expand("%:p"), ":~:.:h").'/', "file")
		echohl Normal

		if len(filename) ==# 0
			echohl ErrorMsg
			echomsg "extra.nvim: Findfile: cancelled by user"
			echohl Normal
			return
		endif

		if has('nvim') && PluginInstalled("neo-tree") && isdirectory(expand(filename))
			execute "Neotree" "position=current" filename
		else
			execute "edit" filename
		endif
	endfunction
	command! -nargs=0 Findfilebuffer call Findfilebuffer()
	noremap <c-x><c-f> <cmd>Findfilebuffer<cr>
	noremap <c-c>C <cmd>Findfilebuffer<cr>

	function! SaveAsBase(command, invitation)
		if !PluginExists('vim-quickui')
			echohl Question
			let filename = input(a:invitation)
			echohl Normal
		else
			let filename = quickui#input#open(Pad(a:invitation, g:pad_amount_confirm_dialogue), fnamemodify(expand('%:p'), ':~:.'))
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
	function! Numbertoggle_AbsNu(mode='', winnr=winnr())
		call NoNu(a:winnr)
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

function! SelectPosition(cmd, positions, cd=v:null)
	while v:true
		if !PluginExists('vim-quickui')
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
			if a:cd !=# v:null
				let old_cd=getcwd()
				call chdir(a:cd)
			endif
			execute a:positions[position]['command'](a:cmd)
			if a:cd !=# v:null
				call chdir(old_cd)
				unlet old_cd
			endif
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

if PluginInstalled('neo-tree')
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

" MY .nvimrc HELP
function! ExNvimCheatSheet()
	let old_bufnr = bufnr()
	let bufnr = bufadd('EXTRA.NVIM help')
	call bufload(bufnr)
	execute bufnr.'buffer'
	if !&modifiable
		return
	endif
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
	\\n    LEAD z - Open Lazy package manager
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
	\\n   LEAD SPACE or F10 or F9 - Open quickui menu
	\\n   LEAD x SPACE or S-F10 or S-F9 - Open extra quickui menu
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
	\\n   LEAD uc - Update coc.nvim language servers
	\\n   LEAD ut - Update nvim-treesitter parsers
	\\n   LEAD sw - Find work under cursor using nvim-spectre
	\\n   LEAD . - \"Open Terminal\" dialogue
	\\n   LEAD m - \"Open Far/MC\" dialogue
	\\n   LEAD xz - \"Open lazygit\" dialogue
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
	\\n    Author: TwoSpikes (2023 - 2025)
	\\n    Github repository: https://github.com/TwoSpikes/extra.nvim
	\\n    Also see: https://github.com/TwoSpikes/dotfiles
	\\n    (Press `gx` to open links)
	\", "\n"))
	1delete
	setlocal nomodified
	setlocal nomodifiable
	setlocal buftype=nofile
	setlocal filetype=book
	setlocal undolevels=-1
	call Numbertoggle('n')
	let prev_filetype = g:prev_filetype
	execute "noremap <buffer> q <cmd>execute bufnr().\"bwipeout!\"<bar>".(prev_filetype==#"alpha"?"Alpha":old_bufnr."buffer")."<cr>"
	execute "noremap <buffer> <leader>? <cmd>execute bufnr().\"bwipeout!\"<bar>".(prev_filetype==#"alpha"?"Alpha":old_bufnr."buffer")."<cr>"
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
	if !PluginExists('vim-quickui')
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
		call IfNotOneWinDo('let g:please_do_not_close += [win_getid()]')
		bdelete!
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
\\n	if mode !~# '^v'"
if g:compatible =~# '^helix'
let s:select_all_definition .= "
\\n		noautocmd normal! v"
else
let s:select_all_definition .= "
\\n		normal! v"
endif
let s:select_all_definition .= "
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
if g:compatible =~# "^helix"
let s:select_all_definition .= "
\\n	if mode !~? '^v'
\\n		let g:pseudo_visual = v:true
\\n	    call SetModeToShow()
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
\\nendfunction"
execute handle_keystroke_function_expression
unlet handle_keystroke_function_expression

function! OpenTermProgram(cd=getcwd())
	if v:true
	\|| has('nvim') && PluginInstalled('noice')
	\|| (v:true
	\||		!has('nvim')
	\||		!PluginInstalled('noice')
	\|| v:true)
	\&& !exists('g:quickui_version')
		let hcm_select_label = 'Open in terminal'.(g:last_open_term_program!=#''?' (default: '.g:last_open_term_program.')':'').': '
		let select = input(hcm_select_label, '', 'file')
		execute "normal! \<esc>"
	else
		let select = quickui#input#open(Pad('Open terminal program:', 40), g:last_open_term_program)
	endif
	if select ==# ''
		let select = g:last_open_term_program
	else
		let g:last_open_term_program = select
	endif
	let old_cd=getcwd()
	call chdir(a:cd)
	call SelectPosition(select, g:termpos)
	call chdir(old_cd)
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
	if !PluginInstalled('alpha')
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
if PluginInstalled('alpha-nvim')
	nnoremap <leader>A <cmd>call RunAlphaIfNotAlphaRunning()<cr>
endif

function! LoadVars()
	if filereadable(expand(stdpath("data")).'/extra.nvim/last_selected.txt')
		let g:last_selected = readfile(expand(stdpath("data")).'/extra.nvim/last_selected.txt')[0]
	endif
	if filereadable(expand(stdpath("data")).'/extra.nvim/last_open_term_program.txt')
		let g:last_open_term_program = readfile(expand(stdpath("data")).'/extra.nvim/last_open_term_program.txt')[0]
	endif
endfunction

if g:compatible =~# "^helix"
	call LoadVars()
endif

function! PreserveAndDo(cmd)
	let old_winid = win_getid()
	execute a:cmd
	call win_gotoid(old_winid)
endfunction

let &showtabline = g:showtabline

if g:PAGER_MODE
	call EnablePagerMode()
endif

function! MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let bufnr = buflist[winnr - 1]
	let original_buf_name = bufname(bufnr)
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
	elseif filetype ==# "netrw"
		if g:language ==# 'russian'
			let buf_name = '[Файлы]'
		else
			let buf_name = '[Files]'
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
	elseif filetype ==# "vim-plug"
		if g:language ==# 'russian'
			let buf_name = '[Плагины]'
		else
			let buf_name = '[Plugins]'
		endif
	elseif buftype ==# "pkgman"
		if g:language ==# 'russian'
			let buf_name = '[ПакМенедж]'
		else
			let buf_name = '[PkgManag]'
		endif
	elseif original_buf_name ==# "EXTRA.NVIM help"
		if g:language ==# 'russian'
			let buf_name = '[Помощь]'
		else
			let buf_name = '[Help]'
		endif
	elseif buftype ==# "nofile"
		if g:language ==# 'russian'
			let buf_name = '[НеФайл]'
		else
			let buf_name = '[NoFile]'
		endif
	elseif original_buf_name ==# ''
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
    if i + 1 ==# tabpagenr()
      let s .= '%#TabLineSel#'
    elseif (i - tabpagenr()) % 2 == 0
		let s .= '%#TabLine#'
	elseif i !=# tabpagenr('$') - 1
		let s .= '%#TabLineSec#'
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
if g:compatible !~# "^helix_hard"
	set tabline=%!MyTabLine()
endif

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
if g:compatible =~# "^helix"
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
if v:false
\|| (v:true
\&& g:do_not_save_previous_column_position_when_going_up_or_down
\&& g:compatible =~# "^helix"
\&& g:compatible !~# "^helix_hard"
\&& v:true)
\|| g:compatible =~# "^helix_hard"
	let process_g_but_function_expression .= "\\\"mz`z\\\".."
endif
let process_g_but_function_expression .= "
\(vim.v.count == 0 and \'g\".a:button.\"\' or \'\".a:button.\"\')
\"
if g:compatible =~# "^helix"
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
if g:compatible =~# "^helix"
let process_g_but_function_expression .= "
\\nif g:pseudo_visual
\\n	call feedkeys(\"\\<c-\\>\\<c-n>\")
\\nendif
\\n"
endif
endif

if g:compatible =~# "^helix"
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
if g:compatible =~# "^helix"
let process_g_but_function_expression .= "
\\n	let old_c=col('.')
\\n	let old_l=line('.')
\"
endif
let process_g_but_function_expression .= "
\\n	execute \"norm! \".v:count1.button
\"
if g:compatible =~# "^helix"
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

function! JKWorkaround()
	noremap k <cmd>call ProcessGBut('k')<cr>
	if g:open_cmd_on_up ==# "no"
	  noremap <up> <cmd>call ProcessGBut('k')<cr>
    endif
	if !PluginInstalled('endscroll')
		noremap j <cmd>call ProcessGBut('j')<cr>
		if g:open_cmd_on_up ==# "no"
		  noremap <down> <cmd>call ProcessGBut('j')<cr>
		endif
	endif
endfunction
call JKWorkaround()

if !g:linenr
	call NoNu()
else
	call Numbertoggle()
endif

function! OnFirstTime()
	if !filereadable(g:LOCALSHAREPATH.'/extra.nvim/not_first_time.null')
		if !isdirectory(g:LOCALSHAREPATH.'/extra.nvim')
			call mkdir(g:LOCALSHAREPATH.'/extra.nvim', 'p')
		endif
		call writefile([], g:LOCALSHAREPATH.'/extra.nvim/not_first_time.null')

		if !PluginExists('vim-quickui')
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

function! OpenTerm(cmd, after=v:null, do_not_close=v:false, after_close=v:null, after_close_autocommand_group_title='exnvim_open_term')
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
	if has('nvim')
		let command = 'terminal'
	else
		let command = 'terminal ++curwin'
	endif
	if a:cmd ==# ""
		execute command
	else
		execute command a:cmd
	endif
	let id = win_getid()
	if a:do_not_close
		let g:please_do_not_close += [id]
	endif
	if a:after_close !=# v:null
		execute 'augroup' a:after_close_autocommand_group_title
			autocmd!
			execute 'autocmd' 'TermClose' '*' a:after_close(id, a:after_close_autocommand_group_title)
		augroup END
	endif
	if a:after !=# v:null
		call call(a:after, [])
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
function! N_Comment_Move_Left(comment_string)
	let comment_string_len = Defone(len(a:comment_string))
	call Save_WW_and_Do('normal! '.comment_string_len.'h')
endfunction
function! N_Comment_Move_Right(comment_string)
	let comment_string_len = Defone(len(a:comment_string))
	call Save_WW_and_Do('normal! '.comment_string_len.'l')
endfunction
function! X_Comment_Move_Left_Define()
let x_comment_move_left_function_expression = ""
let x_comment_move_left_function_expression .= "
\function! X_Comment_Move_Left(comment_string)
\\n	let comment_string_len = Defone(len(a:comment_string))
\\n	call Save_WW_and_Do('normal! '.comment_string_len.'ho'.comment_string_len.'ho')
\"
if g:compatible =~# "^helix"
let x_comment_move_left_function_expression .= "
\\n	let g:pseudo_visual = v:true
\"
endif
let x_comment_move_left_function_expression .= "
\\nendfunction
\"
execute x_comment_move_left_function_expression
endfunction
call X_Comment_Move_Left_Define()
delfunction X_Comment_Move_Left_Define
function! X_Comment_Move_Right_Define()
let x_comment_move_right_function_expression = ""
let x_comment_move_right_function_expression .= "
\function! X_Comment_Move_Right(comment_string)
\\n	let comment_string_len = Defone(len(a:comment_string))
\\n	call Save_WW_and_Do('normal! '.comment_string_len.'lo'.comment_string_len.'lo')
\"
if g:compatible =~# "^helix"
let x_comment_move_right_function_expression .= "
\\n	let g:pseudo_visual = v:true
\"
endif
let x_comment_move_right_function_expression .= "
\\nendfunction
\"
execute x_comment_move_right_function_expression
endfunction
call X_Comment_Move_Right_Define()
delfunction X_Comment_Move_Right_Define
function! N_CommentOut(comment_string)
	let l=line('.')
	call setline(l, substitute(a:comment_string, '%s', Repr_Vim_Grep_Sub(getline(l)), ''))
	call N_Comment_Move_Right(substitute(a:comment_string, '%s', '', ''))
endfunction
function! X_CommentOut(comment_string)
	let line_start = getpos("'<")[1]
	let line_end = getpos("'>")[1]
	for line in range(line_start, line_end)
		call setline(line, substitute(a:comment_string, '%s', Repr_Vim_Grep(getline(line)), ''))
	endfor
	normal! gv
	call X_Comment_Move_Right(substitute(a:comment_string, '%s', '', ''))
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
	call N_Comment_Move_Left(comment)
endfunction
function! X_UncommentOut(comment_string)
	let comment=substitute(a:comment_string, '%s', '', '')
	for idx in range(line("'>")-line("'<")+1)
		let l = line("'<") + idx
		let line=getline(l)
		call setline(l, substitute(line, comment, '', ''))
	endfor
	normal! gv
	call X_Comment_Move_Left(comment)
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
	if len(l:s) ==# 0
		echohl ErrorMsg
		echomsg "Hlgroup name not found!"
		echohl Normal
		return
	endif
	execute "verbose hi ".l:s
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
function! Md(dir)
	if isdirectory(fnamemodify(a:dir, 'p'))
		echohl ErrorMsg
		echomsg "extra.nvim: Md: directory already exists"
		echohl Normal
		return
	endif
	silent! let result = mkdir(a:dir, 'p')
	if result ==# 0
		echohl ErrorMsg
		echomsg "extra.nvim: error: Md: ".v:errmsg
		echohl Normal
		return
	endif
	execute 'chdir' a:dir
	echomsg fnamemodify(a:dir, ':~:.')
endfunction
command! -nargs=1 -complete=file Md call Md("<args>")

let g:exnvim_sh_funcs = {}
function! ShSource(file=expand("%"))
	if !executable('bash')
		echohl ErrorMsg
		echomsg "extra.nvim: bash is not installed"
		echohl Normal
		return
	endif
	if a:file ==# ""
		let file = expand("%")
	else
		let file = a:file
	endif
	let separation_key = GetRandomName(20)
	let env = trim(system('bash --noprofile --norc -c ". '.expand(file).'>/dev/null 2>&1;env;echo '.separation_key.';declare -f"'))
	if v:shell_error !=# 0
		echohl ErrorMsg
		echomsg "extra.nvim: ShSource: something went wrong"
		echohl Normal
		return
	endif
	let env = split(env, "\n")
	let i = 0
	for item in env
		if item ==# separation_key
			unlet separation_key
			break
		endif
		let i += 1
		let akqjwbsu = matchlist(item, '^\([a-zA-Z0-9_]\+\)=\(.*\)$')
		let varname = akqjwbsu[1]
		let value = akqjwbsu[2]
		unlet akqjwbsu
		if v:false
		\|| varname ==# "SHELL"
		\|| varname ==# "COLORTERM"
		\|| varname ==# "HISTCONTROL"
		\|| varname ==# "HISTSIZE"
		\|| varname ==# "PREFIX"
		\|| varname ==# "ANDROID_ART_ROOT"
		\|| varname ==# "COC_DATA_HOME"
		\|| varname ==# "TERMUX_APP_PID"
		\|| varname ==# "ANDROID_TZDATA_ROOT"
		\|| varname ==# "ANDROID_ROOT"
		\|| varname ==# "XDG_CONFIG_HOME"
		\|| varname ==# "TERMUX_MAIN_PACKAGE_FORMAT"
		\|| varname ==# "_"
			continue
		endif
		call setenv(varname, value)
	endfor
	if exists('separation_key')
		echohl ErrorMsg
		echomsg "extra.nvim: ShSource: something went wrong"
		echohl Normal
		return
	endif
	let env = env[i+1:]
	unlet i
	let funcname = v:null
	let funcval = ""
	for item in env
		if item =~# '^[a-zA-Z0-9]\+ () $'
			let funcname = matchlist(item, '^\([a-zA-Z0-9]\+\) () $')[1]
			continue
		endif
		if item ==# "{ "
			let funcval = ""
			continue
		endif
		if item ==# "}"
			let g:exnvim_sh_funcs[funcname] = funcval
			continue
		endif
		let funcval .= item[4:]."\n"
	endfor
endfunction
command! -nargs=? -complete=file ShSource call ShSource("<args>")
function! ShFunction(funcname)
	echomsg g:exnvim_sh_funcs[a:funcname]
endfunction
command! -nargs=1 -complete=file ShFunction call ShFunction("<args>")
function! ShRun(funcname)
	let funcval = g:exnvim_sh_funcs[a:funcname]
	let funcval = split(funcval, "\n")
	let funcval = join(funcval, '')
	let separation_key = GetRandomName(20)
	let env = trim(system('bash --noprofile --norc -c '.Repr_Shell(funcval, v:false).'">/dev/null 2>&1;env;echo '.separation_key.';declare -f"'))
	let current_env = trim(system('env'))
	let current_env = split(current_env, "\n")
	let current_envs = []
	for var in current_env
		let current_envs += [matchlist(var, '^\([a-zA-Z0-9_]\+\)=\(.*\)$')[1]]
	endfor
	unlet current_env
	if v:shell_error ==# 2
		echohl ErrorMsg
		echomsg "extra.nvim: ShRun: syntax error"
		echohl Normal
		return
	elseif v:shell_error !=# 0
		echohl ErrorMsg
		echomsg "extra.nvim: ShRun: something went wrong: errcode ".v:shell_error
		echohl Normal
		return
	endif
	let env = split(env, "\n")
	let envs = []
	let i = 0
	for item in env
		if item ==# separation_key
			unlet separation_key
			break
		endif
		let i += 1
		let avwuqvq = matchlist(item, '^\([a-zA-Z0-9_]\+\)=\(.*\)$')
		let varname = avwuqvq[1]
		let envs += [varname]
		let value = avwuqvq[2]
		unlet avwuqvq
		if v:false
		\|| varname ==# "SHELL"
		\|| varname ==# "COLORTERM"
		\|| varname ==# "HISTCONTROL"
		\|| varname ==# "HISTSIZE"
		\|| varname ==# "PREFIX"
		\|| varname ==# "ANDROID_ART_ROOT"
		\|| varname ==# "COC_DATA_HOME"
		\|| varname ==# "TERMUX_APP_PID"
		\|| varname ==# "ANDROID_TZDATA_ROOT"
		\|| varname ==# "ANDROID_ROOT"
		\|| varname ==# "XDG_CONFIG_HOME"
		\|| varname ==# "TERMUX_MAIN_PACKAGE_FORMAT"
		\|| varname ==# "_"
			continue
		endif
		call setenv(varname, value)
	endfor
	for var in current_envs
		if index(envs, var) ==# -1
			call setenv(var, v:null)
		endif
	endfor
	unlet envs
	unlet current_envs
	if exists('separation_key')
		echohl ErrorMsg
		echomsg "extra.nvim: ShRun: something went wrong"
		echohl Normal
		return
	endif
	let env = env[i+1:]
	unlet i
	let funcname = v:null
	let funcval = ""
	for item in env
		if item =~# '^[a-zA-Z0-9]\+ () $'
			let funcname = matchlist(item, '^\([a-zA-Z0-9]\+\) () $')[1]
			continue
		endif
		if item ==# "{ "
			let funcval = ""
			continue
		endif
		if item ==# "}"
			let g:exnvim_sh_funcs[funcname] = funcval
			continue
		endif
		let funcval .= item[4:]."\n"
	endfor
endfunction
command! -nargs=1 -complete=file ShRun call ShRun("<args>")

function! GitClone(args)
	if !has('nvim')
		echohl ErrorMsg
		echomsg "extra.nvim: GitClone: please use NeoVim"
		echohl Normal
		return
	endif
	if !PluginExists('vim-fugitive')
		echohl ErrorMsg
		echomsg "extra.nvim: GitClone: install vim-fugitive"
		echohl Normal
		return
	endif
	if v:true
	\|| has('nvim') && PluginInstalled('noice')
	\|| (v:true
	\||		!has('nvim')
	\||		!PluginInstalled('noice')
	\|| v:true)
	\&& !exists('g:quickui_version')
		let url = input('Select URL:')
		let destination = input('Select destination (empty: curr.dir):', '', 'file')
	else
		let url = quickui#input#open('Select URL:')
		let destination = quickui#input#open('Select destination (empty: curr.dir):')
	endif
	split
	if has('nvim') && g:cd_after_git_clone
		if len(destination) ==# 0
			let destination = getcwd().'/'.split(url, '/')[-1]
		endif
		call OpenTerm('git clone '.Repr_Shell(url).' '.Repr_Shell(a:args).' '.Repr_Shell(destination), v:null, v:true, {id, augroup_name -> 'if win_getid()==#'.id.'|if v:event["status"] ==# 0|execute "cd" "'.destination.'"|quit|endif|autocmd! '.augroup_name.'|endif'}, 'exnvim_git_clone')
	else
		call OpenTerm('git clone '.Repr_Shell(url).' '.Repr_Shell(a:args).' '.Repr_Shell(destination), v:null, v:false)
	endif
endfunction
command! -nargs=? -complete=file GitClone call GitClone("<args>")

function! InvertPdf(src, dst=v:null)
	if !executable('gs')
		echohl ErrorMsg
		echomsg "extra.nvim: InvertPdf: please install ghostscript"
		echohl Normal
		return
	endif
	if len(a:src) ==# 0
		if v:true
		\|| has('nvim') && PluginInstalled('noice')
		\|| !has('nvim')
		\&& !PluginInstalled('noice')
		\&& !exists('g:quickui_version')
			let src = input('Select source file:')
		else
			let src = quickui#input#open('Select source file: ')
		endif
		if len(src) ==# 0
			echohl ErrorMsg
			echomsg "extra.nvim: InvertPdf: cancelled by user"
			echohl Normal
			return
		endif
	else
		let src = a:src
	endif
	if a:dst ==# v:null
		let dst = substitute(src, '\.pdf$', '_inverted.pdf', '')
	else
		let dst = a:dst
	endif
	split
	call OpenTerm('gs -o '.Repr_Shell(dst).' -sDEVICE=pdfwrite -c \{1\ exch\ sub\}\{1\ exch\ sub\}\{1\ exch\ sub\}\{1\ exch\ sub\}\ setcolortransfer -f '.Repr_Shell(src))
endfunction
command! -nargs=* -complete=file InvertPdf call InvertPdf("<f-args>")

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

let g:username = trim(system('whoami'))
