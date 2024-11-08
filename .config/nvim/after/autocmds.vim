augroup ExNvimOptionsInComment
	autocmd!
	autocmd BufEnter * if v:vim_did_enter|call HandleExNvimOptionsInComment()|endif
augroup END
