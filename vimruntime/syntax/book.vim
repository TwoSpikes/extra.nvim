if exists("b:current_syntax")
    finish
endif

syn clear
let g:markdown_minlines = 1

setlocal tabstop=2
setlocal shiftwidth=2
setlocal wrap
setlocal linebreak
setlocal nolist

syn match bookOperator "[\^\-+\*=«»"]"
"syn match bookSpecialChar "[\[\]()\\.,:;{}!?–—]"
syn match bookOperator "^ *[—–\-]"
syn match bookLink "https\?://[a-zA-Z\./\-_]\+"
syn match bookYear "\(1[0-9]\{3}\) г\."
syn match bookHeader "^[A-ZА-Я][A-Za-zА-Яа-я 0-9\.,]*[^\.]$" contains=bookYear,bookLink,bookOperator,bookSpecialChar
syn match bookBigNumberline "[IVXLCDM]\+\. [A-Za-zА-Яа-я \.,:]\+$"
syn match bookSmallNumberline "\([1-9][0-9]*\.\)\+ [A-Za-zА-Яа-я .,:]\+$"
syn match bookDotDotDot "[…]\|\(\.\{3}\)"
syn match bookComment "//.*$" contains=bookOperator,bookSpecialChar,bookDotDotDot
syn match bookYear "\%\(\%\(1[0-9][0-9][0-9]\)\|\%\(20[0-9][0-9]\)\) году\>"
syn match bookYear "\%\(\%\(1[0-9][0-9][0-9]\)\|\%\(20[0-9][0-9]\)\) года\>"
syn match bookYear "\%\(\%\(1[0-9][0-9][0-9]\)\|\%\(20[0-9][0-9]\)\) г\.\>"
syn match bookYear "\%\(\%\(1[0-9][0-9][0-9]\)\|\%\(20[0-9][0-9]\)\) год\>"
syn match bookYear "\<один год\>"
syn match bookYear "\<одного года\>"
syn match bookYear "\<одним годом\>"
syn match bookYear "\<два года\>"
syn match bookYear "\<двумя годами\>"
syn match bookYear "\<двух лет\>"
syn match bookYear "\<три года\>"

hi def link bookOperator Operator
hi def link bookSpecialChar Special
hi def link bookHeader Operator
hi bookBigNumberline ctermfg=75 ctermbg=NONE cterm=bold guifg=#5fafff guibg=NONE gui=bold
hi bookSmallNumberline ctermfg=63 ctermbg=NONE cterm=bold guifg=#8f8fff guibg=NONE gui=bold
hi def link bookComment Comment
hi bookLink ctermfg=191 ctermbg=NONE cterm=underline guifg=#dfff5f guibg=NONE gui=underline
hi bookDotDotDot ctermfg=241 ctermbg=NONE cterm=bold,italic guifg=LightGray gui=bold
hi def link bookYear Constant

let b:current_syntax = "book"
" vim:ts=4:nowrap
