nnoremap <leader>G <cmd>GenerateExNvimConfig<cr>

nnoremap <silent> dd ddk
nnoremap <silent> - dd
nnoremap <silent> + mz<cmd>let line=getline('.')<bar>call append(line('.'), line)<cr>`zj

noremap <silent> J mzJ`z
noremap <silent> gJ mzgJ`z

noremap <leader><c-f> <cmd>ToggleFullscreen<cr>
noremap <f3> <cmd>ToggleFullscreen<cr>

noremap <c-t> <cmd>TagbarToggle<cr>

nnoremap <leader>xg <cmd>grep <cword> .<cr>

noremap <c-a> 0
noremap <c-e> $
inoremap <c-a> <home>
inoremap <c-e> <end>

cnoremap <c-a> <c-b>
cnoremap <c-g> <c-e><c-u><cr>
if g:insert_exit_on_jk
	cnoremap jk <c-e><c-u><cr><cmd>echon ''<cr>
endif
cnoremap <c-u> <c-e><c-u>
cnoremap <c-b> <S-left>

nnoremap <c-j> viwUe<space><esc>
vnoremap <c-j> iwUe<space>
inoremap <c-j> <esc>viwUe<esc>a

nnoremap <bs> <cmd>let reg=v:register<bar>if reg==#"\""<bar>let reg="_"<bar>endif<bar>execute "normal! \"".reg."X"<cr>
noremap <leader><bs> <bs>

noremap <c-c>% <cmd>split<cr>
noremap <c-c>" <cmd>vsplit<cr>
noremap <c-c>w <cmd>quit<cr>
for i in range(1, 9)
	execute "noremap <c-c>".i." <cmd>tabnext ".i."<cr>"
endfor

nnoremap * *<cmd>noh<cr>
nnoremap <c-*> *
nnoremap # #:noh<cr>
nnoremap <c-#> #

noremap <leader>l 2zl2zl2zl2zl2zl2zl
noremap <leader>h 2zh2zh2zh2zh2zh2zh
if g:fast_terminal
	inoremap <c-l> <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>set lazyredraw<cr><cmd>normal! 10zl<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr><cmd>call HandleBuftype(winnr())<cr>
	inoremap <c-h> <cmd>let old_lazyredraw=&lazyredraw<cr><cmd>set lazyredraw<cr><cmd>normal! 10zh<cr><cmd>let &lazyredraw=old_lazyredraw<cr><cmd>unlet old_lazyredraw<cr><cmd>call HandleBuftype(winnr())<cr>
else
	inoremap <c-l> <cmd>exe"norm! 10zl"<cr>
	inoremap <c-h> <cmd>exe"norm! 10zh"<cr>
endif

let s:SCROLL_FACTOR = 2
let s:SCROLL_UP_FACTOR = s:SCROLL_FACTOR
let s:SCROLL_DOWN_FACTOR = s:SCROLL_FACTOR
let s:SCROLL_C_E_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_C_Y_FACTOR = s:SCROLL_DOWN_FACTOR
let s:SCROLL_MOUSE_UP_FACTOR = s:SCROLL_UP_FACTOR
let s:SCROLL_MOUSE_DOWN_FACTOR = s:SCROLL_DOWN_FACTOR
execute printf("noremap <silent> <expr> <c-y> \"%s<c-y>\"", s:SCROLL_C_Y_FACTOR)
let s:SCROLL_UPDATE_TIME = 1000
let g:exnvim_stc_timer = timer_start(s:SCROLL_UPDATE_TIME, {->STCUpd()}, {'repeat': -1})
execute printf("noremap <ScrollWheelDown> %s<c-e>", s:SCROLL_MOUSE_DOWN_FACTOR)
execute printf("noremap <ScrollWheelUp> %s<c-y>", s:SCROLL_MOUSE_UP_FACTOR)

if executable('rg')
	noremap <silent> <leader>st <cmd>lua require('spectre').toggle()<cr><cmd>call Numbertoggle()<cr>
	nnoremap <silent> <leader>sw <cmd>lua require('spectre').open_visual({select_word = true})<cr><cmd>call Numbertoggle()<cr>
	vnoremap <silent> <leader>sw <cmd>lua require('spectre').open_visual()<cr><cmd>call Numbertoggle()<cr>
	noremap <silent> <leader>sp <cmd>lua require('spectre').open_file_search({select_word = true})<cr><cmd>call Numbertoggle()<cr>
endif

execute printf('noremap <silent> <leader>ve <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:CONFIG_PATH."/init.vim")
execute printf("noremap <silent> <leader>se <esc>:so %s<cr>", g:CONFIG_PATH.'/vim/exnvim/reload.vim')

execute printf('noremap <silent> <leader>vi <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:PLUGINS_INSTALL_FILE_PATH)
execute printf("noremap <silent> <leader>si <esc>:so %s<cr>", g:PLUGINS_INSTALL_FILE_PATH)

execute printf('noremap <silent> <leader>vs <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:PLUGINS_SETUP_FILE_PATH)
execute printf("noremap <silent> <leader>ss <esc>:so %s<cr>", g:PLUGINS_SETUP_FILE_PATH)

execute printf('noremap <silent> <leader>vl <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:LSP_PLUGINS_SETUP_FILE_PATH)
execute printf("noremap <silent> <leader>sl <esc>:so %s<cr>", g:LSP_PLUGINS_SETUP_FILE_PATH)

execute printf('noremap <silent> <leader>vj <cmd>call SelectPosition("%s", g:stdpos)<cr>', g:EXNVIM_CONFIG_PATH)
execute printf('noremap <silent> <leader>sj <cmd>execute "source %s/vim/exnvim/reload_config.vim"<cr>', expand(g:CONFIG_PATH))

" .dotfiles-script.sh FILE
" See https://github.com/TwoSpikes/dotfiles.git
if filereadable(expand("~/.dotfiles-script.sh"))
	noremap <silent> <leader>vb <cmd>call SelectPosition("~/.dotfiles-script.sh", g:stdpos)<cr>
endif

" FAST COMMANDS
if g:open_cmd_on_up ==# "insert"
	nnoremap <up> :<up>
	xnoremap <up> mz<esc>`z:<up>
elseif g:open_cmd_on_up ==# "run"
	nnoremap <up> :<up><cr>
	xnoremap <up> mz<esc>`z:<up><cr>
else
	xnoremap <up> mz<esc>`z:
endif
noremap <leader>: :<c-u>'<,'>
noremap <leader>= :tabe 
noremap <leader>- :e 
noremap <leader>1 :!
nnoremap <leader>up <cmd>Pckr sync<cr>

" QUOTES AROUND (DEPRECATED BECAUSE OF surround.vim)
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>
vnoremap <leader>" iw<esc>a"<esc>bi"<esc>v
vnoremap <leader>' iw<esc>a'<esc>bi'<esc>v

" SPECIAL
nnoremap ci_ yiwct_
nnoremap <silent> <esc> <cmd>let @/ = ""<cr>
inoremap <c-c> <c-c><cmd>call Numbertoggle()<cr>

noremap <silent> <leader>. <cmd>call SelectPosition($SHELL, g:termpos)<cr>

" COLORSCHEME
noremap <silent> <leader>vc <cmd>call SelectPosition($VIMRUNTIME."/colors", g:dirpos)<cr>
noremap <silent> <leader>vC <cmd>set lazyredraw<cr>yy:<c-f>pvf]o0"_dxicolo <esc>$x$x$x$x<cr>jzb<cmd>set nolazyredraw<cr>

noremap <silent> <leader>uc <cmd>CocUpdate<cr>
noremap <silent> <leader>ut <cmd>TSUpdate<cr>

nnoremap <leader>c <cmd>call N_CommentOutDefault()<cr>
xnoremap <leader>c <c-\><c-n><cmd>call X_CommentOutDefault()<cr>
nnoremap <leader>C <cmd>call N_UncommentOutDefault()<cr>
xnoremap <leader>C <c-\><c-n><cmd>call X_UncommentOutDefault()<cr>

nnoremap <leader>A <cmd>call RunAlphaIfNotAlphaRunning()<cr>
xnoremap <leader>A <c-\><c-n><cmd>call RunAlphaIfNotAlphaRunning()<cr>

" vnoremap <c-/> <esc>v:q:s/.*/# \0
" vnoremap <c-?> <esc>:s/.*/\/\/ \0

" Tab closers
noremap <silent> q <cmd>quit<cr>
noremap <silent> Q <cmd>quit!<cr>
noremap <c-w><c-g> <cmd>echo "Quit"<cr>

" Emacs-like keymaps
noremap <silent> <c-x><c-c> <cmd>qall<cr>
noremap <silent> <c-x><c-q> <cmd>qall!<cr>
noremap <silent> <c-x>s <cmd>w<cr>
noremap <silent> <c-x>S <cmd>wall<Bar>echohl MsgArea<Bar>echo 'Saved all buffers'<cr>
noremap <silent> <c-x><c-s> <cmd>w<cr>
noremap <silent> <c-x>k <cmd>Killbuffer<cr>
noremap <silent> <c-x>0 <cmd>q<cr>
noremap <silent> <c-x>1 <cmd>only<cr>
noremap <silent> <c-x>2 <cmd>split<cr>
noremap <silent> <c-x>3 <cmd>vsplit<cr>
noremap <silent> <c-x>o <c-w>w
noremap <silent> <c-x>O <c-w>W
noremap <silent> <c-x>t0 <cmd>tabclose<cr>
noremap <silent> <c-x>t1 <cmd>tabonly<cr>
noremap <silent> <c-x>t2 <cmd>tabnew<cr>
noremap <silent> <c-x>to <cmd>tabnext<cr>
noremap <silent> <c-x>tO <cmd>tabprevious<cr>
noremap <silent> <c-x>5 <cmd>echo "Frames are only in Emacs/GNU Emacs"<cr>
noremap <m-x> :
noremap <silent> <c-x>h <cmd>call SelectAll()<cr>
noremap <silent> <c-x><c-h> <cmd>h<cr>
noremap <silent> <c-x><c-g> <cmd>echo "Quit"<cr>

noremap mz <cmd>echohl ErrorMsg<cr><cmd>echom "mz is used for commands"<cr><cmd>echohl Normal<cr>
noremap my <cmd>echohl ErrorMsg<cr><cmd>echom "my is used for commands"<cr><cmd>echohl Normal<cr>

noremap <leader>q q
noremap <leader>Q Q

if g:insert_exit_on_jk
	if g:insert_exit_on_jk_save
		inoremap <silent> jk <esc><cmd>update<cr>
		inoremap <silent> JK <esc><cmd>update<cr>
	else
		inoremap <silent> jk <esc>
		inoremap <silent> JK <esc>
	endif
	inoremap <silent> jK <esc>
	inoremap <silent> Jk <esc>
endif

inoremap <silent> ju <esc>viwUea
inoremap <silent> ji <esc>viwuea

inoremap <silent> ( <cmd>call HandleKeystroke('(')<bar>call Numbertoggle(v:insertmode)<cr>
inoremap <silent> [ <cmd>call HandleKeystroke('[')<bar>call Numbertoggle(v:insertmode)<cr>
inoremap <silent> { <cmd>call HandleKeystroke('{')<bar>call Numbertoggle(v:insertmode)<cr>
inoremap <expr> ) HandleKeystroke(')')
inoremap <expr> ] HandleKeystroke(']')
inoremap <expr> } HandleKeystroke('}')
inoremap <expr> ' HandleKeystroke("'")
inoremap <expr> " HandleKeystroke('"')
inoremap <expr> ` HandleKeystroke("`")
inoremap <expr> <bs> HandleKeystroke("\<bs>")

noremap <silent> <leader>so :let &scrolloff = 999 - &scrolloff<cr>

noremap <silent> <f10> <cmd>call RebindMenus()<bar>call quickui#menu#open()<cr>
noremap <silent> <s-f10> <cmd>call RebindMenus('extra')<bar>call quickui#menu#open()<cr>
noremap <silent> <f9> <cmd>call RebindMenus()<bar>call quickui#menu#open()<cr>
noremap <silent> <s-f9> <cmd>call RebindMenus('extra')<bar>call quickui#menu#open()<cr>

nnoremap <silent> <c-x><c-b> <cmd>call quickui#tools#list_buffer('e')<cr>

if executable('lazygit')
	noremap <leader>z <cmd>call SelectPosition('lazygit', g:termpos)<cr>
endif
if v:false
\|| executable('far')
\|| executable('far2l')
\|| executable('mc')
	noremap <leader>m <cmd>call SelectPosition(g:far_or_mc, g:termpos)<cr>
endif

noremap <leader>xx <cmd>call OpenTermProgram()<cr>

if has('nvim') && PluginInstalled('neo-tree')
	nnoremap <c-h> <cmd>Neotree<cr>
endif

nnoremap <leader>n <cmd>Neogen<cr>

nnoremap <c-w>o <cmd>silent only<cr>
nnoremap <c-w><c-o> <cmd>silent only<cr>
nnoremap <c-w>q <cmd>quit<cr>
nnoremap <c-w><c-q> <cmd>quit<cr>
nnoremap <c-w>f <cmd>wincmd f<cr>
nnoremap <c-w>F <cmd>wincmd F<cr>
nnoremap <c-w>gf <cmd>wincmd gf<cr>
nnoremap <c-w>gF <cmd>wincmd gF<cr>
nnoremap <c-w>gt <cmd>tabnext<cr>
nnoremap <c-w>gT <cmd>tabprevious<cr>
nnoremap <c-w>j <cmd>execute v:count1."wincmd j"<cr>
nnoremap <c-w><down> <cmd>execute v:count1."wincmd j"<cr>
nnoremap <c-w>k <cmd>execute v:count1."wincmd k"<cr>
nnoremap <c-w><up> <cmd>execute v:count1."wincmd k"<cr>
nnoremap <c-w>h <cmd>execute v:count1."wincmd h"<cr>
nnoremap <c-w><left> <cmd>execute v:count1."wincmd h"<cr>
nnoremap <c-w>l <cmd>execute v:count1."wincmd l"<cr>
nnoremap <c-w><right> <cmd>execute v:count1."wincmd l"<cr>
nnoremap <c-w>t <cmd>execute v:count1."wincmd t"<cr>
nnoremap <c-w>b <cmd>execute v:count1."wincmd b"<cr>
nnoremap <c-w>J <cmd>execute v:count1."wincmd J"<cr>
nnoremap <c-w>K <cmd>execute v:count1."wincmd K"<cr>
nnoremap <c-w>H <cmd>execute v:count1."wincmd H"<cr>
nnoremap <c-w>L <cmd>execute v:count1."wincmd L"<cr>
nnoremap <c-w>+ <cmd>execute v:count1."wincmd +"<cr>
nnoremap <c-w>- <cmd>execute v:count1."wincmd -"<cr>
nnoremap <c-w>< <cmd>execute v:count1."wincmd <"<cr>
nnoremap <c-w>> <cmd>execute v:count1."wincmd >"<cr>
nnoremap <c-w>= <cmd>wincmd ><cr>
nnoremap <c-w>P <cmd>wincmd P<cr>
nnoremap <c-w><c-p> <cmd>wincmd P<cr>
nnoremap <c-w>R <cmd>execute v:count1."wincmd R"<cr>
nnoremap <c-w><c-r> <cmd>execute v:count1."wincmd R"<cr>
nnoremap <c-w>s <cmd>execute v:count1."wincmd s"<cr>
nnoremap <c-w>S <cmd>execute v:count1."wincmd s"<cr>
nnoremap <c-w>T <cmd>wincmd T<cr>
nnoremap <c-w>w <cmd>execute v:count1."wincmd w"<cr>
nnoremap <c-w>x <cmd>execute v:count1."wincmd x"<cr>
nnoremap <c-w>W <cmd>execute v:count1."wincmd W"<cr>
nnoremap <c-w>] <cmd>wincmd ]<cr>
nnoremap <c-w>^ <cmd>execute v:count1."wincmd ^"<cr>
nnoremap <c-w><c-^> <cmd>execute v:count1."wincmd ^"<cr>
nnoremap <c-w>_ <cmd>execute v:count1."wincmd _"<cr>
nnoremap <c-w><c-_> <cmd>execute v:count1."wincmd _"<cr>
nnoremap <c-w>c <cmd>wincmd c<cr>
nnoremap <c-w>d <cmd>wincmd d<cr>
nnoremap <c-w>g<c-]> <cmd>execute "wincmd g\<c-]>"<cr>
nnoremap <c-w>g] <cmd>wincmd g]<cr>
nnoremap <c-w>g} <cmd>wincmd g}<cr>
nnoremap <c-w>g<tab> <cmd>execute "wincmd g\<tab>"<cr>
nnoremap <c-w>i <cmd>wincmd i<cr>
nnoremap <c-w>p <cmd>wincmd p<cr>
nnoremap <c-w>r <cmd>execute v:count1."wincmd r"<cr>
nnoremap <c-w>z <cmd>wincmd z<cr>
nnoremap <c-w>\| <cmd>execute v:count1."wincmd \|"<cr>

nnoremap <c-p> :<up>
vnoremap <c-p> :<up>

if has('nvim') && PluginExists('vim-fugitive')
	nnoremap <leader>gc <cmd>Git commit --verbose<cr>
	nnoremap <leader>ga <cmd>Git commit --verbose --all<cr>
	nnoremap <leader>gA <cmd>Git commit --verbose --amend<cr>
	nnoremap <leader>gp <cmd>Git pull<cr>
	nnoremap <leader>gP <cmd>Git push<cr>
	nnoremap <leader>gr <cmd>Git reset --soft<cr>
	nnoremap <leader>gh <cmd>Git reset --hard<cr>
	nnoremap <leader>gm <cmd>Git reset --mixed<cr>
	nnoremap <leader>gs <cmd>Git status<cr>
	nnoremap <leader>gi <cmd>Git init<cr>
	nnoremap <leader>gC <cmd>GitClone<cr>
	nnoremap <leader>g1 <cmd>GitClone --depth=1<cr>
	nnoremap <leader>gR <cmd>GitClone --recursive<cr>
	nnoremap <leader>g2 <cmd>GitClone --depth=1 --recursive<cr>
endif

if has('nvim') && PluginExists('ani-cli.nvim')
	noremap <leader>xa <cmd>execute "Ani ".g:ani_cli_options." -c"<cr>
	noremap <leader>xA <cmd>execute "Ani ".g:ani_cli_options<cr>
endif

noremap <leader>xi <cmd>call InvertPdf(expand("%"))<cr>

noremap <leader>xm <cmd>Telescope git_status<cr>

noremap <leader>xP <cmd>TogglePagerMode<cr>

noremap z00 <cmd>execute 'source' g:CONFIG_PATH.'/vim/exnvim/unload.vim'<cr>
