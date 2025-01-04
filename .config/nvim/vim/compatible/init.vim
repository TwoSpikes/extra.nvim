if v:false
\|| g:compatible ==# "common"
\|| g:compatible ==# "no"
\|| g:compatible ==# "helix"
\|| g:compatible ==# "helix_hard"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/common/load.vim')
endif

if v:false
\|| g:compatible ==# "no"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/no/load.vim')
endif

if v:false
\|| g:compatible ==# "helix"
\|| g:compatible ==# "helix_hard"
	exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/helix/init.vim')
endif
