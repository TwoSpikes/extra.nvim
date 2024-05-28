function! Mason_better()
	exec printf("so %s", g:COLORSCHEME_PATH)
	lua require('mason.ui').open()
endfunction
command! -nargs=0 Mason call Mason_better()
