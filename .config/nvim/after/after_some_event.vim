function! GetRandomName(length)
	let name = "Rnd_"
	for _ in range(a:length)
		let r = rand() % 3 + 1
		if v:false
		elseif r ==# 1
			let name .= nr2char(rand() % 10 + 48)
		elseif r ==# 2
			let name .= nr2char(rand() % 26 + 65)
		elseif r ==# 3
			let name .= nr2char(rand() % 26 + 97)
		else
			echohl ErrorMsg
			echomsg "Internal error"
			echohl Normal
		endif
	endfor
	unlet r
	return name
endfunction
function! GenerateTemporaryAutocmd(event, pattern, command, delete_when, group=v:null)
	if a:group ==# v:null
		let name = GetRandomName(20)
	else
		let name = a:group
	endif
	exec 'augroup '.name
		autocmd!
		execute "autocmd ".a:event." ".a:pattern." ".a:command."|".a:delete_when(name)
	augroup END
endfunction
function! AfterSomeEvent(event, command, delete_when={name -> 'au! '.name}, group=v:null)
	call GenerateTemporaryAutocmd(a:event, '*', a:command, a:delete_when, a:group)
endfunction

function! ShouldIClose(id=win_getid())
	if g:please_do_not_close_always
		return v:false
	endif
	let index = index(g:please_do_not_close, a:id)
	let should = index ==# -1
	if !should
		call remove(g:please_do_not_close, index)
	endif
	return should
endfunction

function! MakeThingsThatRequireBeDoneAfterPluginsLoaded()
	if has('nvim')
		augroup exnvim_term_closed
			autocmd!
			autocmd TermClose * if ShouldIClose() && !exists('g:bufnrforranger')|call AfterSomeEvent('TermLeave', 'call Numbertoggle()')|if v:event.status ==# 0|call OnQuit()|exec "confirm quit"|call OnQuitDisable()|endif|endif
		augroup END
	endif
endfunction
call MakeThingsThatRequireBeDoneAfterPluginsLoaded()

augroup AlphaNvim_CinnamonNvim_JK_Workaround
	autocmd!
	autocmd FileType alpha call JKWorkaroundAlpha()  | call AfterSomeEvent('BufLeave', 'call JKWorkaround()', {name -> 'au! '.name}, 'AlphaNvim_CinnamonNvim_JK_Workaround')
augroup END

augroup Lua_Require_Goto_Workaround
	autocmd!
	autocmd FileType lua exec "noremap <buffer> <c-w>f <cmd>call Lua_Require_Goto_Workaround_Wincmd_f()<cr>"
augroup END

let g:exnvim_fully_loaded += 1
