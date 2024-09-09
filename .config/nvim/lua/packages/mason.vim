function! Mason_better()
	execute printf("colorscheme %s", g:selected_colorscheme)
	lua require('mason.ui').open()
endfunction
command! -nargs=0 Mason call Mason_better()
