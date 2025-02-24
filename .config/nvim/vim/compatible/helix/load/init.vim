let g:sneak_mode = ''

function! LoadVars()
	if filereadable(expand(stdpath("data")).'/extra.nvim/last_selected.txt')
		let g:last_selected = readfile(expand(stdpath("data")).'/extra.nvim/last_selected.txt')[0]
	endif
	if filereadable(expand(stdpath("data")).'/extra.nvim/last_open_term_program.txt')
		let g:last_open_term_program = readfile(expand(stdpath("data")).'/extra.nvim/last_open_term_program.txt')[0]
	endif
endfunction
call LoadVars()
