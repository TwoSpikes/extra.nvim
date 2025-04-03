function! V_Do_Colon(mode)
	if a:mode =~? '^v' || a:mode =~# "^\<c-v>"
		call AddPseudoSelection()
	endif
endfunction
