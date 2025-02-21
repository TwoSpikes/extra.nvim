let old_winid = win_getid()

execute 'source' g:CONFIG_PATH.'/init.vim'

call win_gotoid(old_winid)
execute "Showtab"
call SetGitBranch()
