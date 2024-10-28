exec "source" g:CONFIG_PATH."/vim/compatible/unload.vim"
call LoadExNvimConfig(g:EXNVIM_CONFIG_PATH, v:true)
call HandleExNvimConfig()
call RehandleExNvimConfig()
call PreserveAndDo("call HandleBuftypeAll()", v:true, v:true)
execute "Showtab"
exec "source" g:CONFIG_PATH."/vim/compatible/init.vim"
call RedefineProcessGBut()
call ApplyColorscheme(g:selected_colorscheme)
if has("nvim")
	exec "lua package.loaded[\"packages.alpha.setup\"] = nil"
	exec "lua require(\"packages.alpha.setup\")"
	exec "lua package.loaded[\"packages.endscroll.setup\"] = nil"
	exec "lua require(\"packages.endscroll.setup\")"
endif
