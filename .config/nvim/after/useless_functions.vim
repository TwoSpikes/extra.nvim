function! Update_Cursor_Style_wrapper()
	if exists('g:updating_cursor_style_supported')
		call Update_Cursor_Style()
	else
		execute "colorscheme" g:colors_name
	endif
endfunction
function! OnQuitDisable()
	let &guicursor = g:old_guicursor
	unlet g:old_guicursor
endfunction
let s:MACRO_IS_ONE_WIN = "
\	let s = 0
\\n	let t = 1
\\n	while s <=# 1 && t <=# tabpagenr()
\\n		let s += tabpagewinnr(t, '$')
\\n		let t += 1
\\n	endwhile"
execute "
\function! IfOneWinDo(cmd)
\\n".s:MACRO_IS_ONE_WIN."
\\n	if s ==# 1
\\n		execute a:cmd
\\n	endif
\\nendfunction"
