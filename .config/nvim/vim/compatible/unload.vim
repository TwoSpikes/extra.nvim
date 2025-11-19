if g:compatible =~# "^helix"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/helix/unload/unload.vim')
endif
if g:compatible ==# "no"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/no/unload/unload.vim')
endif
