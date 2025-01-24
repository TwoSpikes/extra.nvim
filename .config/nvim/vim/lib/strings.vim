" Copied from StackOverflow: https://stackoverflow.com/questions/4478891/is-there-a-vimscript-equivalent-for-rubys-strip-strip-leading-and-trailing-s
function! Trim(string)
	return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" Copied from StackOverflow: https://vi.stackexchange.com/questions/29062/how-to-check-if-a-string-starts-with-another-string-in-vimscript
fu! StartsWith(longer, shorter) abort
  return a:longer[0:len(a:shorter)-1] ==# a:shorter
endfunction
fu! EndsWith(longer, shorter) abort
  return a:longer[len(a:longer)-len(a:shorter):] ==# a:shorter
endfunction
fu! Contains(longer, shorter) abort
  return stridx(a:longer, a:shorter) >= 0
endfunction

" Copied from StackOverflow: https://stackoverflow.com/questions/4964772/string-formatting-padding-in-vim
function! Pad(s, amt)
    return a:s . repeat(' ', a:amt - len(a:s))
endfunction
function! PrePad(s, amt, ...)
    if a:0 ># 0
        let char = a:1
    else
        let char = ' '
    endif
    return repeat(char, a:amt - len(a:s)) . a:s
endfunction

function! Repr_Vim_Grep(string)
	let result = ''
	let state = 'norm'
	for char in a:string
		if state ==# 'norm'
			if char ==# '\'
				let state = 'backslash'
			elseif char ==# '$'
				let result .= '\$'
			elseif char ==# '^'
				let result .= '\^'
			else
				let result .= char
			endif
		elseif state ==# 'backslash'
			if char ==# '\'
				let result .= '\\\\'
			elseif v:false
			\|| char ==# 'n'
			\|| char ==# 't'
				let result .= '\\'.char
			else
				let result .= '\\'.char
			endif
			let state = 'norm'
		else
			echohl ErrorMsg
			echomsg "extra.nvim: Repr_Vim_Grep: Internal Error: Invalid state: ".state
			echohl Normal
		endif
	endfor
	if state ==# 'backslash'
		let result .= '\\'
	endif
	return result
endfunction

function! Repr_Vim_Grep_Sub(string)
	let result = ''
	for char in a:string
		if char ==# '\'
			let result .= '\\'
		elseif char ==# '&'
			let result .= '\&'
		else
			let result .= char
		endif
	endfor
	return result
endfunction

function! Repr_Shell(string, transform_newlines=v:true)
	let result = ''
	let state = 'norm'
	for char in a:string
		if state ==# 'norm'
			if char ==# '\'
				let state = 'backslash'
			elseif char ==# ' '
				let result .= '\ '
			elseif char ==# '('
				let result .= '\('
			elseif char ==# ')'
				let result .= '\)'
			elseif char ==# '*'
				let result .= '\*'
			elseif char ==# '#'
				let result .= '\#'
			elseif char ==# '?'
				let result .= '\?'
			elseif char ==# '['
				let result .= '\['
			elseif char ==# ']'
				let result .= '\]'
			elseif char ==# '{'
				let result .= '\{'
			elseif char ==# '}'
				let result .= '\}'
			elseif char ==# '$'
				let result .= '\$'
			elseif char ==# '^'
				let result .= '\^'
			elseif char ==# '&'
				let result .= '\&'
			elseif char ==# '!'
				let result .= '\!'
			elseif char ==# '~'
				let result .= '\~'
			elseif char ==# ''''
				let result .= '\'''
			elseif char ==# '"'
				let result .= '\"'
			elseif char ==# '`'
				let result .= '\`'
			elseif char ==# '<'
				let result .= '\<'
			elseif char ==# '>'
				let result .= '\>'
			elseif char ==# '|'
				let result .= '\|'
			elseif char ==# ';'
				let result .= '\;'
			elseif char ==# "\n" && a:transform_newlines
				let result .= '\\n'
			else
				let result .= char
			endif
		elseif state ==# 'backslash'
			if char ==# '\'
				let result .= '\\\\'
			elseif v:false
			\|| char ==# 'n'
			\|| char ==# 't'
				let result .= '\\'.char
			else
				let result .= '\'.char
			endif
			let state = 'norm'
		else
			echohl ErrorMsg
			echomsg "extra.nvim: Repr_Shell: Internal Error: Invalid state: ".state
			echohl Normal
		endif
	endfor
	if state ==# 'backslash'
		let result .= '\\'
	endif
	return result
endfunction
