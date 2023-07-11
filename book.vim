if exists("b:current_syntax")
    finish
endif

syn clear
let g:markdown_minlines = 1

syn match bookOperator "[.\^\-+\*=«»…]"
syn match bookSpecialChar "[\[\]()\.,:;{}!?–—]"
syn match bookOperator "^ *[—–-]"

hi def link bookOperator Operator
hi def link bookSpecialChar Special

let b:current_syntax = "book"
" vim:ts=4
