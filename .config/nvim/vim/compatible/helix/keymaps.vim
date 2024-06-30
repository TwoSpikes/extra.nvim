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

function! ExitVisual()
	if v:false
	elseif g:visual_mode ==# "char"
		normal! v
	elseif g:visual_mode ==# "line"
		normal! V
	elseif g:visual_mode ==# "block"
		normal! <c-v>
	else
		echomsg "dotfiles: hcm: ExitVisual: Internal error: Wrong visual mode: ".g:visual_mode
	endif
endfunction

set notildeop
let &whichwrap="b,s,h,l,<,>,~,[,]"

nnoremap d x
nnoremap x V<cmd>let g:pseudo_visual=v:true<bar>let g:visual_mode="line"<cr>
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
vnoremap mm %
nnoremap <c-c> <cmd>call CommentOutDefault<cr>
inoremap <c-x> <c-p>
inoremap <c-p> <c-x>
nnoremap <a-o> viw
nnoremap <a-.> ;
vnoremap R "_dP
nnoremap ~ v~
nnoremap > >>
nnoremap < <<
vnoremap < <gv<cmd>let g:pseudo_visual=v:true<cr>
vnoremap > >gv<cmd>let g:pseudo_visual=v:true<cr>
unmap <c-a>
vnoremap t<cr> $
unmap cS
unmap cs
unmap ci_
unmap ds
unmap dd
let g:pseudo_visual = v:false
let g:lx=1
let g:ly=1
let g:rx=1
let g:ry=1
let g:visual_mode = "no"
function! ReorderRightLeft()
	if g:lx>#g:rx||(g:lx==#g:rx&&g:ly>g:ry)
		let g:lx=xor(g:lx,g:rx)
		let g:rx=xor(g:lx,g:rx)
		let g:lx=xor(g:lx,g:rx)
		let g:ly=xor(g:ly,g:ry)
		let g:ry=xor(g:ly,g:ry)
		let g:ly=xor(g:ly,g:ry)
	endif
endfunction
function! SavePosition()
	let c=col('.')
	let l=line('.')
	if c==#g:ly&&l==#g:lx
		let g:lx=l
		let g:ly=c
	else
		let g:rx=l
		let g:ry=c
	endif
endfunction
vnoremap <expr> : g:pseudo_visual?":\<c-u>":":"
nnoremap w <cmd>exec "normal! v".v:count1."e"<cr><cmd>let g:pseudo_visual = v:true<cr>
nnoremap e <cmd>exec "normal! v".v:count1."e"<cr><cmd>let g:pseudo_visual = v:true<cr>
nnoremap b <cmd>exec "normal! v".v:count1."b"<cr><cmd>let g:pseudo_visual = v:true<cr>
nnoremap W <cmd>exec "normal! v".v:count1."W"<cr><cmd>let g:pseudo_visual = v:true<cr>
nnoremap E <cmd>exec "normal! v".v:count1."E"<cr><cmd>let g:pseudo_visual = v:true<cr>
nnoremap B <cmd>exec "normal! v".v:count1."B"<cr><cmd>let g:pseudo_visual = v:true<cr>
unmap <esc>
nnoremap v v<cmd>let g:pseudo_visual=v:false<cr><cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>let g:lx=rx<bar>let g:ly=ry<cr><cmd>let g:visual_mode="char"<cr>
nnoremap V V<cmd>let g:pseudo_visual=v:false<cr><cmd>let g:rx=line('.')<bar>let g:ry=col('$')<bar>let g:lx=rx<bar>let g:ly=1<cr><cmd>let g:visual_mode="line"<cr>
nnoremap <c-v> <c-v><cmd>let g:pseudo_visual=v:false<cr><cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>let g:lx=rx<bar>let g:ly=ry<cr><cmd>let g:visual_mode="block"<cr>
function! V_DoV()
	if v:false
	elseif g:visual_mode ==# "no"
		echohl ErrorMsg
		echomsg "dotfiles: hcm: V_DoV: Internal error: It is not visual mode"
		echohl Normal
	elseif v:false
	\|| g:visual_mode ==# "char"
	\|| g:visual_mode ==# "line"
	\|| g:visual_mode ==# "block"
		let g:pseudo_visual = !g:pseudo_visual
		Showtab
		return ""
	else
		echohl ErrorMsg
		echomsg "dotfiles: hcm: V_DoV: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
vnoremap <expr> v V_DoV()
function! V_DoVLine()
	if v:false
	elseif g:visual_mode ==# "no"
		echohl ErrorMsg
		echomsg "dotfiles: hcm: V_DoVLine: Internal error: It is not visual mode"
		echohl Normal
	elseif v:false
	\|| g:visual_mode ==# "char"
	\|| g:visual_mode ==# "line"
	\|| g:visual_mode ==# "block"
		let g:pseudo_visual = !g:pseudo_visual
		Showtab
		return ""
	else
		echohl ErrorMsg
		echomsg "dotfiles: hcm: V_DoVLine: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
vnoremap V V<cmd>call V_DoVLine()<cr>
function! V_DoVBlock()
	if v:false
	elseif g:visual_mode ==# "no"
		echohl ErrorMsg
		echomsg "dotfiles: hcm: V_DoVBlock: Internal error: It is not visual mode"
		echohl Normal
	elseif g:visual_mode ==# "char"
		let g:visual_mode = "block"
	elseif g:visual_mode ==# "line"
		let g:visual_mode = "block"
	elseif g:visual_mode ==# "block"
		let g:visual_mode = "no"
	else
		echohl ErrorMsg
		echomsg "dotfiles: hcm: V_DoVBlock: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
vnoremap <c-v> <c-v><cmd>call V_DoVBlock()<cr>
vnoremap <nowait> <esc> <cmd>let g:pseudo_visual=v:true<cr>
function! MoveLeft()
	let c=col('.')
	let l=line('.')
	if v:false
	elseif v:false
	\|| g:visual_mode ==# "char"
	\|| g:visual_mode ==# "block"
		if v:false
		\|| c!=#g:ly
		\|| l!=#g:lx
			return "o"
		endif
	elseif v:false
	\|| g:visual_mode ==# "line"
		if v:false
		\|| c!=#g:ly
		\|| l!=#g:lx
			return "o"
		endif
		return "o0"
	else
		echohl ErrorMsg
		echomsg "dotfiles: hcm: MoveLeft: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
function! V_DoI()
	return MoveLeft()."\<esc>i"
endfunction
vnoremap <expr> i V_DoI()
function! MoveRight()
	let c=col('.')
	let l=line('.')
	if v:false
	elseif v:false
	\|| g:visual_mode ==# "char"
	\|| g:visual_mode ==# "block"
		if v:true
		\&& c==#g:ly
		\&& l==#g:lx
			return "o"
		endif
	elseif v:false
	\|| g:visual_mode ==# "line"
		if l==#g:lx
			return "o$"
		endif
		return "$"
	else
		echohl ErrorMsg
		echomsg "dotfiles: hcm: MoveRight: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
function! V_DoA()
	return MoveRight()."\<esc>a"
endfunction
vnoremap <expr> a V_DoA()
let g:last_selected = ''
function! V_DoS()
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/vim-quickui")
		let select = quickui#input#open('Select:', g:last_selected)
	else
		let hcm_select_label = 'select'.(g:last_selected!=#''?' (default: '.g:last_selected.')':'').':'
		let select = input(hcm_select_label)
	endif
	if select ==# ''
		let select = g:last_selected
	else
		let g:last_selected = select
	endif
	call feedkeys(MoveLeft(), 't')
	call ExitVisual()
	let cnt = count(GetVisualSelection(), select)
	echomsg "cnt is: ".cnt
	if cnt !=# 0
		exec "VMSearch" select
		for _ in range(cnt-1)
			call vm#commands#find_next(v:false, v:false)
		endfor
	endif
endfunction
vnoremap s <cmd>call V_DoS()<cr>
function! V_DoX()
	let result = ""
	if g:visual_mode==#"char"
		let g:visual_mode="line"
		let result .= "V"
	endif
	let result .= MoveRight()
	let result .= "j"
	return result
endfunction
vnoremap <expr> x V_DoX()
vnoremap X j
function! V_DoH()
	if g:pseudo_visual
		exec "normal! \<esc>h"
	else
		exec "normal! h"
		call ReorderRightLeft()
		call SavePosition()
	endif
endfunction
vnoremap h <cmd>call V_DoH()<cr>
vnoremap <left> <cmd>call V_DoH()<cr>
function! V_DoL()
	if g:pseudo_visual
		exec "normal! \<esc>l"
	else
		exec "normal! l"
		call ReorderRightLeft()
		call SavePosition()
	endif
endfunction
vnoremap l <cmd>call V_DoL()<cr>
vnoremap <right> <cmd>call V_DoL()<cr>
function! V_DoW()
	if g:pseudo_visual
		exec "normal! \<esc>wviw"
	else
		normal! w
	endif
endfunction
vnoremap w <cmd>call V_DoW()<cr>
function! V_DoWWhole()
	if g:pseudo_visual
		exec "normal! \<esc>wviW"
	else
		normal! W
	endif
endfunction
vnoremap W <cmd>call V_DoWWhole()<cr>
function! V_DoE()
	if g:pseudo_visual
		exec "normal! \<esc>eviw"
	else
		normal! e
	endif
endfunction
vnoremap e <cmd>call V_DoE()<cr>
function! V_DoEWhole()
	if g:pseudo_visual
		exec "normal! \<esc>wviW"
	else
		normal! E
	endif
endfunction
vnoremap E <cmd>call V_DoEWhole()<cr>
function! V_DoB()
	if g:pseudo_visual
		exec "normal! \<esc>hviwo"
	else
		exec "normal! b"
	endif
endfunction
vnoremap b <cmd>call V_DoB()<cr>
function! V_DoBWhole()
	if g:pseudo_visual
		exec "normal! \<esc>hviW"
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
vnoremap <leader>xo o<cmd>call ReorderRightLeft()<cr>
nnoremap C <c-v>j
vnoremap C j
nnoremap , <nop>
vnoremap , <esc>
nnoremap <c-s> m'
nnoremap U <c-r>
vnoremap y ygv<cmd>let g:pseudo_visual=v:true<cr>

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
