function! SwapHiGroup(group)
    let id = synIDtrans(hlID(a:group))
    for mode in ['cterm', 'gui']
        for g in ['fg', 'bg']
            execute 'let '. mode.g. "=  synIDattr(id, '".
                        \ g."#', '". mode. "')"
            execute "let ". mode.g. " = empty(". mode.g. ") ? 'NONE' : ". mode.g
        endfor
    endfor
    execute printf('hi %s ctermfg=%s ctermbg=%s guifg=%s guibg=%s', a:group, ctermbg, ctermfg, guibg, guifg)
endfunction
