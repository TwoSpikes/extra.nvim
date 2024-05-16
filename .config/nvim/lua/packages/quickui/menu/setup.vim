" clear all the menus
call quickui#menu#reset()

" install a 'File' menu, use [text, command] to represent an item.
call quickui#menu#install('&File', [
            \ ["&New File\t:new", 'new', 'Creates a new buffer'],
            \ ["&Quit\tq", 'quit', 'Closes the current window'],
            \ ["Q&uit without saving\tQ", 'quit!', 'Closes the current window without saving changes'],
            \ ["&Kill buffer\tCtrl-x k", 'Killbuffer', 'Completely removes the current buffer'],
            \ ["--", '' ],
            \ ["&Toggle file tree\tCtrl+n", 'NERDTreeToggle', 'Toggles a file tree'],
            \ ["&Open file in tab\tCtrl-c c", 'Findfile', 'Open file in new tab'],
            \ ["Open file in &buffer\tCtrl-c C", 'Findfilebuffer', 'Open file in current buffer'],
            \ ["--", '' ],
            \ ["&Save\tCtrl+x s", 'write', 'Save changes in current buffer'],
            \ ["Save &All\tCtrl+x S", 'wall | echo "Saved all buffers"', 'Save changes to all buffers' ],
            \ ["--", '' ],
            \ ["&Make only\tCtrl-x 1", 'only', 'Hide all but current window'],
            \ ["&Previous window\tCtrl-x o", 'exec "normal! \<c-w>w"', 'Go to previous window'],
            \ ["&Next window\tCtrl-x O", 'exec "normal! \<c-w>W"', 'Go to next window'],
            \ ["--", '' ],
            \ ["&Exit\tCtrl-x Ctrl-c", 'confirm qall', 'Close Vim/NeoVim softly'],
            \ ["E&xit without saving\tCtrl-x Ctrl-q", 'qall!', 'Close Vim/NeoVim without saving'],
            \ ])

" items containing tips, tips will display in the cmdline
call quickui#menu#install('&Edit', [
            \ ["&Copy line\tyy", 'yank', 'Copy the line where cursor is located'],
            \ ["&Paste\tp", 'normal! p', 'Paste copyied text after the cursor'],
            \ ])

" script inside %{...} will be evaluated and expanded in the string
call quickui#menu#install("&Option", [
			\ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
			\ ['Set &Cursor Column %{g:cursorcolumn==#v:true?"Off":"On"}', 'let g:cursorcolumn=g:cursorcolumn==#v:true?v:false:v:true|call HandleBuftype()'],
			\ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
			\ ])

" register HELP menu with weight 10000
call quickui#menu#install('H&elp', [
			\ ["&Cheatsheet", 'help index', ''],
			\ ['T&ips', 'help tips', ''],
			\ ['--',''],
			\ ["&Tutorial", 'help tutor', ''],
			\ ['&Quick Reference', 'help quickref', ''],
			\ ['&Summary', 'help summary', ''],
			\ ['Show &dotfiles cheatsheet', 'DotfilesCheatSheet', 'dotfiles cheatsheet']
			\ ], 10000)

" enable to display tips in the cmdline
let g:quickui_show_tip = 1

" hit space twice to open menu
noremap <space><space> :call quickui#menu#open()<cr>
