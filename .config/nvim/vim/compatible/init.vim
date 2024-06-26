if v:false
elseif g:compatible ==# "helix"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/helix/init.vim')
endif
