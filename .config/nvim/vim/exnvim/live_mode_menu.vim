let prev_filetype=&filetype
noswapfile enew
let bufnr=bufnr()
setlocal buftype=nofile
file Live mode menu
setlocal nocursorline
setlocal nocursorcolumn
setlocal nonumber
setlocal norelativenumber
setlocal filetype=livemenu
setlocal wrap
setlocal linebreak
let OLDMOUSE=&mouse
set mouse=
let OLDEVENTIGNORE=&eventignore
set eventignore=all
let mediumline=winheight(0)/2-3
let i=1
while i<mediumline
	call setline(i, '')
	let i=i+1
endwhile
unlet i
let mediumcolumn=winwidth(0)/2
call setline(mediumline, repeat(' ', mediumcolumn-7).'Live mode menu')
call setline(mediumline+1, '')
call setline(mediumline+2, repeat(' ', mediumcolumn-11).'1. Unload extra.nvim')
call setline(mediumline+3, repeat(' ', mediumcolumn-11).'2. Close this menu')
call setline(mediumline+4, repeat(' ', mediumcolumn-11).'3. Exit '.g:EDITOR_NAME)
setlocal nomodifiable
setlocal nomodified
mode
execute "let id=timer_start(100, {->execute('".bufnr."buffer|mode')}, {'repeat': -1})"
while v:true
	let char=getchar()
	if char==#49
		execute 'source' g:CONFIG_PATH.'/vim/exnvim/unload.vim'
		break
	endif
	if char==#50
		break
	endif
	if char==#51
		call OnQuit()
		normal ZZ
	endif
endwhile
call timer_stop(id)
unlet id
bwipeout!
let &eventignore=OLDEVENTIGNORE
unlet OLDEVENTIGNORE
let &mouse=OLDMOUSE
unlet OLDMOUSE
if prev_filetype==#"alpha"
	Alpha
endif
