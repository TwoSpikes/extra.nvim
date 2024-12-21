if g:compatible ==# "helix" || g:compatible ==# "helix_hard"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/helix/unload.vim')
else
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/no/unload.vim')
endif
