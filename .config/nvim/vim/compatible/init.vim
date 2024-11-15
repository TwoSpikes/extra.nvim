exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/common/load.vim')
exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/no/load.vim')

if v:false
elseif g:compatible ==# "helix" || g:compatible ==# "helix_hard"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/helix/init.vim')
endif
