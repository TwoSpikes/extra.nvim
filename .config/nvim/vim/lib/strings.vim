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
  return stridx(a:longer, a:short) >= 0
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
