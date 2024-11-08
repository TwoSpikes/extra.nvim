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
function! GenerateTemporaryAutocmd(event, pattern, command, delete_when)
	let random_name = GetRandomName(20)
	exec 'augroup '.random_name
		autocmd!
		execute "autocmd ".a:event." ".a:pattern." ".a:command."|".a:delete_when(random_name)
	augroup END
endfunction
function! AfterSomeEvent(event, command, delete_when={name -> 'au! '.name})
	call GenerateTemporaryAutocmd(a:event, '*', a:command, a:delete_when)
endfunction
let g:please_do_not_close = v:false

function! MakeThingsThatRequireBeDoneAfterPluginsLoaded()
	if has('nvim')
		autocmd TermClose * if !g:please_do_not_close && !exists('g:bufnrforranger')|call AfterSomeEvent('TermLeave', 'call Numbertoggle()')|call OnQuit()|exec "confirm quit"|call OnQuitDisable()|endif
	endif
endfunction
call MakeThingsThatRequireBeDoneAfterPluginsLoaded()

augroup AlphaNvim_CinnamonNvim_JK_Workaround
	autocmd!
	autocmd FileType alpha call JKWorkaroundAlpha()  | call AfterSomeEvent('BufLeave', 'call JKWorkaround()')
augroup END

augroup Lua_Require_Goto_Workaround
	autocmd!
	autocmd FileType lua exec "noremap <buffer> <c-w>f <cmd>call Lua_Require_Goto_Workaround_Wincmd_f()<cr>"
augroup END

let g:exnvim_fully_loaded += 1
