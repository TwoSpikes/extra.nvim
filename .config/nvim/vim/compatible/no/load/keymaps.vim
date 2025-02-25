nnoremap <leader>sW <cmd>SWrap<cr>

nnoremap <silent> dd ddk
nnoremap ci_ yiwct_

nnoremap <c-w>n <cmd>execute v:count1."wincmd n"<cr>
nnoremap <c-w><c-n> <cmd>execute v:count1."wincmd n"<cr>

nnoremap ~ <cmd>call Do_N_Tilde()<cr><space>
xnoremap ~ <c-\><c-n><cmd>call Do_V_Tilde()<cr>

noremap <silent> <leader>d <cmd>nohlsearch<cr>

nnoremap <silent> <leader>ff <cmd>call FuzzyFind()<cr>
nnoremap <silent> <leader>fg :lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fb :lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fh :lua require('telescope.builtin').help_tags(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fr <cmd>lua require('telescope').extensions.recent_files.pick()<CR>
