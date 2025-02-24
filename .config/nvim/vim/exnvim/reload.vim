let old_winid = win_getid()

execute 'source' stdpath('config').'/init.vim'

call win_gotoid(old_winid)
execute "Showtab"
call SetGitBranch()
