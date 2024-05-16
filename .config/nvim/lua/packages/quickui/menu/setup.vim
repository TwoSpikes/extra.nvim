" clear all the menus
call quickui#menu#reset()

" install a 'File' menu, use [text, command] to represent an item.
call quickui#menu#install('&File', [
            \ ["&New File", 'new', 'Creates a new buffer'],
            \ ["&Open File\tCtrl+n", 'NERDTreeToggle', 'Opens a file tree'],
            \ ["&Close", 'quit', 'Closes the current buffer'],
            \ ["--", '' ],
            \ ["&Save\tCtrl+x s", 'write', 'Save changes in current buffer'],
            \ ["Save &All", 'wall | echo "Saved all buffers"', 'Save changes to all buffers' ],
            \ ["--", '' ],
            \ ["E&xit\tCtrl-x Ctrl-c", 'qall', 'Close Vim/NeoVim'],
            \ ])

" items containing tips, tips will display in the cmdline
call quickui#menu#install('&Edit', [
            \ ["&Copy line\tyy", 'normal! vy', 'Copy the line where cursor is located'],
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
			\ ], 10000)

" enable to display tips in the cmdline
let g:quickui_show_tip = 1

" hit space twice to open menu
noremap <space><space> :call quickui#menu#open()<cr>
