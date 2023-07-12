if exists("b:current_syntax")
    finish
endif

syn clear
let g:markdown_minlines = 1

syn match bookOperator "[\^\-+\*=«»"]"
syn match bookSpecialChar "[\[\]()\\.,:;{}!?–—]"
syn match bookOperator "^ *[—–\-]"
syn match bookHeader "^[A-ZА-Я].*$"
syn match bookDotDotDot "[…]\|\(\.\{3}\)"

hi def link bookOperator Operator
hi def link bookSpecialChar Special
hi def link bookHeader SpecialChar
hi bookDotDotDot ctermfg=241 ctermbg=NONE cterm=bold,italic guifg=LightGray gui=bold

let b:current_syntax = "book"
" vim:ts=4
