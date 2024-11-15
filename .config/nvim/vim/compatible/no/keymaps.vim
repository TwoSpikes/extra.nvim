nnoremap <leader>sW <cmd>SWrap<cr>

nnoremap <c-w>n <cmd>execute v:count1."wincmd n"<cr>
nnoremap <c-w><c-n> <cmd>execute v:count1."wincmd n"<cr>

nnoremap ~ <cmd>call Do_N_Tilde()<cr><space>
xnoremap ~ <c-\><c-n><cmd>call Do_V_Tilde()<cr>
