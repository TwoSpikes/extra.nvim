
function! ChangeNames()
	if mode() !~# '^n'
		let s:esc_label = "Go to No&rmal mode"
		let s:esc_command = 'exec "normal! \<c-\>\<c-n>"'
		return
	else
		if exists('g:Vm')
			if g:Vm['buffer'] !=# 0
				let s:esc_label = "Exit multicu&rsor"
				let s:esc_command = b:VM_Selection.Vars.noh."call vm#reset()"
				return
			endif
		endif
		if @/ !=# ""
			let s:esc_label = "Stop sea&rching"
			let s:esc_command = 'let @/ = ""'
			return
		endif
		let s:esc_label = "Stop cu&rrent command"
		let s:esc_command = "normal! \<esc>"
		return
	endif
endfunction

function! RebindMenus()
	" clear all the menus
	call quickui#menu#reset()

	" install a 'File' menu, use [text, command] to represent an item.
	call quickui#menu#install('&File', [
				\ ["New File\t:new", 'new', 'Creates a new buffer'],
				\ ["&Quit\tq", 'quit', 'Closes the current window'],
				\ ["Force q&uit\tQ", 'quit!', 'Closes the current window without saving changes'],
				\ ["K&ill buffer\tCtrl-x k", 'Killbuffer', 'Completely removes the current buffer'],
				\ ["--", '' ],
				\ ["&Open file in tab\tCtrl-c c", 'Findfile', 'Open file in new tab'],
				\ ["Open file in &buffer\tCtrl-c C", 'Findfilebuffer', 'Open file in current buffer'],
				\ ["Toggle &file tree\tCtrl-h", 'NERDTreeToggle', 'Toggles a file tree'],
				\ ["Toggle ta&gbar\tCtrl-t", 'TagbarToggle', 'Toggles tagbar'],
				\ ["Fu&zzy find using Telescope\tLEAD ff", 'call FuzzyFind()', 'Opens Telescope.nvim find file'],
				\ ["--", '' ],
				\ ["&Save\tCtrl-x s", 'write', 'Save changes in current buffer'],
				\ ["Save &All\tCtrl-x S", 'wall | echo "Saved all buffers"', 'Save changes to all buffers' ],
				\ ["--", '' ],
				\ ["Make onl&y\tCtrl-x 1", 'only', 'Hide all but current window'],
				\ ["Previous &window\tCtrl-x o", 'exec "normal! \<c-w>w"', 'Go to previous window'],
				\ ["Ne&xt window\tCtrl-x O", 'exec "normal! \<c-w>W"', 'Go to next window'],
				\ ["--", '' ],
				\ ["Update &plugins\tLEAD u", 'lua require("packer").sync()', 'Clear and redraw the screen'],
				\ ["Update coc language ser&vers\tLEAD cu", 'CocUpdate', 'Update coc.nvim installed language servers'],
				\ ["Update &TreeSitter parsers\tLEAD tu", 'TSUpdate', 'Update installed TreeSitter parsers'],
				\ ["--", '' ],
				\ ["Redraw scree&n\tCtrl-l", 'mode', 'Clear and redraw the screen'],
				\ ["Hi&de highlightings\tLEAD d", 'nohlsearch', 'Hide search highlightings'],
				\ [s:esc_label."\tesc", s:esc_command, 'Stop searching'],
				\ ["Toggle fulls&creen\tLEAD Ctrl-f", 'ToggleFullscreen', 'Toggle fullscreen mode'],
				\ ["--", '' ],
				\ ["&Exit\tCtrl-x Ctrl-c", 'confirm qall', 'Close Vim/NeoVim softly'],
				\ ["Exit without confir&m\tCtrl-x Ctrl-q", 'qall!', 'Close Vim/NeoVim without saving'],
				\ ])

	" items containing tips, tips will display in the cmdline
	call quickui#menu#install('&Text', [
				\ ["Cop&y line\tyy", 'yank', 'Copy the line where cursor is located'],
				\ ["&Delete line\tsd", 'delete x', 'Delete the line where cursor is located'],
				\ ["C&ut line\tdd", 'delete _', 'Cut the line where cursor is located'],
				\ ["&Paste after\tp", 'normal! p', 'Paste copyied text after the cursor'],
				\ ["Paste &before\tP", 'normal! P', 'Paste copyied text before the cursor'],
				\ ["&Join line\tJ", 'join', 'Join current and next line and put between them a space'],
				\ ["Fo&rce join line\tgJ", 'normal! p', 'Join current and next line and leave blanks as it is'],
				\ ["--", '' ],
				\ ["&Forward find <word>\t*", 'normal! *', 'Forwardly find whole word under cursor'],
				\ ["&Backward find <word>\t#", 'normal! #', 'Backwardly find whole word under cursor'],
				\ ["F&orward find word\tg*", 'normal! g*', 'Forwardly find word under cursor'],
				\ ["B&ackward find word\tg#", 'normal! g#', 'Backwardly find word under cursor'],
				\ ["--", '' ],
				\ ["&Comment out\tLEAD /d", 'call DoCommentOutDefault()', 'Comment out line under cursor'],
				\ ["&Uncomment\tLEAD /u", 'call UncommentOutDefault()', 'Uncomment line under cursor'],
				\ ["--", '' ],
				\ ["Go to &multicursor mode\tCtrl-n", 'call vm#commands#ctrln(1)', 'Go to multicursor mode'],
				\ ["Show hl&group", 'call SynGroup()', 'Show hlgroup name under cursor'],
				\ ["&Whence hlgroup", 'call WhenceGroup()', 'Show whence hlgroup under cursor came'],
				\ ["&Select all\tCtrl-x h", 'call SelectAll()', 'Paste copyied text after the cursor'],
				\ ])

	call quickui#menu#install("&LSP", [
				\ ["Coc &previous diagnostic\t[g", 'call CocActionAsync("diagnosticPrevious")', 'Go to previous diagnostic'],
				\ ["Coc &next diagnostic\t]g", 'call CocActionAsync("diagnosticNext")', 'Go to next diagnostic'],
				\ ["Go to &definition\tgd", 'call CocActionAsync("jumpDefinition")', 'Jump to definition'],
				\ ["Go to &type definition\tgy", 'call CocActionAsync("jumpTypeDefinition")', 'Jump to type definition'],
				\ ["Go to &implementation\tgi", 'call CocActionAsync("jumpImplementation")', 'Jump to implementation'],
				\ ["Go to &references\tgr", 'call CocActionAsync("jumpReferences")', 'Jump to references'],
				\ ["--", '' ],
				\ ["Code &actions selected\tLEAD a", 'call CocActionAsync("codeAction", visualmode())', 'Apply code actions for selected code'],
				\ ["Code actions &cursor\tLEAD ac", 'call CocActionAsync("codeAction", "cursor")', 'Apply code actions for current cursor position'],
				\ ["Code actions &buffer\tLEAD as", 'call CocActionAsync("codeAction", "", ["source"], v:true)', 'Apply code actions for current buffer'],
				\ ["Fi&x current line\tLEAD qf", 'call CocActionAsync("doQuickfix")', 'Apply the most preferred quickfix action to fix diagnostic on the current line'],
				\ ["--", '' ],
				\ ["&Refactor\tLEAD re", 'call CocActionAsync("codeAction", "cursor", ["refactor"], v:true)', 'Codeaction refactor cursor'],
				\ ["Refactor s&elected\tLEAD r", 'call CocActionAsync("codeAction", visualmode(), ["refactor"], v:true)', 'Codeaction refactor selected'],
				\ ["--", '' ],
				\ ["C&ode lens current line\tLEAD cl", 'call CocActionAsync("codeLensAction")', 'Run the Code Lens action on the current line'],
				\ ["&Show documentation\tK", 'call ShowDocumentation()', 'Show documentation in preview window'],
				\ ["Rename s&ymbol\tLEAD rn", 'call CocActionAsync("rename")', 'Rename symbol under cursor'],
				\ ["&Format selected\tLEAD f", 'call CocActionAsync("formatSelected", visualmode())', 'Format selected code'],
				\ ["Fold c&urrent buffer\t:Fold", 'Fold', 'Make folds for current buffer'],
				\ ])

	" script inside %{...} will be evaluated and expanded in the string
	call quickui#menu#install("&Option", [
				\ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!', '%{(&spell?"Disable":"Enable")." spell checking"}'],
				\ ['Set Cursor &Column %{&cursorcolumn==#v:true?"Off":"On"}', 'let g:cursorcolumn=!g:cursorcolumn|call HandleBuftypeAll()'],
				\ ['Set Cursor L&ine %{&cursorline==#v:true?"Off":"On"}', 'let g:cursorline=!g:cursorline|call HandleBuftypeAll()'],
				\ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
				\ ])

	call quickui#menu#install('&Config', [
			\ ["Open &init.vim\tLEAD ve", 'call SelectPosition("e ".g:CONFIG_PATH."/init.vim")', 'Open '.g:CONFIG_PATH.'/init.vim'],
			\ ["Open &plugins list\tLEAD vi", 'call SelectPosition("e ".g:PLUGINS_INSTALL_FILE_PATH)', 'Open '.g:PLUGINS_INSTALL_FILE_PATH],
			\ ["Open plugins set&up\tLEAD vs", 'call SelectPosition("e ".g:PLUGINS_SETUP_FILE_PATH)', 'Open '.g:PLUGINS_SETUP_FILE_PATH],
			\ ["Open lsp &settings\tLEAD vl", 'call SelectPosition("e ".g:LSP_PLUGINS_SETUP_FILE_PATH)', 'Open '.g:LSP_PLUGINS_SETUP_FILE_PATH.' (deprecated due to coc.nvim)'],
			\ ["Open &dotfiles config\tLEAD vj", 'call SelectPosition("e ".g:DOTFILES_CONFIG_PATH."/config.json")', 'Open '.g:DOTFILES_CONFIG_PATH.'/config.json'],
			\ ["Open &colorschemes\tLEAD c", 'call SelectPosition("e ".$VIMRUNTIME."/colors")', 'Open colorschemes directory'],
			\ ["--", '' ],
			\ ["&Reload init.vim\tLEAD se", 'exec "source ".g:CONFIG_PATH."/init.vim"', 'Reload Vim/NeoVim config'],
			\ ["R&eload plugins list\tLEAD si", 'exec "source ".g:PLUGINS_INSTALL_FILE_PATH', 'Install plugins in '.g:PLUGINS_INSTALL_FILE_PATH],
			\ ["Rel&oad plugins setup\tLEAD ss", 'exec "source ".g:PLUGINS_SETUP_FILE_PATH', 'Reconfigure plugins'],
			\ ["Relo&ad lsp setup\tLEAD sl", 'exec "source ".g:LSP_PLUGINS_SETUP_FILE_PATH', 'Reconfigure LSP plugins (deprecated due to coc.nvim)'],
			\ ["Reload do&tfiles config\tLEAD sj", 'call LoadDotfilesConfig(expand(g:DOTFILES_CONFIG_PATH)."/config.json")|call HandleDotfilesConfig()|call HandleBuftypeAll()', 'Reload dotfiles config'],
		  \ ])

	" register HELP menu with weight 10000
	call quickui#menu#install('&Help', [
				\ ["Vim &cheatsheet", 'help index', ''],
				\ ["&Dotfiles cheatsheet\tLEAD ?", 'DotfilesCheatSheet', 'dotfiles cheatsheet'],
				\ ['Ti&ps', 'help tips', ''],
				\ ['--',''],
				\ ["&Tutorial", 'help tutor', ''],
				\ ['&Quick Reference', 'help quickref', ''],
				\ ['&Summary', 'help summary', ''],
				\ ['--',''],
				\ ["&Intro screen\t:intro", 'intro', 'Show intro message'],
				\ ["Vim &version\t:ver", 'version', 'Show Vim version'],
				\ ], 10000)
endfunction

" enable to display tips in the cmdline
let g:quickui_show_tip = 1

" hit space twice to open menu
noremap <space><space> <cmd>call ChangeNames()<cr><cmd>call RebindMenus()<cr><cmd>call quickui#menu#open()<cr>
