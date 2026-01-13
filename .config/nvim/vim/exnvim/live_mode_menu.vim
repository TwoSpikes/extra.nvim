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
function! ExNvimLogoAnimation(bufnr, ns_id)
	let g:exnvim_live_menu_animation_stage += 1
	call nvim_buf_clear_namespace(a:bufnr, a:ns_id, 0, line('$'))
	let i = 0
	let currentoptlen = g:exnvim_live_menu_currentoptlen
	let curi = g:exnvim_live_menu_currentidx
	let lb = g:exnvim_live_menu_lines_before
	let cb = g:exnvim_live_menu_columns_before
	while i <# currentoptlen
		call nvim_buf_add_highlight(a:bufnr, a:ns_id, 'ExNvimLogoAnimation'.float2nr(sin((g:exnvim_live_menu_animation_stage+i)/1.5)*5+5), lb+curi, cb+i, cb+i+1)
		let i = i+1
	endwhile
	mode
endfunction
function! ShowASelectionWindow(title, options, logo, actions, action_highlights, progressbar_action)
	if type(a:progressbar_action) !=# 7
		call timer_start(0, {->execute(a:progressbar_action)})
	endif
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
	if exists('currentoptionlength')
		unlet currentoptionlength
	endif
	let padding = repeat(' ',mediumcolumn-g:maxoptionlength/2)
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
	unlet padding
	setlocal nomodifiable
	setlocal nomodified
	mode
	if lenoptions>#0
		let ns_id_animation = nvim_create_namespace('live-mode-menu-logo-animation')
		let g:exnvim_live_menu_animation_stage = 0
		execute "let id=timer_start(50, {->ExNvimLogoAnimation(".bufnr.", ".ns_id_animation.")},{'repeat':-1})"
		let maxidx = len(a:actions)-1
		let g:exnvim_live_menu_currentidx = 0
		let g:exnvim_live_menu_lines_before = mediumline+additional_lines-1
		let g:exnvim_live_menu_columns_before = mediumcolumn-g:maxoptionlength/2
		let g:exnvim_live_menu_currentoptlen = len(a:options[0])+3
	endif
	unlet g:maxoptionlength
	unlet additional_lines
	if lenoptions>#0
		let currentidx_changed = v:true
	endif
	while v:true
		if lenoptions>#0
			if currentidx_changed
				let r = str2nr(a:action_highlights[g:exnvim_live_menu_currentidx][0][0:1], 16)
				let g = str2nr(a:action_highlights[g:exnvim_live_menu_currentidx][0][2:3], 16)
				let b = str2nr(a:action_highlights[g:exnvim_live_menu_currentidx][0][4:5], 16)
				let r2 = str2nr(a:action_highlights[g:exnvim_live_menu_currentidx][1][0:1], 16)
				let g2 = str2nr(a:action_highlights[g:exnvim_live_menu_currentidx][1][2:3], 16)
				let b2 = str2nr(a:action_highlights[g:exnvim_live_menu_currentidx][1][4:5], 16)
				let rd = (r2-r)/10
				let gd = (g2-g)/10
				let bd = (b2-b)/10
				let i = 0
				while i <=# 10
					let r3 = r+rd*i
					let g3 = g+gd*i
					let b3 = b+bd*i
					execute 'hi ExNvimLogoAnimation'.i.' guibg=#'.printf('%02x', r3).printf('%02x', g3).printf('%02x', b3).' guifg=#'.printf('%02x', 255-r3).printf('%02x', 255-g3).printf('%02x', 255-b3)
					let i = i+1
				endwhile
				let g:exnvim_live_menu_currentoptlen = len(a:options[g:exnvim_live_menu_currentidx])+len(string(g:exnvim_live_menu_currentidx+1))+2

			endif
		endif
		let c=getchar()
		if lenoptions>#0
			let idx=s:ctoidx(c)
			let action = v:null
			let currentidx_changed = v:true
			if idx==#-1
				if c==#"\<down>"
					let g:exnvim_live_menu_currentidx = g:exnvim_live_menu_currentidx + 1
					if g:exnvim_live_menu_currentidx>#maxidx
						let g:exnvim_live_menu_currentidx=0
					endif
				elseif c==#"\<up>"
					let g:exnvim_live_menu_currentidx = g:exnvim_live_menu_currentidx - 1
					if g:exnvim_live_menu_currentidx<#0
						let g:exnvim_live_menu_currentidx=maxidx
					endif
				elseif c==#13
					let action = a:actions[g:exnvim_live_menu_currentidx]
					let currentidx_changed = v:false
				endif
			else
				if idx>#maxidx
					let currentidx_changed = v:false
					continue
				endif
				let action = a:actions[idx]
			endif
			if type(action) !=# 7
				if len(action) ># 0
					call timer_start(0,{->execute(action)})
				endif
				break
			endif
		else
			if c==#13|break|endif
		endif
	endwhile
	unlet c
	unlet i
	if lenoptions>#0
		unlet idx
		unlet g:exnvim_live_menu_currentidx
		unlet g:exnvim_live_menu_lines_before
		unlet g:exnvim_live_menu_columns_before
		unlet currentidx_changed
		call timer_stop(id)
		unlet id
		if exists('ns_id')
			call nvim_buf_clear_namespace(bufnr, ns_id, 0, line('$')-1)
			unlet ns_id
		endif
		unlet ns_id_animation
	endif
	bwipeout!
	let &eventignore=OLDEVENTIGNORE
	unlet OLDEVENTIGNORE
	let &mouse=OLDMOUSE
	unlet OLDMOUSE
	if prev_filetype==#"alpha"
		exe "Alpha"
	endif
endfunction
call ShowASelectionWindow('extra.nvim'.(' '.(executable('exnvim')?trim(system('exnvim version')):'')), ['Install extra.nvim','Unload extra.nvim','Close this menu','Exit '.g:EDITOR_NAME], g:CONFIG_PATH.'/logo/logo.txt', ["call ExNvimSource(g:CONFIG_PATH.'/vim/exnvim/install.vim')", "call ExNvimSource(g:CONFIG_PATH.'/vim/exnvim/unload.vim')","","if exists('*OnQuit')|call OnQuit()|endif|execute 'normal ZZ'"], [['ffaa00', '0050ff'],['aaaaaa', '0000aa'],['ffffff', 'aaaaaa'],['ffaa00', 'ff0000']],v:null)
