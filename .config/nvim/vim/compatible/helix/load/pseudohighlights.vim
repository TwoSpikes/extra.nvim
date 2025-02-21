function! AddPseudoSelection(x1=getpos("'<")[1], y1=getpos("'<")[2], x2=getpos("'>")[1], y2=getpos("'>")[2], ns_name='hcm_main_pseudo_highlight', hlgroup='PseudoVisual')
	echomsg "a:x1:".a:x1
	echomsg "a:x2:".a:x2
	echomsg "a:y1:".a:y1
	echomsg "a:y2:".a:y2
	let ns_id = nvim_create_namespace(a:ns_name)
	let bufnr = bufnr()
	let i = a:x1
	while i <=# a:x2
		if i ==# a:x1
			let start = a:y1-1
		else
			let start = 0
		endif
		if i ==# a:x2
			let end = a:y2
		else
			let end = len(getline(i))
		endif
		call nvim_buf_add_highlight(bufnr, ns_id, a:hlgroup, i-1, start, end)
		let i += 1
	endwhile
	unlet i
	let s:hcm_main_pseudo_highlight = {}
	let s:hcm_main_pseudo_highlight['bufnr'] = bufnr
	unlet bufnr
	let s:hcm_main_pseudo_highlight['pos'] = [a:x1, a:y1, a:x2, a:y2]
endfunction

function! GoToPseudoSelection(pseudo_selection)
	let pos = s:hcm_main_pseudo_highlight['pos']
	let id = nvim_create_namespace('hcm_main_pseudo_highlight')
	call nvim_buf_clear_namespace(bufnr(), id, pos[0]-1, pos[2])
	unlet id
	call cursor(pos[0], pos[1])
	normal! v
	call cursor(pos[2], pos[3])
endfunction

function! V_Do_Colon(mode)
	if a:mode =~? '^v' || a:mode =~# "^\<c-v>"
		call AddPseudoSelection()
	endif
endfunction

augroup hcm_go_to_main_pseudo_highlight
	autocmd!
	autocmd ModeChanged c:* if exists('s:hcm_main_pseudo_highlight')|call GoToPseudoSelection(s:hcm_main_pseudo_highlight)|endif
augroup END
