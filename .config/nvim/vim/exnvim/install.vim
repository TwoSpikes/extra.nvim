function! ExNvimInstallPre()
	cd ~/extra.nvim/
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
		call InvokeCriticalError(["mkdir failed with exit code ".v:shell_error])
		return v:shell_error
	endif
	return 0
endfunction
function! ExNvimInstallationCountFiles()
	return ExNvimCountFiles('.config/nvim')
endfunction
function! ExNvimInstallationChangeColors(c1, c2)
	let r = str2nr(a:c1[0:1], 16)
	let g = str2nr(a:c1[2:3], 16)
	let b = str2nr(a:c1[4:5], 16)
	let r2 = str2nr(a:c2[0:1], 16)
	let g2 = str2nr(a:c2[2:3], 16)
	let b2 = str2nr(a:c2[1][4:5], 16)
	let rd = (r2-r)/10
	let gd = (g2-g)/10
	let bd = (b2-b)/10
	let i = 0
	while i <=# 10
		let r3 = r+rd*i
		let g3 = g+gd*i
		let b3 = b+bd*i
		execute 'hi ExNvimInstallAnimation'.i.' guibg=#'.printf('%02x', r3).printf('%02x', g3).printf('%02x', b3).' guifg=#'.printf('%02x', 255-r3).printf('%02x', 255-g3).printf('%02x', 255-b3)
		let i = i+1
	endwhile
endfunction
function! ExNvimInstallationCopyFiles(bufnr)
	call ExNvimInstallationChangeColors('ffaa00', 'ff0000')
	let ns_id = nvim_create_namespace('live-mode-menu-logo-animation')
	call ExNvimCopyDirAll('.config/nvim', expand('$HOME'), 'let g:exnvim_installation_count += 1|if g:exnvim_installation_count%10==0|call ExNvimRerenderAProgressbarWindow('.a:bufnr.','.ns_id.')|endif')
	call ExNvimInstallationChangeColors('00ff00', '008000')
endfunction
function! ExNvimInstallUi()
	let g:abka = ""
	if ExNvimInstallPre() !=# 0
		return
	endif
	let g:exnvim_installation_pbarlen = winwidth(0)-10
	let g:exnvim_installation_pbarstart = 5
	let g:exnvim_installation_count = 0
	let g:exnvim_installation_total = 1
	let g:exnvim_installation_state = "Counting items..."
	let bufnr = ShowAProgressbarWindow()
	unlet bufnr
	let files_count = ExNvimInstallationCountFiles()
	let g:exnvim_installation_total = files_count
	let g:exnvim_installation_state = "Copying files..."
	let bufnr = ShowAProgressbarWindow()
	call ExNvimInstallationCopyFiles(bufnr)
endfunction
function! ExNvimInstallShowResult()
	let res = ExNvimInstall()
	if res ==# 0
		let g:exnvim_selection_window_close='ExNvimInstallShowResultOk'
	else
		let g:exnvim_selection_window_close='ExNvimInstallShowResultErr'
	endif
endfunction
call ShowASelectionWindow('Use default configuration?', ['Yes, use default', 'No, configure from scratch'], v:null, ["call ExNvimInstallUi()", "call ExNvimConfigure()|call ExNvimInstallUi()"], [['40ff40','00aa00'],['aaaaaa','808080']])
function! ExNvimConfigure()
	call InvokeCriticalError(['Not implemented yet'])
	return 1
endfunction
