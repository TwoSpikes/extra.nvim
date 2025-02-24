function! OnStart()
	set nolazyredraw
	call InitPckr()

	call SetExNvimConfigPath()
	if has('nvim') && PluginInstalled("neo-tree") && g:automatically_open_neo_tree_instead_of_netrw
		autocmd! FileExplorer *
		augroup auto_neo_tree
			autocmd!
			autocmd BufEnter * if isdirectory(expand(expand("%")))|let prev_bufnr=bufnr()|execute "Neotree position=current" expand("%")|execute prev_bufnr."bwipeout!"|endif
		augroup END
	endif
	if has('nvim')
		set termguicolors
		execute printf("luafile %s", g:PLUGINS_SETUP_FILE_PATH)
	endif
	if filereadable(expand(stdpath('config')).'/vim/init.vim')
		execute 'source' stdpath('config').'/vim/init.vim'
	else
		echohl ErrorMsg
		if g:language ==# 'russian'
			echomsg "блядь: не удалось найти файл инициализации"
		else
			echomsg "error: unable to find initialization file"
		endif
		let g:compatible = "no"
		call timer_srart(0, {->RedefineProcessGBut()})
	endif
	if has('nvim') && g:compatible !~# "^helix_hard" && PluginInstalled('notify')
		call timer_start(0, {->execute(printf('luafile %s', fnamemodify(g:PLUGINS_SETUP_FILE_PATH, ':h').'/noice/setup.lua'))})
	endif
endfunction
call OnStart()

execute "source" stdpath('config')."/after/useless_functions.vim"
execute "source" stdpath('config')."/after/after_some_event.vim"
execute "source" stdpath('config')."/after/unsorted.vim"
execute "source" stdpath('config')."/after/autocmds.vim"
