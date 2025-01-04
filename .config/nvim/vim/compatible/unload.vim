if v:false
\|| g:compatible ==# "helix"
\|| g:compatible ==# "helix_hard"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/helix/unload.vim')
endif
if g:compatible ==# "no"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/no/unload.vim')
endif
