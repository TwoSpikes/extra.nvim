if filereadable(expand(g:CONFIG_PATH.'/vim/xterm-color-table.vim'))
	exec printf('so %s', g:CONFIG_PATH.'/vim/xterm-color-table.vim')
endif
