call PreserveAndDo('execute "source" g:CONFIG_PATH."/init.vim"')

call PreserveAndDo("call HandleBuftypeAll()")
execute "Showtab"
call SetGitBranch()
