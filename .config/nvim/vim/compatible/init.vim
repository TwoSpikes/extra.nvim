if g:compatible ==# "empty"
	finish
endif

if v:false
\|| g:compatible ==# "common"
\|| g:compatible ==# "no"
\|| g:compatible =~# "^helix"
	exec printf('so %s', stdpath('config').'/vim/compatible/common/load/load.vim')
endif

if v:false
\|| g:compatible ==# "no"
	exec printf('so %s', stdpath('config').'/vim/compatible/no/load/load.vim')
endif

if g:compatible =~# "helix"
	exec printf('so %s', stdpath('config').'/vim/compatible/helix/load/load.vim')
endif
