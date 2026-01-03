function! ShowASelectionWindow(title, options, callback)
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
	let lenoptions = len(a:options)
	let mediumline=(winheight(0)-lenoptions)/2+1
	let i=1
	while i<#mediumline
		call setline(i, '')
		let i=i+1
	endwhile
	let mediumcolumn=winwidth(0)/2
	call setline(mediumline, CenterAString(a:title))
	call setline(mediumline+1, '')
	let g:maxoptionlength=0
	let i=0
	while i<#lenoptions
		let currentoptionlength=len(a:options[i])+len(string(i+1))+2
		if currentoptionlength>#g:maxoptionlength
			let g:maxoptionlength=currentoptionlength
		endif
		let i=i+1
	endwhile
	unlet currentoptionlength
	let i=0
	let padding = repeat(' ',mediumcolumn-g:maxoptionlength/2)
	unlet g:maxoptionlength
	while i<#lenoptions
		call setline(mediumline+i+2, padding.(i+1).'. '.a:options[i])
		let i=i+1
	endwhile
	unlet i
	unlet padding
	setlocal nomodifiable
	setlocal nomodified
	mode
	execute "let id=timer_start(100, {->execute('".bufnr."buffer|mode')}, {'repeat': -1})"
	execute "while v:true|let char=getchar()|".a:callback."|endwhile"
	call timer_stop(id)
	unlet id
	bwipeout!
	let &eventignore=OLDEVENTIGNORE
	unlet OLDEVENTIGNORE
	let &mouse=OLDMOUSE
	unlet OLDMOUSE
	if prev_filetype==#"alpha"
		exe "Alpha"
	endif
endfunction
call ShowASelectionWindow('Live mode menu', ['Unload extra.nvim','Close this menu','Exit '.g:EDITOR_NAME], "if char==#49|execute 'source' g:CONFIG_PATH.'/vim/exnvim/unload.vim'|break|endif|if char==#50|break|endif|if char==#51|if exists('*OnQuit')|call OnQuit()|endif|execute 'normal ZZ'|endif")
