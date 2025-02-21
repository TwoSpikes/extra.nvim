let g:sneak_mode = ''

function! LoadVars()
	if filereadable(expand(g:LOCALSHAREPATH).'/extra.nvim/last_selected.txt')
		let g:last_selected = readfile(expand(g:LOCALSHAREPATH).'/extra.nvim/last_selected.txt')[0]
	endif
	if filereadable(expand(g:LOCALSHAREPATH).'/extra.nvim/last_open_term_program.txt')
		let g:last_open_term_program = readfile(expand(g:LOCALSHAREPATH).'/extra.nvim/last_open_term_program.txt')[0]
	endif
endfunction
call LoadVars()
