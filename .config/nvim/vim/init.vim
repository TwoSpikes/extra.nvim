exec printf('so %s', g:CONFIG_PATH.'/vim/lib/init.vim')
exec printf('so %s', g:CONFIG_PATH.'/after/init.vim')

if filereadable(expand(g:CONFIG_PATH.'/vim/xterm-color-table.vim'))
	exec printf('so %s', g:CONFIG_PATH.'/vim/xterm-color-table.vim')
endif

exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/init.vim')
