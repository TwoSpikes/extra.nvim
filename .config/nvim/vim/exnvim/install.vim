function! ExNvimInstallPre()
	cd ~/extra.nvim/
	call system(['mkdir','-p',expand('$HOME').'/.config/nvim'])
	sleep 2
	return
	if !isdirectory('./.config/nvim')
		call InvokeCriticalError(["Cannot find extra.nvim files to install"])
		return
	endif
	try
		call system(['mkdir','-p',expand('$HOME').'/.config/nvim'])
	catch
		return 1
	endtry
	if v:shell_error!=#0
		call InvokeCriticalError("mkdir failed with exit code ".v:shell_error])
		return v:shell_error
	endif
	return 0
endfunction
function! ExNvimInstallUi()
	let g:abka = ""
	call ExNvimInstallPre()
	call ExNvimCopyDirAll('.config/nvim', expand('$HOME'), '')
endfunction
function! ExNvimInstallShowResult()
	let res = ExNvimInstall()
	if res ==# 0
		let g:exnvim_selection_window_close='ExNvimInstallShowResultOk'
	else
		let g:exnvim_selection_window_close='ExNvimInstallShowResultErr'
	endif
endfunction
function! ExNvimInstallShowResultOk()
	call ShowASelectionWindow('Installation was successful', [], v:null, [], [])
endfunction
function! ExNvimInstallShowResultErr()
	call ShowASelectionWindow('Installation gone wrong', [], v:null, [], [])
endfunction
call ShowASelectionWindow('Use default configuration?', ['Yes, use default', 'No, configure from scratch'], v:null, ["call ExNvimInstallUi()", "call ExNvimConfigure()|call ExNvimInstallUi()"], [['40ff40','00aa00'],['aaaaaa','808080']], v:null)
function! ExNvimConfigure()
	call InvokeCriticalError(['Not implemented yet'])
	return 1
endfunction
