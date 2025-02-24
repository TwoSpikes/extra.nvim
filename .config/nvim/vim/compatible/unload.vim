if g:compatible =~# "^helix"
	exec printf('so %s', stdpath('config').'/vim/compatible/helix/unload/unload.vim')
endif
if g:compatible ==# "no"
	exec printf('so %s', stdpath('config').'/vim/compatible/no/unload/unload.vim')
endif
