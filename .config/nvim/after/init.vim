call timer_start(0, {->execute("source ".g:CONFIG_PATH."/after/after_some_event.vim")})
execute "source" g:CONFIG_PATH."/after/unsorted.vim"
