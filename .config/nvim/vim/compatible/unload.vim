if g:compatible ==# "empty"
	finish
endif

if g:compatible =~# "^helix"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/helix/unload/unload.vim')
endif

if g:compatible ==# "no"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/no/unload/unload.vim')
endif

if v:false
\|| g:compatible ==# "common"
\|| g:compatible ==# "no"
\|| g:compatible =~# "^helix"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/common/unload/unload.vim')
endif
