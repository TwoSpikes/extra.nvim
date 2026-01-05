function! s:ctoidx(c)
	if a:c==#49|return 0|endif "1
	if a:c==#50|return 1|endif "2
	if a:c==#51|return 2|endif "3
	if a:c==#52|return 3|endif "4
	if a:c==#53|return 4|endif "5
	if a:c==#54|return 5|endif "6
	if a:c==#55|return 6|endif "7
	if a:c==#56|return 7|endif "8
	if a:c==#57|return 8|endif "9
	" TODO: Implement letters also
	return -1
endfunction
function! ShowASelectionWindow(title, options, logo, actions)
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
	let mediumcolumn=winwidth(0)/2
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
	let padding = repeat(' ',mediumcolumn-g:maxoptionlength/2)
	unlet g:maxoptionlength
	let additional_lines = 1
	if type(a:logo) !=# 7
		let logo = ExNvimReadFile(a:logo)
		let logolen = len(logo)
		let i=0
		let g:maxlogolength=0
		while i<#logolen
			let currentlogolength=strdisplaywidth(logo[i])
			if currentlogolength>#g:maxlogolength
				let g:maxlogolength=currentlogolength
			endif
			let i=i+1
		endwhile
	else
		let logolen = 0
	endif

	let mediumline=(winheight(0)-lenoptions-logolen)/2+1
	let i=1
	while i<#mediumline
		call setline(i, '')
		let i=i+1
	endwhile
	call setline(mediumline, CenterAString(a:title))
	call setline(mediumline+1, '')

	if type(a:logo) !=# 7
		unlet currentlogolength
		let ns_id = nvim_create_namespace('live-mode-menu-logo')
		let padding_2 = repeat(' ',mediumcolumn-g:maxlogolength/2)
		let winwidth = winwidth(0)
		let i=0
		while i<#logolen
			call setline(mediumline+i+additional_lines, padding_2.logo[i])
			call nvim_buf_add_highlight(bufnr, ns_id, "ExNvimLogo", mediumline+i+additional_lines-1, 0, winwidth)
			let i=i+1
		endwhile
		let additional_lines=additional_lines+logolen
		unlet logo
		unlet g:maxlogolength
		unlet ns_id
		unlet padding_2
		unlet winwidth
	endif
	unlet logolen
	call setline(mediumline+additional_lines, '')
	let additional_lines=additional_lines+1
	let i=0
	while i<#lenoptions
		call setline(mediumline+i+additional_lines, padding.(i+1).'. '.a:options[i])
		let i=i+1
	endwhile
	unlet i
	unlet padding
	unlet additional_lines
	setlocal nomodifiable
	setlocal nomodified
	mode
	execute "let id=timer_start(100, {->execute('".bufnr."buffer|mode')}, {'repeat': -1})"
	let maxidx = len(a:actions)-1
	while v:true
		let idx=s:ctoidx(getchar())
		if idx==#-1|continue|endif
		if idx>#maxidx|continue|endif
		let action = a:actions[idx]
		if type(action) ==# 7
			"null means break
		else
			call timer_start(0,{->execute(action)})
		endif
		break
	endwhile
	unlet idx
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
call ShowASelectionWindow('Live mode menu', ['Configure extra.nvim & maybe install','Unload extra.nvim','Close this menu','Exit '.g:EDITOR_NAME], g:CONFIG_PATH.'/logo/logo.txt', ["call ExNvimSource(g:CONFIG_PATH.'/vim/exnvim/install.vim')", "call ExNvimSource(g:CONFIG_PATH.'/vim/exnvim/unload.vim')",v:null,"if exists('*OnQuit')|call OnQuit()|endif|execute 'normal ZZ'"])
