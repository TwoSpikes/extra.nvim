function! ExNvimCountFiles(dir)
	let entries = readdir(a:dir)
	let count = 0
	for i in entries
		if isdirectory(a:dir.'/'.i)
			let count += ExNvimCountFiles(a:dir.'/'.i)
		else
			let count += 1
		endif
	endfor
	return count
endfunction
function! ExNvimWalkDir(dir, cb_dir, cb_file)
	let entries = readdir(a:dir)
	for i in entries
		if isdirectory(a:dir.'/'.i)
			execute a:cb_dir
			call ExNvimWalkDir(a:dir.'/'.i, cb_dir, cb_file)
		else
			execute a:cb_file
		endif
	endfor
endfunction
function! ExNvimCopyDirAll(dir, dest, cb_file)
	let entries = readdir(a:dir)
	for i in entries
		if isdirectory(a:dir.'/'.i)
			call mkdir(a:dest.'/'.a:dir.'/'.i)
			call ExNvimCopyDirAll(a:dir.'/'.i, a:dest, a:cb_file)
		else
			call system(['cp', a:dir.'/'.i, a:dest.'/'.a:dir.'/'])
			execute a:cb_file
			mode
		endif
	endfor
endfunction
