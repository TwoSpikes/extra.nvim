exec printf('so %s', g:CONFIG_PATH.'/vim/lib/init.vim')

if filereadable(expand(g:CONFIG_PATH.'/vim/xterm-color-table.vim'))
	exec printf('so %s', g:CONFIG_PATH.'/vim/xterm-color-table.vim')
endif

if !g:without_plugin_manager
	exec printf('so %s', g:CONFIG_PATH.'/vim/plugins/plugins.vim')
endif
exec printf('so %s', g:CONFIG_PATH.'/vim/compatible/init.vim')
