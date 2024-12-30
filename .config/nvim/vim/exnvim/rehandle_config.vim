call HandleExNvimConfig()
call RehandleExNvimConfig()
call PreserveAndDo("call HandleBuftypeAll()", v:true, v:true)
execute "Showtab"
execute "source" g:CONFIG_PATH."/vim/compatible/init.vim"
call RedefineProcessGBut()
call ApplyColorscheme(g:selected_colorscheme)
if has("nvim")
	if PluginInstalled('alpha')
		exec "lua package.loaded[\"packages.alpha.setup\"] = nil"
		exec "lua require(\"packages.alpha.setup\")"
		if &filetype ==# "alpha"
			AlphaRedraw
			AlphaRemap
		endif
	endif
	if PluginInstalled('endscroll')
		exec "lua package.loaded[\"packages.endscroll.setup\"] = nil"
		exec "lua require(\"packages.endscroll.setup\")"
	endif
	if PluginExists('vim-quickui')
		call ChangeLanguage()
	endif
	if PluginInstalled('sneak')
		execute "source" g:CONFIG_PATH."/lua/packages/sneak/keymaps.vim"
	endif
endif
call SetMouse()

