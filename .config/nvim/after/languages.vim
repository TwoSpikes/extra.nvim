function! SelectFallbackLanguage(check_function)
	if a:check_function(g:language)
		return g:language
	endif
	if g:language ==# 'komi'
		if a:check_function('russian')
			return 'russian'
		endif
	endif
	return 'english'
endfunction

let g:exnvim_mapleader = mapleader

function! ChangeLanguage()
	call ChangeLanguageQuickuiMenuAll()
endfunction

autocmd User ExNvimLoaded call ChangeLanguage()
