" clear all the menus
call quickui#menu#reset()

" install a 'File' menu, use [text, command] to represent an item.
call quickui#menu#install('&File', [
            \ ["Ne&w File\t:new", 'new', 'Creates a new buffer'],
            \ ["&Quit\tq", 'quit', 'Closes the current window'],
            \ ["Force q&uit\tQ", 'quit!', 'Closes the current window without saving changes'],
            \ ["&Kill buffer\tCtrl-x k", 'Killbuffer', 'Completely removes the current buffer'],
            \ ["--", '' ],
            \ ["&Open file in tab\tCtrl-c c", 'Findfile', 'Open file in new tab'],
            \ ["Open file in &buffer\tCtrl-c C", 'Findfilebuffer', 'Open file in current buffer'],
            \ ["&Toggle file tree\tCtrl-n", 'NERDTreeToggle', 'Toggles a file tree'],
            \ ["Toggle ta&gbar\tCtrl-t", 'TagbarToggle', 'Toggles a file tree'],
            \ ["--", '' ],
            \ ["&Save\tCtrl-x s", 'write', 'Save changes in current buffer'],
            \ ["Save &All\tCtrl-x S", 'wall | echo "Saved all buffers"', 'Save changes to all buffers' ],
            \ ["--", '' ],
            \ ["&Make only\tCtrl-x 1", 'only', 'Hide all but current window'],
            \ ["&Previous window\tCtrl-x o", 'exec "normal! \<c-w>w"', 'Go to previous window'],
            \ ["&Next window\tCtrl-x O", 'exec "normal! \<c-w>W"', 'Go to next window'],
            \ ["--", '' ],
            \ ["Update &plugins\tLEAD u", 'lua require("packer").sync()', 'Clear and redraw the screen'],
            \ ["Update &coc language servers\tLEAD cu", 'CocUpdate', 'Update coc.nvim installed language servers'],
            \ ["--", '' ],
            \ ["&Redraw screen\tCtrl-l", 'mode', 'Clear and redraw the screen'],
            \ ["&Hide highlightings\tLEAD d", 'noh', 'Hide search highlightings'],
            \ ["Toggle &fullscreen\tLEAD Ctrl-f", 'ToggleFullscreen', 'Toggle fullscreen mode'],
            \ ["--", '' ],
            \ ["&Exit\tCtrl-x Ctrl-c", 'confirm qall', 'Close Vim/NeoVim softly'],
            \ ["Force e&xit\tCtrl-x Ctrl-q", 'qall!', 'Close Vim/NeoVim without saving'],
            \ ])

" items containing tips, tips will display in the cmdline
call quickui#menu#install('&Edit', [
            \ ["Cop&y line\tyy", 'yank', 'Copy the line where cursor is located'],
            \ ["&Delete line\tsd", 'delete x', 'Delete the line where cursor is located'],
            \ ["C&ut line\tdd", 'delete _', 'Cut the line where cursor is located'],
            \ ["&Paste after\tp", 'normal! p', 'Paste copyied text after the cursor'],
            \ ["Paste &before\tP", 'normal! P', 'Paste copyied text before the cursor'],
            \ ["&Join line\tJ", 'join', 'Join current and next line and put between them a space'],
            \ ["Fo&rce join line\tgJ", 'normal! p', 'Join current and next line and leave blanks as it is'],
            \ ["--", '' ],
            \ ["&Forward find word\t*", 'normal! *', 'Forwardly find word under cursor'],
            \ ["&Backward find word\t#", 'normal! #', 'Backwardly find word under cursor'],
            \ ["--", '' ],
            \ ["&Comment out current line\tLEAD /d", 'call DoCommentOutDefault()', 'Backwardly find word under cursor'],
            \ ["&Uncomment current line\tLEAD /u", 'call UncommentOutDefault()', 'Backwardly find word under cursor'],
            \ ["--", '' ],
            \ ["&Select all\tCtrl-x h", 'call SelectAll()', 'Paste copyied text after the cursor'],
            \ ])

" script inside %{...} will be evaluated and expanded in the string
call quickui#menu#install("&Option", [
			\ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
			\ ['Set &Cursor Column %{g:cursorcolumn==#v:true?"Off":"On"}', 'let g:cursorcolumn=g:cursorcolumn==#v:true?v:false:v:true|call HandleBuftype()'],
			\ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
			\ ])

call quickui#menu#install('&Config', [
		\ ["Open &init.vim\tLEAD ve", 'call SelectPosition("e ".g:CONFIG_PATH."/init.vim")', 'Open '.g:CONFIG_PATH.'/init.vim'],
		\ ["Open &plugins\tLEAD vi", 'call SelectPosition("e ".g:PLUGINS_INSTALL_FILE_PATH)', 'Open '.g:PLUGINS_INSTALL_FILE_PATH],
		\ ["Open plugins &setup\tLEAD vs", 'call SelectPosition("e ".g:PLUGINS_SETUP_FILE_PATH)', 'Open '.g:PLUGINS_SETUP_FILE_PATH],
		\ ["Open &lsp settings\tLEAD vs", 'call SelectPosition("e ".g:LSP_PLUGINS_SETUP_FILE_PATH)', 'Open '.g:LSP_PLUGINS_SETUP_FILE_PATH],
		\ ["Open &json config\tLEAD vj", 'call SelectPosition("e ".g:DOTFILES_CONFIG_PATH."/config.json")', 'Open '.g:DOTFILES_CONFIG_PATH.'/config.json'],
	  \ ])

" register HELP menu with weight 10000
call quickui#menu#install('H&elp', [
			\ ["&Cheatsheet", 'help index', ''],
			\ ['T&ips', 'help tips', ''],
			\ ['--',''],
			\ ["&Tutorial", 'help tutor', ''],
			\ ['&Quick Reference', 'help quickref', ''],
			\ ['&Summary', 'help summary', ''],
			\ ["&Dotfiles cheatsheet\tLEAD ?", 'DotfilesCheatSheet', 'dotfiles cheatsheet']
			\ ], 10000)

" enable to display tips in the cmdline
let g:quickui_show_tip = 1

" hit space twice to open menu
noremap <space><space> :call quickui#menu#open()<cr>
