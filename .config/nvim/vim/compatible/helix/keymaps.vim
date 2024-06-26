if isdirectory(expand(g:LOCALSHAREPATH)."/site/pack/packer/start/cinnamon.nvim")
	nnoremap gh <cmd>lua Scroll('0')<cr>
	xnoremap gh <cmd>lua Scroll('0')<cr>
	nnoremap gl <cmd>lua Scroll('$', 0, 1)<cr>
	xnoremap gl <cmd>lua Scroll('$', 0, 1)<cr>h
	nnoremap ge <cmd>lua Scroll('G', 0, 1)<cr>
	xnoremap ge <cmd>lua Scroll('G', 0, 1)<cr>
	nnoremap gs <cmd>lua Scroll('^')<cr>
	xnoremap gs <cmd>lua Scroll('^')<cr>
else
	nnoremap gh 0
	nnoremap gl $
	nnoremap ge G
	nnoremap gs ^
endif

set notildeop
let &whichwrap="b,s,h,l,<,>,~,[,]"

nnoremap d x
nnoremap x V
nnoremap c xi
unmap ySS
unmap ySs
unmap yss
unmap yS
unmap ys
unmap y<c-g>
nnoremap y vy
nnoremap t<cr> v$
nnoremap mm %
nnoremap <c-c> <cmd>call CommentOutDefault<cr>
inoremap <c-x> <c-p>
inoremap <c-p> <c-x>
nnoremap <a-o> viw
nnoremap <a-.> ;
vnoremap R "_dP
nnoremap ~ v~
nnoremap > >>
nnoremap < <<
unmap <c-a>
unmap <c-x><c-b>
unmap <c-x><c-g>
unmap <c-x><c-h>
unmap <c-x>h
unmap <c-x>5
unmap <c-x>t0
unmap <c-x>tO
unmap <c-x>to
unmap <c-x>t2
unmap <c-x>t1
unmap <c-x><c-f>
unmap <c-x>O
unmap <c-x>o
unmap <c-x>3
unmap <c-x>2
unmap <c-x>1
unmap <c-x>0
unmap <c-x>k
unmap <c-x><c-s>
unmap <c-x>S
unmap <c-x>s
unmap <c-x><c-q>
unmap <c-x><c-c>
vnoremap t<cr> $
unmap cS
unmap cs
unmap ci_
unmap ds
unmap dd
let g:pseudo_visual_idk = v:false
function! YesItIsV()
	if g:pseudo_visual_idk
		let g:pseudo_visual_idk = v:false
		let g:pseudo_visual = v:false
	endif
endfunction
function! NoItIsNotV()
	if g:pseudo_visual_idk
		let g:pseudo_visual_idk = v:false
		let g:pseudo_visual = v:true
	endif
endfunction
nnoremap w <cmd>exec "normal! v".v:count1."e"<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual_idk=v:false<cr>
nnoremap e <cmd>exec "normal! v".v:count1."e"<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual_idk=v:false<cr>
nnoremap b <cmd>exec "normal! v".v:count1."b"<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual_idk=v:false<cr>
nnoremap W <cmd>exec "normal! v".v:count1."W"<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual_idk=v:false<cr>
nnoremap E <cmd>exec "normal! v".v:count1."E"<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual_idk=v:false<cr>
nnoremap B <cmd>exec "normal! v".v:count1."B"<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:pseudo_visual_idk=v:false<cr>
nnoremap v v<cmd>let g:pseudo_visual_idk=v:true<cr>
vnoremap x j
vnoremap X j
function! V_DoH()
	call YesItIsV()
	if g:pseudo_visual
		exec "normal! \<esc>h"
	else
		exec "normal! h"
	endif
endfunction
vnoremap h <cmd>call V_DoH()<cr>
vnoremap <left> <cmd>call V_DoH()<cr>
function! V_DoL()
	call YesItIsV()
	if g:pseudo_visual
		exec "normal! \<esc>l"
	else
		exec "normal! l"
	endif
endfunction
vnoremap l <cmd>call V_DoL()<cr>
vnoremap <right> <cmd>call V_DoL()<cr>
function! V_DoW()
	call NoItIsNotV()
	if g:pseudo_visual
		exec "normal! \<esc>wviw"
	else
		normal! w
	endif
endfunction
vnoremap w <cmd>call V_DoW()<cr>
function! V_DoWWhole()
	call NoItIsNotV()
	if g:pseudo_visual
		exec "normal! \<esc>wviW"
	else
		normal! W
	endif
endfunction
vnoremap W <cmd>call V_DoWWhole()<cr>
function! V_DoE()
	call NoItIsNotV()
	if g:pseudo_visual
		exec "normal! \<esc>wviw"
	else
		normal! e
	endif
endfunction
vnoremap e <cmd>call V_DoE()<cr>
function! V_DoEWhole()
	call NoItIsNotV()
	if g:pseudo_visual
		exec "normal! \<esc>wviW"
	else
		normal! E
	endif
endfunction
vnoremap E <cmd>call V_DoEWhole()<cr>
function! V_DoB()
	call NoItIsNotV()
	if g:pseudo_visual
		exec "normal! \<esc>vb"
	else
		exec "normal! b"
	endif
endfunction
vnoremap b <cmd>call V_DoB()<cr>
function! V_DoBWhole()
	call NoItIsNotV()
	if g:pseudo_visual
		exec "normal! \<esc>vB"
	else
		exec "normal! B"
	endif
endfunction
vnoremap B <cmd>call V_DoBWhole()<cr>
unmap ;
nnoremap ; <nop>
vnoremap ; <esc>
vnoremap o <esc>o
vnoremap O <esc>O
nnoremap C <c-v>j
vnoremap C j
nnoremap , <nop>
vnoremap , <esc>
nnoremap <c-s> m'
nnoremap U <c-r>
vnoremap y ygv

unmap <leader>f
unmap <leader>fr
unmap <leader>fh
unmap <leader>fb
unmap <leader>fg
unmap <leader>ff
nnoremap <leader>f <cmd>call FuzzyFind()<cr>
nnoremap <leader>F <cmd>call FuzzyFind()<cr>
unmap <leader>b
nnoremap <leader>b <cmd>call quickui#tools#list_buffer('e')<cr>
nnoremap <leader>j <cmd>jumps<cr>
nnoremap <leader>s <cmd>TagbarToggle<cr>
nnoremap <leader>S <cmd>TagbarToggle<cr>
nnoremap <leader>d <cmd>Trouble diagnostics toggle filter.buf=0<cr>
nnoremap <leader>D <cmd>Trouble diagnostics toggle<cr>
nnoremap <leader>ww <c-w>w
nnoremap <leader>w<c-w> <c-w>w
nnoremap <leader>ws <cmd>split<cr>
nnoremap <leader>w<c-s> <cmd>split<cr>
nnoremap <leader>wv <cmd>vsplit<cr>
nnoremap <leader>w<c-v> <cmd>vsplit<cr>
nnoremap <leader>wt <c-w>J
nnoremap <leader>w<c-t> <c-w>J
nnoremap <leader>wf <cmd>split <cfile><cr>
nnoremap <leader>wF <cmd>vsplit <cfile><cr>
nnoremap <leader>wq <cmd>quit<cr>
nnoremap <leader>w<c-q> <cmd>quit<cr>
nnoremap <leader>wo <cmd>only<cr>
nnoremap <leader>w<c-o> <cmd>only<cr>
nnoremap <leader>wh <c-w>h
nnoremap <leader>w<c-h> <c-w>h
nnoremap <leader>wj <c-w>j
nnoremap <leader>w<c-j> <c-w>j
nnoremap <leader>wk <c-w>k
nnoremap <leader>w<c-k> <c-w>k
nnoremap <leader>wl <c-w>l
nnoremap <leader>w<c-l> <c-w>l
nnoremap <leader>w<left> <c-w>h
nnoremap <leader>w<down> <c-w>j
nnoremap <leader>w<up> <c-w>k
nnoremap <leader>w<right> <c-w>l
nnoremap <leader>wH <c-w>H
nnoremap <leader>wJ <c-w>J
nnoremap <leader>wK <c-w>K
nnoremap <leader>wL <c-w>L
nnoremap <leader>y <cmd>echohl ErrorMsg<cr><cmd>echom "No selection"<cr><cmd>echohl Normal<cr>
nnoremap <leader>Y <cmd>echohl ErrorMsg<cr><cmd>echom "No selection"<cr><cmd>echohl Normal<cr>
vnoremap <leader>y y
vnoremap <leader>Y y
nnoremap <leader>R <cmd>for i in range(line("'>")-line("'<"))<bar>let l=line("'<")+i<bar>call setline(l,substitute(getline(l),getreg('x')))<bar>endfor<cr>
nnoremap <leader>k K
nnoremap <leader>r <Plug>(coc-rename)
nnoremap <expr> <leader>c <cmd>CommentOutDefault()<cr>
nnoremap <expr> <leader>C <cmd>CommentOutDefault()<cr>
nnoremap <leader>? <cmd>Telescope commands<cr>
