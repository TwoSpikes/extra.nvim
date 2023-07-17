if exists("b:current_syntax")
    finish
endif

syn clear
let g:markdown_minlines = 1

set tabstop=2
set shiftwidth=2
set wrap
set linebreak
set nolist

syn match bookOperator "[\^\-+\*=«»"]"
syn match bookSpecialChar "[\[\]()\\.,:;{}!?–—]"
syn match bookOperator "^ *[—–\-]"
syn match bookHeader "^[A-ZА-Я].*$"
syn match bookDotDotDot "[…]\|\(\.\{3}\)"
syn region bookComment start='//' end='//$' contains=bookOperator,bookSpecialChar,bookDotDotDot

hi def link bookOperator Operator
hi def link bookSpecialChar Special
hi def link bookHeader Operator
hi def link bookComment Comment
hi bookDotDotDot ctermfg=241 ctermbg=NONE cterm=bold,italic guifg=LightGray gui=bold

let b:current_syntax = "book"
" vim:ts=4
