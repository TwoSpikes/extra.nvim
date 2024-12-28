call HandleExNvimConfig()
call RehandleExNvimConfig()
call PreserveAndDo("call HandleBuftypeAll()", v:true, v:true)
execute "Showtab"
execute "source" g:CONFIG_PATH."/vim/compatible/init.vim"
call RedefineProcessGBut()
call ApplyColorscheme(g:selected_colorscheme)
if has("nvim")
	if luaeval("plugin_installed(_A[1])", ["alpha-nvim"])
		exec "lua package.loaded[\"packages.alpha.setup\"] = nil"
		exec "lua require(\"packages.alpha.setup\")"
		if &filetype ==# "alpha"
			AlphaRedraw
			AlphaRemap
		endif
	endif
	if luaeval("plugin_installed(_A[1])", ["endscroll.nvim"])
		exec "lua package.loaded[\"packages.endscroll.setup\"] = nil"
		exec "lua require(\"packages.endscroll.setup\")"
	endif
	if luaeval("plugin_installed(_A[1])", ["vim-quickui"])
		call ChangeLanguage()
	endif
	if luaeval("plugin_installed(_A[1])", ["vim-sneak"])
		execute "source" g:CONFIG_PATH."/lua/packages/sneak/keymaps.vim"
	endif
endif
call SetMouse()

