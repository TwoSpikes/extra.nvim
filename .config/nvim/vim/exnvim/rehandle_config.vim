call HandleExNvimConfig()
call RehandleExNvimConfig()
call PreserveAndDo("call HandleBuftypeAll()")
execute "Showtab"
execute "source" g:CONFIG_PATH."/vim/compatible/init.vim"
call RedefineProcessGBut()
execute 'colorscheme' g:selected_colorscheme
call ChangeLanguage()
if has("nvim")
	if PluginInstalled('alpha')
		execute "lua package.loaded[\"packages.alpha.setup\"] = nil"
		execute "lua require(\"packages.alpha.setup\")"
		if &filetype ==# "alpha"
			AlphaRedraw
			AlphaRemap
		endif
	endif
	if PluginInstalled('endscroll')
		execute "lua package.loaded[\"packages.endscroll.setup\"] = nil"
		execute "lua require(\"packages.endscroll.setup\")"
	endif
	if PluginInstalled('sneak')
		execute "source" g:CONFIG_PATH."/lua/packages/sneak/keymaps.vim"
	endif
endif
call SetMouse()

if !g:linenr
	call NoNu()
elseif g:linenr_style ==# "absolute"
	call AbsNu(mode())
else
	call RelNu()
endif

let g:quickui#style#border = g:quickui_border_style
