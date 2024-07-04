if v:true
\&& g:compatible !=# "helix"
\&& g:compatible !=# "helix_hard"
	noremap f  <Plug>(Sneak_f)
	noremap F  <Plug>(Sneak_F)
	noremap t  <Plug>(Sneak_t)
	noremap T  <Plug>(Sneak_T)
	noremap s  <Plug>(Sneak_s)
	noremap S  <Plug>(Sneak_S)
	noremap gw <Plug>(Sneak_s)
	noremap gW <Plug>(Sneak_S)
else
	nnoremap f  <cmd>call sneak#wrap('',1,0,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'v`y<cr>
	nnoremap F  <cmd>call sneak#wrap('',1,1,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'v`y<cr>
	nnoremap t  <cmd>call sneak#wrap('',1,0,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'v`y<cr>
	nnoremap T  <cmd>call sneak#wrap('',1,1,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'v`y<cr>
	nnoremap s  <cmd>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'v`y<cr>
	nnoremap S  <cmd>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'v`y<cr>
	nnoremap gw <cmd>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'v`y<cr>
	nnoremap gW <cmd>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'v`y<cr>
	xnoremap f  <cmd>call sneak#wrap('',1,0,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'o`y<cr>
	xnoremap F  <cmd>call sneak#wrap('',1,1,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'o`y<cr>
	xnoremap t  <cmd>call sneak#wrap('',1,0,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'o`y<cr>
	xnoremap T  <cmd>call sneak#wrap('',1,1,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'o`y<cr>
	xnoremap s  <cmd>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'o`y<cr>
	xnoremap S  <cmd>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'o`y<cr>
	xnoremap gw <cmd>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'o`y<cr>
	xnoremap gW <cmd>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>normal! `'o`y<cr>
endif
let g:sneak#s_next = 1
