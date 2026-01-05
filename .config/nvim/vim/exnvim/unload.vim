if !exists("g:exnvim_fully_loaded")
	finish
endif
execute 'source' g:CONFIG_PATH.'/vim/exnvim/unload_base.vim'
if !g:without_plugin_manager
	execute 'source' g:CONFIG_PATH.'/vim/exnvim/unload_misc.vim'
endif
mode
redraw
