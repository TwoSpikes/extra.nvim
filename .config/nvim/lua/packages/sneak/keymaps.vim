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
	nnoremap f  <cmd>let g:sneak_mode = 'f'<bar>call sneak#wrap('',1,0,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'v`y<cr>
	nnoremap F  <cmd>let g:sneak_mode = 'F'<bar>call sneak#wrap('',1,1,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'v`y<cr>
	nnoremap t  <cmd>let g:sneak_mode = 't'<bar>call sneak#wrap('',1,0,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'v`y<cr>
	nnoremap T  <cmd>let g:sneak_mode = 'T'<bar>call sneak#wrap('',1,1,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'v`y<cr>
	nnoremap s  <cmd>let g:sneak_mode = 's'<bar>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'v`y<cr>
	nnoremap S  <cmd>let g:sneak_mode = 'S'<bar>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'v`y<cr>
	nnoremap gw <cmd>let g:sneak_mode = 'gw'<bar>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'v`y<cr>
	nnoremap gW <cmd>let g:sneak_mode = 'gW'<bar>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'v`y<cr>
	xnoremap f  <cmd>if g:sneak_mode !=# 'f' <bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'f'<bar>call sneak#wrap('',1,0,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'o`y<cr>
	xnoremap F  <cmd>if g:sneak_mode !=# 'F' <bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'F'<bar>call sneak#wrap('',1,1,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! ``o`y<cr>
	xnoremap t  <cmd>if g:sneak_mode !=# 't' <bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 't'<bar>call sneak#wrap('',1,0,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'o`y<cr>
	xnoremap T  <cmd>if g:sneak_mode !=# 'T' <bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'T'<bar>call sneak#wrap('',1,1,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'o`y<cr>
	xnoremap s  <cmd>if g:sneak_mode !=# 's' <bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 's'<bar>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'o`y<cr>
	xnoremap S  <cmd>if g:sneak_mode !=# 'S' <bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'S'<bar>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'o`y<cr>
	xnoremap gw <cmd>if g:sneak_mode !=# 'gw'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'gw'<bar>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'o`y<cr>
	xnoremap gW <cmd>if g:sneak_mode !=# 'gW'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'gW'<bar>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>normal! `'o`y<cr>
endif
let g:sneak#s_next = 1
