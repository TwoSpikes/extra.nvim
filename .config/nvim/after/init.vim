function! InitPlug()
	execute "source ".g:CONFIG_PATH.'/vim/plugins/setup.vim'

	if has('nvim')
		execute printf("luafile %s", g:PLUGINS_INSTALL_FILE_PATH)
	endif
endfunction

function! OnStart()
	set nolazyredraw
	call InitPlug()

	call SetExNvimConfigPath()
	if has('nvim') && PluginInstalled("neo-tree") && g:automatically_open_neo_tree_instead_of_netrw
		autocmd! FileExplorer *
		augroup auto_neo_tree
			autocmd!
			autocmd BufEnter * if isdirectory(expand(expand("%")))|let prev_bufnr=bufnr()|execute "Neotree position=current" expand("%")|execute prev_bufnr."bwipeout!"|endif
		augroup END
	endif
	set termguicolors
	if filereadable(g:CONFIG_PATH.'/vim/init.vim')
		execute 'source' g:CONFIG_PATH.'/vim/init.vim'
		if has('nvim')
			execute printf("luafile %s", g:PLUGINS_SETUP_FILE_PATH)
		endif
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
		call timer_start(0, {->execute(printf('luafile %s', g:PLUGINS_SETUP_PATH.'/noice/setup.lua'))})
	endif
endfunction
call OnStart()

execute "source" g:CONFIG_PATH."/after/useless_functions.vim"
execute "source" g:CONFIG_PATH."/after/after_some_event.vim"
execute "source" g:CONFIG_PATH."/after/unsorted.vim"
execute "source" g:CONFIG_PATH."/after/autocmds.vim"

let g:exnvim_fully_loaded = v:true
silent! doautocmd User ExNvimLoaded
