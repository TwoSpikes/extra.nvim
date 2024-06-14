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
				\ [(g:quickui_icons?"󰈙 ":"")."Ne&w File\t:new", 'new', 'Creates a new buffer'],
				\ [(g:quickui_icons?" ":"")."Cl&ose\tq", 'quit', 'Closes the current window'],
				\ [(g:quickui_icons?" ":"")."Force clos&e\tQ", 'quit!', 'Closes the current window without saving changes'],
				\ ["--", '' ],
				\ [(g:quickui_icons?"󰆓 ":"")."&Save\tCtrl-x s", 'write', 'Save changes in current buffer'],
				\ [(g:quickui_icons?"󰆔 ":"")."Save &all\tCtrl-x S", 'wall | echo "Saved all buffers"', 'Save changes to all buffers' ],
				\ [(g:quickui_icons?"󰳻 ":"")."Sa&ve as\tLEAD Ctrl-s", 'call SaveAs()', 'Save current file as ...' ],
				\ [(g:quickui_icons?"󰳻 ":"")."Sav&e as and ed&it\tLEAD Ctrl-r", 'call SaveAsAndRename()', 'Save current file as ... and edit it' ],
				\ ["--", '' ],
				\ [(g:quickui_icons?"󰚰 ":"")."Update &plugins\tLEAD u", 'lua require("packer").sync()', 'Clear and redraw the screen'],
				\ [(g:quickui_icons?"󰚰 ":"")."Update &coc servers\tLEAD Cu", 'CocUpdate', 'Update coc.nvim installed language servers'],
				\ [(g:quickui_icons?"󰚰 ":"")."Update &TreeSitter\tLEAD tu", 'TSUpdate', 'Update installed TreeSitter parsers'],
				\ ["--", '' ],
				\ [(g:quickui_icons?" ":"")."Redraw scree&n\tCtrl-l", 'mode', 'Clear and redraw the screen'],
				\ [(g:quickui_icons?" ":"")."Hi&de highlightings\tLEAD d", 'nohlsearch', 'Hide search highlightings'],
				\ [(g:quickui_icons?" ":"").s:esc_label."\tesc", s:esc_command, 'Stop searching'],
				\ [(g:quickui_icons?"󰊓 ":"")."Toggle &fullscreen\tLEAD Ctrl-f", 'ToggleFullscreen', 'Toggle fullscreen mode'],
				\ ["--", '' ],
				\ [(g:quickui_icons?"󰅗 ":"")."E&xit\tCtrl-x Ctrl-c", 'confirm qall', 'Close Vim/NeoVim softly'],
				\ [(g:quickui_icons?"󰅗 ":"")."Exit w/o confir&m\tCtrl-x Ctrl-q", 'qall!', 'Close Vim/NeoVim without saving'],
				\ ])

	call quickui#menu#install('&Window', [
				\ [(g:quickui_icons?"󱂥 ":"")."Kill b&uffer\tCtrl-x k", 'Killbuffer', 'Completely removes the current buffer'],
				\ [(g:quickui_icons?" ":"")."&Select buffer\tCtrl-x Ctrl-b", 'call quickui#tools#list_buffer("e")', 'Select buffer to edit in current buffer'],
				\ [(g:quickui_icons?"󱎸 ":"")."Find &word using Spectre\tLEAD sw", 'exec "lua require(\"spectre\").open_visual({select_word = true})"', 'Select buffer to edit in current buffer'],
				\ ["--", '' ],
				\ ])
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/vim-quickui")
		call quickui#menu#install('&Window', [
				\ [(g:quickui_icons?" ":"")."Open file in &tab\tCtrl-c c", 'Findfile', 'Open file in new tab'],
				\ [(g:quickui_icons?" ":"")."Open file in &buffer\tCtrl-c C", 'Findfilebuffer', 'Open file in current buffer'],
				\ ])
	endif
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/nerdtree")
		call quickui#menu#install('&Window', [
					\ [(g:quickui_icons?"󰙅 ":"")."Toggle &file tree\tCtrl-h", 'NERDTreeToggle', 'Toggles a file tree'],
					\ ])
	endif
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/telescope.nvim")
		call quickui#menu#install('&Window', [
					\ [(g:quickui_icons?"󰥨 ":"")."Telescope fu&zzy find\tLEAD ff", 'call FuzzyFind()', 'Opens Telescope.nvim find file'],
					\ ])
	endif
	if executable('ranger')
		call quickui#menu#install('&Window', [
					\ [(g:quickui_icons?" ":"")."Open file using &ranger\tLEAD r", 'call OpenRangerCheck()', 'Opens ranger to select file to open'],
					\ ])
	endif
	call quickui#menu#install('&Window', [
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
		call quickui#menu#install('&Window', [
				\ [(g:quickui_icons?" ":"")."Op&en Far/Mc\tLEAD m", 'call SelectPosition(g:far_or_mc, g:termpos)', 'Opens Far or Midnight commander'],
				\ ])
	endif
	if executable('lazygit')
		call quickui#menu#install('&Window', [
				\ [(g:quickui_icons?" ":"")."Open lazy&git\tLEAD z", 'call SelectPosition("lazygit", g:termpos)', 'Opens Lazygit'],
				\ ])
	endif
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/alpha-nvim")
		call quickui#menu#install('&Window', [
				\ [(g:quickui_icons?"󰍜 ":"")."Open st&art menu\tLEAD A", 'call RunAlphaIfNotAlphaRunning()', 'Opens alpha-nvim menu'],
				\ ])
	endif

	" items containing tips, tips will display in the cmdline
	call quickui#menu#install('&Text', [
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
				\ [(g:quickui_icons?" ":"")."F&orward find word\tg*", 'normal! g*', 'Forwardly find word under cursor'],
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
	call quickui#menu#install("&Option", [
				\ [(g:quickui_icons?"󰓆 ":"")."Set &Spell %{&spell? 'Off':'On'}", 'set spell!', '%{(&spell?"Disable":"Enable")." spell checking"}'],
				\ [(g:quickui_icons?"  ":"")."Set &Paste %{&paste? 'Off':'On'}", 'set paste!'],
				\ ["--", '' ],
				\ [(g:quickui_icons?"  ":"").'Set Cursor &Column %{g:cursorcolumn==#v:true?"Off":"On"}', 'let g:cursorcolumn=!g:cursorcolumn|call HandleBuftypeAll()'],
				\ [(g:quickui_icons?"  ":"").'Set Cursor L&ine %{g:cursorline==#v:true?"Off":"On"}', 'let g:cursorline=!g:cursorline|call HandleBuftypeAll()'],
				\ [(g:quickui_icons?" ":"").'Set Line &numbers %{g:linenr==#v:true?"Off":"On"}', 'let g:linenr=!g:linenr|if !g:linenr|call STCNo()|else|call Numbertoggle()|endif'],
				\ ])

	call quickui#menu#install('&Config', [
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
			\ ])
	if filereadable(g:DOTFILES_CONFIG_PATH)
		call quickui#menu#install('&Config', [
			\ ["Reload do&tfiles config\tLEAD sj", 'let old_tabpagenr=tabpagenr()|call LoadDotfilesConfig("'.expand(g:DOTFILES_CONFIG_PATH).'", v:true)|call HandleDotfilesConfig()|call HandleBuftypeAll()|exec old_tabpagenr."tabnext"', 'Reload dotfiles config'],
			\ ])
	endif

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
