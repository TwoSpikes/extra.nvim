let old_winid = win_getid()

execute 'source' g:CONFIG_PATH.'/init.vim'
doautocmd VimEnter

call timer_start(0, {->HandleBuftypeAll()})

call win_gotoid(old_winid)
execute "Showtab"
call SetGitBranch()
