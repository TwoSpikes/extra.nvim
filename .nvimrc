#!/bin/env nvim

let mapleader = " "

colorscheme evening
set hidden
set nonu nornu
set wrap
set tabstop=4
set shiftwidth=4
set smartindent
set expandtab
let g:loaded_perl_provider = 0
set nolist

com! SWrap se wrap linebreak nolist

if v:version >= 700
  au BufLeave * let b:winview = winsaveview()
  au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif

noremap <silent> - dd
noremap <silent> dd ddk
noremap <silent> + mzyyp`zj
noremap <silent> J mzJ`z

noremap <silent> j gj
noremap <silent> k gk
noremap <silent> <down> gj
noremap <silent> <up> gk
noremap <silent> 0 g0
noremap <silent> $ g$
noremap <silent> I g0i
noremap <silent> A g$a

noremap <c-a> mzggVG`z

inoremap <c-d> <esc>ddi

nnoremap <c-u> viwUe<space><esc>
vnoremap <c-u> iwUe<space>
inoremap <c-u> <esc>viwUe<esc>a

noremap <c-p> :tabp<cr>
noremap <c-n> :tabn<cr>
nnoremap <leader>lC :tabnew<Bar>ter<Bar><cr>a./build.sh
nnoremap <leader>lc :tabnext<Bar><c-\><c-n>:bd!<Bar>tabnew<Bar>ter<cr>a!!<cr>

if !$disable_autowrapping
 noremap l <space>
 noremap h <bs>
 noremap <right> <space>
 noremap <left> <bs>
endif

nnoremap <silent> * *:noh<cr>
nnoremap <silent> <c-*> *
nnoremap <silent> # #:noh<cr>
nnoremap <silent> <c-#> #

noremap <C-l> 20zl
noremap <C-h> 20zh
inoremap <C-l> <esc>20zla
inoremap <C-h> <esc>20zha
noremap <C-e> 3<C-e>
noremap <C-y> 2<C-y>

" NVIMRC FILE
noremap <silent> <leader>vet <esc>:tabe ~/.nvimrc<cr>
noremap <silent> <leader>veb <esc>:e ~/.nvimrc<cr>
noremap <silent> <leader>veh <esc>:sp ~/.nvimrc<cr>
noremap <silent> <leader>vev <esc>:vsp ~/.nvimrc<cr>
noremap <silent> <leader>vs <esc>:so ~/.nvimrc<cr>

" BASHRC FILE
noremap <silent> <leader>bt <esc>:tabe ~/.bashrc<cr>
noremap <silent> <leader>bb <esc>:e ~/.bashrc<cr>
noremap <silent> <leader>bh <esc>:sp ~/.bashrc<cr>
noremap <silent> <leader>bv <esc>:vsp ~/.bashrc<cr>

" MY .nvimrc HELP
noremap <silent> <leader>? <esc>:echo "
  \MY .nvimrc HELP:
\\n  GLOBAL HELP:
\\n    \<leader\>? - Show this help message
\\n  NVIMRC FILE:
\\n    \<leader\>vet - Open in a new tab
\\n    \<leader\>veb - Open in a new buffer
\\n    \<leader\>veh - Open in a new horizontal window (-)
\\n    \<leader\>vev - Open in a new vertical window (\|)
\\n    \<leader\>vs  - Source it
\\n  BASHRC FILE:
\\n    \<leader\>bt - Open in a new tab
\\n    \<leader\>bb - Open in a new buffer
\\n    \<leader\>bh - Open in a new horizontal window (-)
\\n    \<leader\>bv - Open in a new vertical window (\|)
\\n  EDITING:
\\n    MOVING:
\\n      You can press `l`, `h`, `right` and `left` at the end of the line and it will go to the beginning of the next line (in Normal mode). To disable this feature, run this command in bash:
\\n      ╭──────────────────────────╮
\\n      │ $ disable_autowrapping=1 │
\\n      ╰──────────────────────────╯
\\n    FAST COMMANDS:
\\n      ; - Switch to command mode (:)
\\n      = - Open file in a new tab (:tabe)
\\n      _ - Open file in a new buffer (:e)
\\n      ! - Run environment command
\\n    QUOTES AROUND:
\\n      \<leader\>\" - Put \'\"\' around word
\\n      \<leader\>\' - Put \"\'\" around word
\\n    SPECIAL:
\\n      ci_ - Edit word from start to first _
\\n      \<leader\>d  - Remove search highlightings
\\n  TERMINAL:
\\n    \<leader\>tt - Open in a new tab
\\n    \<leader\>tb - Open in a new buffer
\\n    \<leader\>th - Open in a new horizontal window (-)
\\n    \<leader\>tv - Open in a new vertical window (\|)
\\n  COLORSCHEME:
\\n    \<leader\>cet - Open schemes in a new tab
\\n    \<leader\>ceb - Open schemes in a new buffer
\\n    \<leader\>ceh - Open schemes in a new horizontal window (-)
\\n    \<leader\>cev - Open schemes in a new vertical window (\|)
\\n    \<leader\>cs  - Set colorscheme (:colo)
\\n    \<leader\>cy  - Copy colorscheme name from current buffer and set it
\\n  TELESCOPE (Plugin):
\\n    \<leader\>ff - Find files
\\n    \<leader\>fg - Live grep
\\n    \<leader\>fb - Buffers
\\n    \<leader\>fh - Help tags
\\n  LSP:
\\n    \<leader\>slv - Start vim-language-server
\\n    \<leader\>slb - Start bash-language-server
\\n    \<leader\>sld - Dump active clients
\\n  SPECIAL:
\\n     By default, \<leader\> is space symbol. You can change it typing this command in Vim/Neovim:
\\n     ╭───────────────────────────╮
\\n     │ :let mapleader = \"symbol\" │
\\n     ╰───────────────────────────╯
\\n     Where symbol is your symbol (type quotes literally)
\\n  AUTHOR:
\\n    Name: TwoSpikes (2023 - 2023)
\\n    Github: https://github.com/TwoSpikes/dotfiles
\"<cr>

" FAST COMMANDS
noremap ; :
noremap <leader>= :tabe 
noremap <leader>- :e 
noremap <leader>1 :!

" QUOTES AROUND
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

" SPECIAL
nnoremap ci_ yiwct_
noremap <silent> <leader>d <esc>:noh<cr>
noremap <c-]> <c-\><esc>

" TERMINAL
noremap <silent> <leader>tt :tabnew<cr>:terminal<cr>i
noremap <silent> <leader>tb :terminal<cr>i
noremap <silent> <leader>th :split<cr> :terminal<cr>i
noremap <silent> <leader>tv :vsplit<cr>:terminal<cr>i
noremap <silent> <leader>tct <c-\><c-n>:q\|tabnew\|ter<cr>a

" COLORSCHEME
noremap <silent> <leader>cet :tabe $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>ceb :e $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>ceh :split $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>cev :vsplit $VIMRUNTIME/colors/<cr>
noremap <silent> <leader>cs :colo 
noremap <silent> <leader>cy yiw:colo <c-r>"<cr>j

augroup cpp
	au filetype cpp noremap <silent> <buffer> <leader>n viwo<esc>i::<esc>hi
	au filetype cpp noremap <silent> <buffer> <leader>/d mz0i//<esc>`zll
	au filetype cpp noremap <silent> <buffer> <leader>/u mz:s:^//<cr>`zhh:noh<cr>
    au filetype cpp noremap <silent> <buffer> <leader>! :e ~/.config/tsvimconf/cpp/example.cpp<cr>ggvGy:bd<cr>pgg
augroup END
augroup syn
	au BufEnter .oh-my-bash-bashrc set filetype=bash
augroup END
augroup vim
	au filetype vim noremap <silent> <buffer> <leader>/d mz0i"<esc>`zl
	au filetype vim noremap <silent> <buffer> <leader>/u mz:s/^"<cr>`zh:noh<cr>
augroup END
augroup googol
	au syntax googol noremap <silent> <buffer> <leader>/d mz0i//<esc>`zll
	au syntax googol noremap <silent> <buffer> <leader>/u mz:s:^//<cr>`zhh:noh<cr>
augroup END

" TELESCOPE
nnoremap <silent> <leader>ff :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fg :lua require'telescope.builtin'.live_grep(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fb :lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
nnoremap <silent> <leader>fh :lua require'telescope.builtin'.help_tags(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>

" vnoremap <c-/> <esc>v:q:s/.*/# \0
" vnoremap <c-?> <esc>:s/.*/\/\/ \0

" Tab closers
noremap <silent> q <esc>:q<cr>
noremap <silent> Q <esc>:q!<cr>
noremap <silent> <C-w> <esc>:wq<cr>
noremap <silent> <C-W> <C-W>

noremap <leader>q q
noremap <leader>Q Q

" Insert leavers
inoremap <silent> jk <esc>:w<cr>
inoremap <silent> jK <esc>
tnoremap <silent> jk <c-\><c-n>
tnoremap <silent> jK <c-\><c-n>:bd!<Bar>tabnew<Bar>ter<cr>a

let s:dein_base = '/data/data/com.termux/files/home/.local/share/dein'
let s:dein_src = '/data/data/com.termux/files/home/.local/share/dein/repos/github.com/Shougo/dein.vim'
execute 'set runtimepath+=' . s:dein_src
call dein#begin(s:dein_base)
call dein#add(s:dein_src)
call dein#add('wsdjeg/dein-ui.vim')
call dein#add('nvim-lua/plenary.nvim')
call dein#add('nvim-telescope/telescope.nvim', { 'rev': '0.1.1' })
call dein#add('nvim-treesitter/nvim-treesitter', { 'do': 'TSUpdate' })
call dein#add('williamboman/mason.nvim')
call dein#add('HampusHauffman/block.nvim')
" lua require('block').setup({})
call dein#end()
if dein#check_install()
	call dein#install()
endif

so ~/xterm-color-table.vim

call dein#add('williamboman/nvim-lsp-installer')
call dein#add('neovim/nvim-lspconfig')

if has('nvim')
	lua M = {}
	lua servers = { gopls = {}, html = {}, jsonls = {}, pyright = {}, rust_analyzer = {}, sumneko_lua = {}, tsserver = {}, vimls = {}, }
	lua on_attach = function(client, bufnr) vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc") vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()") require("config.lsp.keymaps").setup(client, bufnr) end
	lua opts = { on_attach = on_attach, flags = { debounce_text_changes = 150, }, }
	lua setup = function() require("config.lsp.installer").setup(servers, opts) end
endif

" " LSP
" noremap <silent> <leader>slv :lua vim.lsp.start({
" \   name = 'lspserv',
" \   cmd = {'vim-language-server'},
" \   root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'se" tup.py'}, { upward = true })[1]),
""  \})<cr>
" noremap <silent> <leader>slb :lua vim.lsp.start({
" \   name = 'lspserv',
" \   cmd = {'bash-language-server'},
" \   root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'se" tup.py'}, { upward = true })[1]),
" \})<cr>
" noremap <silent> <leader>sld :lua print(table_dump(vim.lsp.get_a" ctive_clients()))<cr>
"
" lua table_dump = function(table)
" \   if type(table) == 'table' then
" \      local s = '{ '
" \      for k,v in pairs(table) do
" \         if type(k) ~= 'number' then k = '"'..k..'"' end
" \         s = s .. '['..k..'] = ' .. table_dump(v) .. ','
" \      end
" \      return s .. '} '
" \   else
" \      return tostring(table)
" \   end
" \ end

noremap <leader>s :let &scrolloff = 999 - &scrolloff<cr>

function! SwapHiGroup(group)
    let id = synIDtrans(hlID(a:group))
    for mode in ['cterm', 'gui']
        for g in ['fg', 'bg']
            exe 'let '. mode.g. "=  synIDattr(id, '".
                        \ g."#', '". mode. "')"
            exe "let ". mode.g. " = empty(". mode.g. ") ? 'NONE' : ". mode.g
        endfor
    endfor
    exe printf('hi %s ctermfg=%s ctermbg=%s guifg=%s guibg=%s', a:group, ctermbg, ctermfg, guibg, guifg)
endfunc

echom 'config: loaded'

" vim:syn=vim
