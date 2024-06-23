function! ChangeNames()
	if g:language ==# 'russian'
		let s:file_label = '&f:Файл'
		let s:window_label = '&w:Окно'
		let s:text_label = '&t:Текст'
		let s:lsp_label = '&LSP'
		let s:option_label = '&o:Опции'
		let s:config_label = '&c:Конфиг'
		let s:help_label = '&h:Помощь'
	else
		let s:file_label = '&File'
		let s:window_label = '&Window'
		let s:text_label = '&Text'
		let s:lsp_label = '&LSP'
		let s:option_label = '&Option'
		let s:config_label = '&Config'
		let s:help_label = '&Help'
	endif

	if g:language ==# 'russian'
		let s:new_file_label = '&w:Новый файл'
		let s:close_label = '&o:Закрыть'
		let s:force_close_label = '&e:Закрыть всё равно'
		let s:save_label = '&s:Сохранить'
		let s:save_all_label = '&a:Сохранить всё'
		let s:save_as_label = '&v:Сохранить как'
		let s:save_as_and_edit_label = '&i:Сохранить как и зайти'
		let s:update_plugins_label = '&p:Обновить плагины'
		let s:update_coc_label = "&c:Обновить coc lsp'ы"
		let s:update_treesitter_label = '&t:Обновить TreeSitter'
		let s:redraw_screen_label = '&n:Перерисовать экран'
		let s:hide_highlightings_label = '&d:Скрыть подсвечивание'
		let s:toggle_fullscreen_label = '&f:Переключ.полноэкр.реж.'
		let s:exit_label = '&x:Выйти'
		let s:exit_wo_confirm_label = '&m:Выйти всё равно'
	else
		let s:new_file_label = 'Ne&w file'
		let s:close_label = 'Cl&ose'
		let s:force_close_label = 'Force clos&e'
		let s:save_label = '&Save'
		let s:save_all_label = 'Save &all'
		let s:save_as_label = 'Sa&ve as'
		let s:save_as_and_edit_label = 'Save as and ed&it'
		let s:update_plugins_label = 'Update &plugins'
		let s:update_coc_label = 'Update &coc servers'
		let s:update_treesitter_label = 'Update &TreeSitter'
		let s:redraw_screen_label = 'Redraw scree&n'
		let s:hide_highlightings_label = 'Hi&de highlightings'
		let s:toggle_fullscreen_label = 'Toggle &fullscreen'
		let s:exit_label = 'E&xit'
		let s:exit_wo_confirm_label = 'Exit w/o confir&m'
	endif

	if mode() !~# '^n'
		if g:language ==# 'russian'
			let s:esc_label = "[&r] Выйти в нормальный режим"
		else
			let s:esc_label = "Go to No&rmal mode"
		endif
		let s:esc_command = 'exec "normal! \<c-\>\<c-n>"'
		return
	else
		if exists('g:Vm')
			if g:Vm['buffer'] !=# 0
				if g:language ==# 'russian'
					let s:esc_label = "&r:Выйти из мультикурсора"
				else
					let s:esc_label = "Exit multicu&rsor"
				endif
				let s:esc_command = b:VM_Selection.Vars.noh."call vm#reset()"
				return
			endif
		endif
		if @/ !=# ""
			if g:language ==# 'russian'
				let s:esc_label = "&r:Остановить поиск"
			else
				let s:esc_label = "Stop sea&rching"
			endif
			let s:esc_command = 'let @/ = ""'
			return
		endif
		if g:language ==# 'russian'
			let s:esc_label = "&r:Останов.текущ.команду"
		else
			let s:esc_label = "Stop cu&rrent command"
		endif
		let s:esc_command = "normal! \<esc>"
		return
	endif
endfunction

function! RebindMenus()
	" clear all the menus
	call quickui#menu#reset()

	" install a 'File' menu, use [text, command] to represent an item.
	call quickui#menu#install(s:file_label, [
				\ [(g:quickui_icons?"󰈙 ":"").s:new_file_label."\t:new", 'new', 'Creates a new buffer'],
				\ [(g:quickui_icons?" ":"").s:close_label."\tq", 'quit', 'Closes the current window'],
				\ [(g:quickui_icons?" ":"").s:force_close_label."\tQ", 'quit!', 'Closes the current window without saving changes'],
				\ ["--", '' ],
				\ [(g:quickui_icons?"󰆓 ":"").s:save_label."\tCtrl-x s", 'write', 'Save changes in current buffer'],
				\ [(g:quickui_icons?"󰆔 ":"").s:save_all_label."\tCtrl-x S", 'wall | echo "Saved all buffers"', 'Save changes to all buffers' ],
				\ [(g:quickui_icons?"󰳻 ":"").s:save_as_label."\tLEAD Ctrl-s", 'call SaveAs()', 'Save current file as ...' ],
				\ [(g:quickui_icons?"󰳻 ":"").s:save_as_and_edit_label."\tLEAD Ctrl-r", 'call SaveAsAndRename()', 'Save current file as ... and edit it' ],
				\ ["--", '' ],
				\ [(g:quickui_icons?"󰚰 ":"").s:update_plugins_label."\tLEAD u", 'lua require("packer").sync()', 'Clear and redraw the screen'],
				\ [(g:quickui_icons?"󰚰 ":"").s:update_coc_label."\tLEAD Cu", 'CocUpdate', 'Update coc.nvim installed language servers'],
				\ [(g:quickui_icons?"󰚰 ":"").s:update_treesitter_label."\tLEAD tu", 'TSUpdate', 'Update installed TreeSitter parsers'],
				\ ["--", '' ],
				\ [(g:quickui_icons?" ":"").s:redraw_screen_label."\tCtrl-l", 'mode', 'Clear and redraw the screen'],
				\ [(g:quickui_icons?" ":"").s:hide_highlightings_label."\tLEAD d", 'nohlsearch', 'Hide search highlightings'],
				\ [(g:quickui_icons?" ":"").s:esc_label."\tesc", s:esc_command, 'Stop searching'],
				\ [(g:quickui_icons?"󰊓 ":"").s:toggle_fullscreen_label."\tLEAD Ctrl-f", 'ToggleFullscreen', 'Toggle fullscreen mode'],
				\ ["--", '' ],
				\ [(g:quickui_icons?"󰅗 ":"").s:exit_label."\tCtrl-x Ctrl-c", 'confirm qall', 'Close Vim/NeoVim softly'],
				\ [(g:quickui_icons?"󰅗 ":"").s:exit_wo_confirm_label."\tCtrl-x Ctrl-q", 'qall!', 'Close Vim/NeoVim without saving'],
				\ ])

	call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?"󱂥 ":"")."Kill b&uffer\tCtrl-x k", 'Killbuffer', 'Completely removes the current buffer'],
				\ [(g:quickui_icons?" ":"")."&Select buffer\tCtrl-x Ctrl-b", 'call quickui#tools#list_buffer("e")', 'Select buffer to edit in current buffer'],
				\ [(g:quickui_icons?"󱎸 ":"")."Find &word using Spectre\tLEAD sw", 'exec "lua require(\"spectre\").open_visual({select_word = true})"', 'Select buffer to edit in current buffer'],
				\ ["--", '' ],
				\ ])
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/vim-quickui")
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?" ":"")."Open file in &tab\tCtrl-c c", 'Findfile', 'Open file in new tab'],
				\ [(g:quickui_icons?" ":"")."Open file in &buffer\tCtrl-c C", 'Findfilebuffer', 'Open file in current buffer'],
				\ ])
	endif
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/neo-tree.nvim")
		call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?"󰙅 ":"")."Toggle &file tree\tCtrl-h", 'Neotree', 'Toggles a file tree'],
					\ ])
	endif
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/telescope.nvim")
		call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?"󰥨 ":"")."Telescope fu&zzy find\tLEAD ff", 'call FuzzyFind()', 'Opens Telescope.nvim find file'],
					\ ])
	endif
	if executable('ranger')
		call quickui#menu#install(s:window_label, [
					\ [(g:quickui_icons?" ":"")."Open file using &ranger\tLEAD r", 'call OpenRangerCheck()', 'Opens ranger to select file to open'],
					\ ])
	endif
	call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?"󰚰 ":"")."Re&cently opened files\tLEAD fr", 'lua require("telescope").extensions.recent_files.pick()', 'Show menu to select file from recently opened'],
				\ ["--", '' ],
				\ [(g:quickui_icons?" ":"")."&Make window only\tCtrl-x 1", 'only', 'Hide all but current window'],
				\ [(g:quickui_icons?" ":"")."&Previous window\tCtrl-x o", 'exec "normal! \<c-w>w"', 'Go to previous window'],
				\ [(g:quickui_icons?" ":"")."&Next window\tCtrl-x O", 'exec "normal! \<c-w>W"', 'Go to next window'],
				\ [(g:quickui_icons?" ":"")."Hor&izontally split\tCtrl-x 2", 'split', 'Horizontally split current window'],
				\ [(g:quickui_icons?" ":"")."&Vertically split\tCtrl-x 3", 'vsplit', 'Vertically split current window'],
				\ ["--", '' ],
				\ [(g:quickui_icons?" ":"")."&Open terminal\tLEAD t", 'call SelectPosition($SHELL." -l", g:termpos)', 'Opens a terminal'],
				\ ])
	if executable('mc') || executable('far') || executable('far2l')
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?" ":"")."Op&en Far/Mc\tLEAD m", 'call SelectPosition(g:far_or_mc, g:termpos)', 'Opens Far or Midnight commander'],
				\ ])
	endif
	if executable('lazygit')
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?" ":"")."Open lazy&git\tLEAD z", 'call SelectPosition("lazygit", g:termpos)', 'Opens Lazygit'],
				\ ])
	endif
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/alpha-nvim")
		call quickui#menu#install(s:window_label, [
				\ [(g:quickui_icons?"󰍜 ":"")."Open st&art menu\tLEAD A", 'call RunAlphaIfNotAlphaRunning()', 'Opens alpha-nvim menu'],
				\ ])
	endif

	" items containing tips, tips will display in the cmdline
	call quickui#menu#install(s:text_label, [
				\ [(g:quickui_icons?"󰆏 ":"")."Cop&y line\tyy", 'yank', 'Copy the line where cursor is located'],
				\ [(g:quickui_icons?"󰆴 ":"")."&Delete line\tsd", 'delete x', 'Delete the line where cursor is located'],
				\ [(g:quickui_icons?"󰆐 ":"")."C&ut line\tdd", 'delete _', 'Cut the line where cursor is located'],
				\ [(g:quickui_icons?"󰆒 ":"")."&Paste after\tp", 'normal! p', 'Paste copyied text after the cursor'],
				\ [(g:quickui_icons?"󰆒 ":"")."Past&e before\tP", 'normal! P', 'Paste copyied text before the cursor'],
				\ [(g:quickui_icons?"  ":"")."Joi&n line\tJ", 'join', 'Join current and next line and put between them a space'],
				\ [(g:quickui_icons?"  ":"")."Fo&rce join line\tgJ", 'normal! p', 'Join current and next line and leave blanks as it is'],
				\ ["--", '' ],
				\ [(g:quickui_icons?" ":"")."&Forward find <word>\t*", 'normal! *', 'Forwardly find whole word under cursor'],
				\ [(g:quickui_icons?" ":"")."&Backward find <word>\t#", 'normal! #', 'Backwardly find whole word under cursor'],
				\ [(g:quickui_icons?" ":"")."Fo&rward find word\tg*", 'normal! g*', 'Forwardly find word under cursor'],
				\ [(g:quickui_icons?" ":"")."B&ackward find word\tg#", 'normal! g#', 'Backwardly find word under cursor'],
				\ ["--", '' ],
				\ [(g:quickui_icons?"󰅺 ":"")."&Comment out\tLEAD /d", 'call DoCommentOutDefault()', 'Comment out line under cursor'],
				\ [(g:quickui_icons?"󱗡 ":"")."&Uncomment\tLEAD /u", 'call UncommentOutDefault()', 'Uncomment line under cursor'],
				\ ["--", '' ],
				\ [(g:quickui_icons?"󰗧 ":"")."Go to &multicursor mode\tCtrl-n", 'call vm#commands#ctrln(1)', 'Go to multicursor mode'],
				\ [(g:quickui_icons?" ":"")."Show hl&group", 'call SynGroup()', 'Show hlgroup name under cursor'],
				\ [(g:quickui_icons?" ":"")."&Whence hlgroup", 'call WhenceGroup()', 'Show whence hlgroup under cursor came'],
				\ [(g:quickui_icons?"󰒆 ":"")."&Select all\tCtrl-x h", 'call SelectAll()', 'Paste copyied text after the cursor'],
				\ [(g:quickui_icons?" ":"")."Toggle &tagbar\tCtrl-t", 'TagbarToggle', 'Toggles tagbar'],
				\ [(g:quickui_icons?" ":"")."Generate ann&otation\tLEAD n", 'Neogen', 'Generate Neogen annotation (:h neogen)'],
				\ ])

	call quickui#menu#install(s:lsp_label, [
				\ ["Coc &previous diagnostic\t[g", 'call CocActionAsync("diagnosticPrevious")', 'Go to previous diagnostic'],
				\ ["Coc &next diagnostic\t]g", 'call CocActionAsync("diagnosticNext")', 'Go to next diagnostic'],
				\ ["Go to &definition\tgd", 'call CocActionAsync("jumpDefinition")', 'Jump to definition'],
				\ ["Go to &type definition\tgy", 'call CocActionAsync("jumpTypeDefinition")', 'Jump to type definition'],
				\ ["Go to &implementation\tgi", 'call CocActionAsync("jumpImplementation")', 'Jump to implementation'],
				\ ["G&o to references\tgr", 'call CocActionAsync("jumpReferences")', 'Jump to references'],
				\ ["--", '' ],
				\ ["Code &actions selected\tLEAD a", 'call CocActionAsync("codeAction", visualmode())', 'Apply code actions for selected code'],
				\ ["Code actions &cursor\tLEAD ac", 'call CocActionAsync("codeAction", "cursor")', 'Apply code actions for current cursor position'],
				\ ["Code actions &buffer\tLEAD as", 'call CocActionAsync("codeAction", "", ["source"], v:true)', 'Apply code actions for current buffer'],
				\ ["Fi&x current line\tLEAD qf", 'call CocActionAsync("doQuickfix")', 'Apply the most preferred quickfix action to fix diagnostic on the current line'],
				\ ["--", '' ],
				\ ["&Refactor\tLEAD Re", 'call CocActionAsync("codeAction", "cursor", ["refactor"], v:true)', 'Codeaction refactor cursor'],
				\ ["Refactor s&elected\tLEAD R", 'call CocActionAsync("codeAction", visualmode(), ["refactor"], v:true)', 'Codeaction refactor selected'],
				\ ["--", '' ],
				\ ["C&ode lens current line\tLEAD cl", 'call CocActionAsync("codeLensAction")', 'Run the Code Lens action on the current line'],
				\ ["&Show documentation\tK", 'call ShowDocumentation()', 'Show documentation in preview window'],
				\ ["Rename s&ymbol\tLEAD rn", 'call CocActionAsync("rename")', 'Rename symbol under cursor'],
				\ ["&Format selected\tLEAD f", 'call CocActionAsync("formatSelected", visualmode())', 'Format selected code'],
				\ ["Fold c&urrent buffer\t:Fold", 'Fold', 'Make folds for current buffer'],
				\ ])

	" script inside %{...} will be evaluated and expanded in the string
	call quickui#menu#install(s:option_label, [
				\ [(g:quickui_icons?"󰓆 ":"")."Set &Spell %{&spell? 'Off':'On'}", 'set spell!', '%{(&spell?"Disable":"Enable")." spell checking"}'],
				\ [(g:quickui_icons?"󰆒 ":"")."Set &Paste %{&paste? 'Off':'On'}", 'set paste!'],
				\ ["--", '' ],
				\ [(g:quickui_icons?"  ":"").'Set Cursor &Column %{g:cursorcolumn==#v:true?"Off":"On"}', 'let g:cursorcolumn=!g:cursorcolumn|call HandleBuftypeAll()'],
				\ [(g:quickui_icons?"  ":"").'Set Cursor L&ine %{g:cursorline==#v:true?"Off":"On"}', 'let g:cursorline=!g:cursorline|call HandleBuftypeAll()'],
				\ [(g:quickui_icons?" ":"").'Set Line &numbers %{g:linenr==#v:true?"Off":"On"}', 'let g:linenr=!g:linenr|if !g:linenr|call PreserveAndDo("call STCNoAll()", v:true, v:true)|else|call PreserveAndDo("call NumbertoggleAll()", v:true, v:true)|endif'],
				\ ])

	call quickui#menu#install(s:config_label, [
			\ ["Open &init.vim\tLEAD ve", 'call SelectPosition(g:CONFIG_PATH."/init.vim", g:stdpos)', 'Open '.g:CONFIG_PATH.'/init.vim'],
			\ ["Open &plugins list\tLEAD vi", 'call SelectPosition(g:PLUGINS_INSTALL_FILE_PATH, g:stdpos)', 'Open '.g:PLUGINS_INSTALL_FILE_PATH],
			\ ["Open plugins set&up\tLEAD vs", 'call SelectPosition(g:PLUGINS_SETUP_FILE_PATH, g:stdpos)', 'Open '.g:PLUGINS_SETUP_FILE_PATH],
			\ ["Open lsp &settings\tLEAD vl", 'call SelectPosition(g:LSP_PLUGINS_SETUP_FILE_PATH, g:stdpos)', 'Open '.g:LSP_PLUGINS_SETUP_FILE_PATH.' (deprecated due to coc.nvim)'],
			\ ["Open &dotfiles config\tLEAD vj", 'call SelectPosition(g:DOTFILES_CONFIG_PATH, g:stdpos)', 'Open '.g:DOTFILES_CONFIG_PATH],
			\ ["Open &colorschemes\tLEAD C", 'call SelectPosition($VIMRUNTIME."/colors", g:stdpos)', 'Open colorschemes directory'],
			\ ["--", '' ],
			\ ["&Reload init.vim\tLEAD se", 'let old_tabpagenr=tabpagenr()|exec "source ".g:CONFIG_PATH."/init.vim"|exec old_tabpagenr."tabnext"', 'Reload Vim/NeoVim config'],
			\ ["R&eload plugins list\tLEAD si", 'exec "source ".g:PLUGINS_INSTALL_FILE_PATH', 'Install plugins in '.g:PLUGINS_INSTALL_FILE_PATH],
			\ ["Rel&oad plugins setup\tLEAD ss", 'exec "source ".g:PLUGINS_SETUP_FILE_PATH', 'Reconfigure plugins'],
			\ ["Relo&ad lsp setup\tLEAD sl", 'exec "source ".g:LSP_PLUGINS_SETUP_FILE_PATH', 'Reconfigure LSP plugins (deprecated due to coc.nvim)'],
			\ ["--", '' ],
			\ ])
	if executable('dotfiles')
		call quickui#menu#install(s:config_label, [
			\ ["&Generate dotfiles config\tLEAD G", 'GenerateDotfilesConfig', 'Regenerate dotfiles vim config'],
			\ ])
	endif
	if filereadable(g:DOTFILES_CONFIG_PATH)
		call quickui#menu#install(s:config_label, [
			\ ["Reload do&tfiles config\tLEAD sj", 'let old_tabpagenr=tabpagenr()|call LoadDotfilesConfig("'.expand(g:DOTFILES_CONFIG_PATH).'", v:true)|call HandleDotfilesConfig()|call HandleBuftypeAll()|exec old_tabpagenr."tabnext"', 'Reload dotfiles config'],
			\ ])
	endif

	" register HELP menu with weight 10000
	call quickui#menu#install(s:help_label, [
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
