exec printf('so %s', stdpath('config').'/vim/lib/init.vim')

if filereadable(expand(stdpath('config').'/vim/xterm-color-table.vim'))
	exec printf('so %s', stdpath('config').'/vim/xterm-color-table.vim')
endif

exec printf('so %s', stdpath('config').'/vim/compatible/init.vim')

