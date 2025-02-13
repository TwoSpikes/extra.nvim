function! IsHighlightGroupDefined(group)
	silent! let output = execute('hi '.a:group)
	return output !~# 'E411:' && output !~# 'cleared'
endfunction
function! ReturnHighlightTerm(group, term)
   " Store output of group to variable
   let output = execute('hi ' . a:group)

   " Find the term we're looking for
   return matchstr(output, a:term.'=\zs\S*')
endfunction
function! CopyHighlightGroup(src, dst)
	let ctermfg = ReturnHighlightTerm(a:src, "ctermfg")
	if ctermfg ==# ""
		let ctermfg = "NONE"
	endif
	let ctermbg = ReturnHighlightTerm(a:src, "ctermbg")
	if ctermbg ==# ""
		let ctermbg = "NONE"
	endif
	let cterm = ReturnHighlightTerm(a:src, "cterm")
	if cterm ==# ""
		let cterm = "NONE"
	endif
	let guifg = ReturnHighlightTerm(a:src, "guifg")
	if guifg ==# ""
		let guifg = "NONE"
	endif
	let guibg = ReturnHighlightTerm(a:src, "guibg")
	if guibg ==# ""
		let guibg = "NONE"
	endif
	let gui = ReturnHighlightTerm(a:src, "gui")
	if gui ==# ""
		let gui = "NONE"
	endif
	execute printf("hi %s ctermfg=%s", a:dst, ctermfg)
	execute printf("hi %s ctermbg=%s", a:dst, ctermbg)
	execute printf("hi %s cterm=%s", a:dst, cterm)
	execute printf("hi %s guifg=%s", a:dst, guifg)
	execute printf("hi %s guibg=%s", a:dst, guibg)
	if has('nvim') || has('gui_running')
		execute printf("hi %s gui=%s", a:dst, gui)
	endif
endfunction

augroup ExNvim_ColorScheme_After
	autocmd!
	autocmd ColorScheme * 
	\	if expand('<amatch>') !=# "exnvim_base"
	\|		runtime colors/exnvim_base.vim
	\|	endif
	\|	if !IsHighlightGroupDefined('StatementNorm')
	\|		call CopyHighlightGroup('Statement', 'StatementNorm')
	\|	endif
	\|	if !IsHighlightGroupDefined('StatementIns')
	\|		call CopyHighlightGroup('Statement', 'StatementIns')
	\|	endif
	\|	if !IsHighlightGroupDefined('StatementVisu')
	\|		call CopyHighlightGroup('Statement', 'StatementVisu')
	\|	endif
	\|	if !IsHighlightGroupDefined('LineNrNorm')
	\|		call CopyHighlightGroup('LineNr', 'LineNrNorm')
	\|	endif
	\|	if !IsHighlightGroupDefined('LineNrVisu')
	\|		call CopyHighlightGroup('LineNr', 'LineNrVisu')
	\|	endif
	\|	if !IsHighlightGroupDefined('LineNrIns')
	\|		call CopyHighlightGroup('LineNr', 'LineNrIns')
	\|	endif
	\|	if !IsHighlightGroupDefined('CursorLineNrNorm')
	\|		call CopyHighlightGroup('CursorLineNr', 'CursorLineNrNorm')
	\|	endif
	\|	if !IsHighlightGroupDefined('CursorLineNrIns')
	\|		call CopyHighlightGroup('Cursor', 'CursorLineNrIns')
	\|	endif
	\|	if !IsHighlightGroupDefined('CursorLineNrRepl')
	\|		call CopyHighlightGroup('Cursor', 'CursorLineNrRepl')
	\|	endif
	\|	if !IsHighlightGroupDefined('ModeIns')
	\|		call CopyHighlightGroup('Cursor', 'ModeIns')
	\|	endif
	\|	if !IsHighlightGroupDefined('ModeNorm')
	\|		call CopyHighlightGroup('CursorLineNr', 'ModeNorm')
	\|	endif
	\|	if !IsHighlightGroupDefined('ModeVisu')
	\|		call CopyHighlightGroup('Visual', 'ModeVisu')
	\|	endif
	\|	if !IsHighlightGroupDefined('ModeRepl')
	\|		call CopyHighlightGroup('CursorLineNrRepl', 'ModeRepl')
	\|	endif
	\|	if !IsHighlightGroupDefined('CursorLineNrVisu')
	\|		call CopyHighlightGroup('Visual', 'CursorLineNrVisu')
	\|	endif
	\|	if !IsHighlightGroupDefined('ModeCom')
	\|		call CopyHighlightGroup('Question', 'ModeCom')
	\|	endif
augroup END
