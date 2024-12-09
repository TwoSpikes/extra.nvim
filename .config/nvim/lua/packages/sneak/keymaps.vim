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
	nnoremap f  <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>let g:sneak_mode = 'f'<bar>call sneak#wrap('',1,0,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<cr>
	nnoremap F  <cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>let g:sneak_mode = 'F'<bar>call sneak#wrap('',1,1,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:lx=line('.')<bar>let g:ly=col('.')<bar>augroup SneakDisableTCr<bar>execute "xunmap t<"."cr>"<bar>call AfterSomeEvent("CursorMoved", "xnoremap t<"."cr>", {name -> "if !sneak#is_sneaking()\|au! ".name."\|endif"})<cr>
	nnoremap t  <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>let g:sneak_mode = 't'<bar>call sneak#wrap('',1,0,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<bar>execute "xunmap t<"."cr>"<bar>call AfterSomeEvent("CursorMoved", "if !sneak#is_sneaking()\|\|g:sneak_mode !=# 't'\|execute \"xnoremap t<"."cr> <"."cmd>call V_DoT_Cr()<"."cr>\"\|endif", {name -> "if !sneak#is_sneaking()\|\|g:sneak_mode !=# 't'\|autocmd! ".name."\|endif"})<cr>
	nnoremap T  <cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>let g:sneak_mode = 'T'<bar>call sneak#wrap('',1,1,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:lx=line('.')<bar>let g:ly=col('.')<bar>augroup SneakDisableTCr<bar>execute "xunmap t<"."cr>"<bar>call AfterSomeEvent("CursorMoved", "xnoremap t<"."cr>", {name -> "if !sneak#is_sneaking()\|au! ".name."\|endif"})<cr>
	nnoremap s  <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>let g:sneak_mode = 's'<bar>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<bar>augroup SneakDisableTCr<bar>execute "xunmap t<"."cr>"<bar>call AfterSomeEvent("CursorMoved", "xnoremap t<"."cr>", {name -> "if !sneak#is_sneaking()\|au! ".name."\|endif"})<cr>
	nnoremap S  <cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>let g:sneak_mode = 'S'<bar>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:lx=line('.')<bar>let g:ly=col('.')<bar>augroup SneakDisableTCr<bar>execute "xunmap t<"."cr>"<bar>call AfterSomeEvent("CursorMoved", "xnoremap t<"."cr>", {name -> "if !sneak#is_sneaking()\|au! ".name."\|endif"})<cr>
	nnoremap gw <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>let g:sneak_mode = 'gw'<bar>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<bar>augroup SneakDisableTCr<bar>execute "xunmap t<"."cr>"<bar>call AfterSomeEvent("CursorMoved", "xnoremap t<"."cr>", {name -> "if !sneak#is_sneaking()\|au! ".name."\|endif"})<cr>
	nnoremap gW <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>let g:sneak_mode = 'gW'<bar>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<bar>augroup SneakDisableTCr<bar>execute "xunmap t<"."cr>"<bar>call AfterSomeEvent("CursorMoved", "xnoremap t<"."cr>", {name -> "if !sneak#is_sneaking()\|au! ".name."\|endif"})<cr>
	xnoremap f  <cmd>if g:sneak_mode !=# 'f' && g:sneak_mode !=# 'F'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode='f'<bar>call sneak#wrap('',1,0,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'o`y"<cr>
	xnoremap F  <cmd>if g:sneak_mode !=# 'F' && g:sneak_mode !=# 'f'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode='F'<bar>call sneak#wrap('',1,1,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! ``o`y"<cr>
	xnoremap t  <cmd>if g:sneak_mode !=# 't' && g:sneak_mode !=# 'T'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let prev_sneak_mode=g:sneak_mode<bar>let g:sneak_mode = 't'<bar>call sneak#wrap('',1,0,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'o`y"<bar>if prev_sneak_mode !=# g:sneak_mode<bar>execute "xunmap t<"."cr>"<bar>endif<bar>unlet prev_sneak_mode<bar>call AfterSomeEvent("CursorMoved", "if !sneak#is_sneaking()\|\|g:sneak_mode !=# 't'\|execute \"xnoremap t<"."cr> <"."cmd>call V_DoT_Cr()<"."cr>\"\|endif", {name -> "if !sneak#is_sneaking()\|\|g:sneak_mode !=# 't'\|autocmd! ".name."\|endif"})<cr>
	xnoremap T  <cmd>if g:sneak_mode !=# 'T' && g:sneak_mode !=# 't'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'T'<bar>call sneak#wrap('',1,1,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'o`y"<cr>
	function! V_DoSneak_S()
	  if v:true
	  \&& g:sneak_mode !=# 's'
	  \&& g:sneak_mode !=# 'S'
		call CollapseVisual()
		exec "normal! m`"
	  endif
	  let g:sneak_mode = 's'
	  call sneak#wrap('',2,0,2,1)
	  exec "normal! my"
	  let g:visual_mode="char"
	  let g:pseudo_visual=v:true
	  execute "normal! `'o`y"
	endfunction
	xnoremap s  <cmd>call V_DoSneak_S()<cr>
	xnoremap S  <cmd>if g:sneak_mode !=# 'S' && g:sneak_mode !=# 's'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'S'<bar>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'o`y"<cr>
	xnoremap gw <cmd>if g:sneak_mode !=# 'gw' && g:sneak_mode !=# 'gW'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'gw'<bar>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'o`y"<cr>
	xnoremap gW <cmd>if g:sneak_mode !=# 'gW' && g:sneak_mode !=# 'gw'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let g:sneak_mode = 'gW'<bar>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'o`y"<cr>
endif
