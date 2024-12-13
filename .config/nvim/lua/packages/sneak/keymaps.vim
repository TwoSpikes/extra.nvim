if v:true
\&& g:compatible !=# "helix"
\&& g:compatible !=# "helix_hard"
	noremap f  <Plug>Sneak_f
	noremap F  <Plug>Sneak_F
	noremap t  <Plug>Sneak_t
	noremap T  <Plug>Sneak_T
	noremap s  <Plug>Sneak_s
	noremap S  <Plug>Sneak_S
	noremap gw <Plug>Sneak_s
	noremap gW <Plug>Sneak_S
else
	function! SneakCancel() abort
		xnoremap f<esc> <cmd><cr>
		xnoremap F<esc> <cmd><cr>
		xnoremap t<esc> <cmd><cr>
		xnoremap T<esc> <cmd><cr>
		xnoremap s<esc> <cmd><cr>
		xnoremap S<esc> <cmd><cr>
		xnoremap gw<esc> <cmd><cr>
		xnoremap gW<esc> <cmd><cr>
		xnoremap t<cr> <cmd>call V_DoT_Cr()<cr>
		call sneak#util#removehl()
		augroup sneak
			autocmd!
		augroup END
		if maparg('<esc>', 'n') =~# "'s'\\.'neak#cancel'"
			silent! unmap <esc>
		endif
		return ''
	endfunction
	nnoremap f<esc> <cmd><cr>
	nnoremap F<esc> <cmd><cr>
	nnoremap t<esc> <cmd><cr>
	nnoremap T<esc> <cmd><cr>
	nnoremap s<esc> <cmd><cr>
	nnoremap S<esc> <cmd><cr>
	nnoremap gw<esc> <cmd><cr>
	nnoremap gW<esc> <cmd><cr>
	xnoremap f<esc> <cmd><cr>
	xnoremap F<esc> <cmd><cr>
	xnoremap t<esc> <cmd><cr>
	xnoremap T<esc> <cmd><cr>
	xnoremap s<esc> <cmd><cr>
	xnoremap S<esc> <cmd><cr>
	xnoremap gw<esc> <cmd><cr>
	xnoremap gW<esc> <cmd><cr>
	let g:first_sneak = v:true
	augroup Sneak_Esc_Workaround
	    autocmd!
	augroup END
	nnoremap f  <cmd>if !sneak#is_sneaking()<bar>let g:first_sneak=v:true<bar>endif<bar>let g:lx=line('.')<bar>let g:ly=col('.')<bar>let g:sneak_mode = 'f'<bar>execute "normal! mx"<bar>call sneak#wrap('',1,0,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `xv`y"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<bar>if g:first_sneak<bar>execute "xunmap f<"."esc>"<bar>execute "xunmap F<"."esc>"<bar>endif<bar>augroup Sneak_Esc_Workaround<bar>autocmd!<bar>execute "autocmd CursorMoved * if mode()!~?'v'\|call SneakCancel()\|autocmd! Sneak_Esc_Workaround\|endif"<bar>augroup END<bar>let g:first_sneak=v:false<cr>
	nnoremap F  <cmd>if !sneak#is_sneaking()<bar>let g:first_sneak=v:true<bar>endif<bar>let g:rx=line('.')<bar>let g:ry=col('.')<bar>let g:sneak_mode = 'F'<bar>execute "normal! mx"<bar>call sneak#wrap('',1,1,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `xv`y"<bar>let g:lx=line('.')<bar>let g:ly=col('.')<bar>if g:first_sneak<bar>execute "xunmap F<"."esc>"<bar>execute "xunmap f<"."esc>"<bar>endif<bar>augroup Sneak_Esc_Workaround<bar>autocmd!<bar>execute "autocmd CursorMoved * if mode()!~?'v'\|call SneakCancel()\|autocmd! Sneak_Esc_Workaround\|endif"<bar>augroup END<bar>let g:first_sneak=v:false<cr>
	nnoremap t  <cmd>if !sneak#is_sneaking()<bar>let g:first_sneak=v:true<bar>endif<bar>let g:lx=line('.')<bar>let g:ly=col('.')<bar>let g:sneak_mode = 't'<bar>call sneak#wrap('',1,0,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<bar>if g:first_sneak<bar>execute "xunmap t<"."esc>"<bar>execute "xunmap T<"."esc>"<bar>execute "xunmap t<"."cr>"<bar>endif<bar>augroup Sneak_Esc_Workaround<bar>autocmd!<bar>execute "autocmd CursorMoved * if mode()!~?'v'\|call SneakCancel()\|autocmd! Sneak_Esc_Workaround\|endif"<bar>augroup END<bar>let g:first_sneak=v:false<cr>
	nnoremap T  <cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>let g:sneak_mode = 'T'<bar>call sneak#wrap('',1,1,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:lx=line('.')<bar>let g:ly=col('.')<bar>execute "xunmap t<"."cr>"<bar>call AfterSomeEvent("CursorMoved,ModeChanged", "xnoremap t<"."cr>", {name -> "if !sneak#is_sneaking()\|\|g:sneak_mode !=# 't'\|autocmd! ".name."\|endif"})<bar>execute "xunmap T<"."esc>"<bar>call AfterSomeEvent("CursorMoved", "if !sneak#is_sneaking()\|execute \"xnoremap T<"."esc> <"."cmd><"."cr>\"\|endif", {name -> "if !sneak#is_sneaking()\|autocmd! ".name."\|endif"})<cr>
	nnoremap s  <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>let g:sneak_mode = 's'<bar>call sneak#wrap('',2,0,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<bar>execute "xunmap t<"."cr>"<bar>call AfterSomeEvent("CursorMoved,ModeChanged", "xnoremap t<"."cr>", {name -> "if !sneak#is_sneaking()\|autocmd! ".name."\|endif"})<bar>execute "xunmap s<"."esc>"<bar>call AfterSomeEvent("CursorMoved", "if !sneak#is_sneaking()\|execute \"xnoremap s<"."esc> <"."cmd><"."cr>\"\|endif", {name -> "if !sneak#is_sneaking()\|autocmd! ".name."\|endif"})<cr>
	nnoremap S  <cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>let g:sneak_mode = 'S'<bar>call sneak#wrap('',2,1,2,1)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'v`y"<bar>let g:lx=line('.')<bar>let g:ly=col('.')<bar>execute "xunmap S<"."esc>"<bar>call AfterSomeEvent("CursorMoved,ModeChanged", "if !sneak#is_sneaking()\|execute \"xnoremap S<"."esc> <"."cmd><"."cr>\"\|endif", {name -> "if !sneak#is_sneaking()\|autocmd! ".name."\|endif"})<cr>
	xnoremap f  <cmd>let st=sneak#state()<bar>let str=st.reverse<bar>let strr=st.rptreverse<bar>unlet st<bar>if g:sneak_mode!=?'f'\|\|str==#0&&g:sneak_mode==#'F'\|\|str==#1&&g:sneak_mode==#'F'&&strr==#0<bar>call CollapseVisual()<bar>execute "normal! m`"<bar>endif<bar>unlet str<bar>unlet strr<bar>let g:sneak_mode='f'<bar>call sneak#wrap('',1,0,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'o`y"<bar>if g:first_sneak<bar>execute "xunmap f<"."esc>"<bar>execute "xunmap F<"."esc>"<bar>endif<bar>augroup Sneak_Esc_Workaround<bar>autocmd!<bar>execute "autocmd CursorMoved * if mode()!~?'v'\|call SneakCancel()\|autocmd! Sneak_Esc_Workaround\|endif"<bar>augroup END<cr>
	xnoremap F  <cmd>let str=sneak#state().reverse<bar>if g:sneak_mode!=?'f'\|\|str==#0&&g:sneak_mode==#'f'\|\|str==#1&&g:sneak_mode==#'f'<bar>call CollapseVisual()<bar>execute "normal! m`"<bar>endif<bar>unlet str<bar>let g:sneak_mode='F'<bar>call sneak#wrap('',1,1,1,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! ``o`y"<bar>if g:first_sneak<bar>execute "xunmap F<"."esc>"<bar>endif<bar>augroup Sneak_Esc_Workaround<bar>autocmd!<bar>execute "autocmd CursorMoved * if mode()!~?'v'\|call SneakCancel()\|autocmd! Sneak_Esc_Workaround\|endif"<bar>augroup END<cr>
	xnoremap t  <cmd>if g:sneak_mode!=#'t'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let prev_sneak_mode=g:sneak_mode<bar>let g:sneak_mode = 't'<bar>call sneak#wrap('',1,0,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'o`y"<bar>if g:first_sneak<bar>execute "xunmap t<"."cr>"<bar>execute "xunmap T<"."cr>"<bar>endif<bar>unlet prev_sneak_mode<bar>augroup Sneak_Esc_Workaround<bar>autocmd!<bar>execute "autocmd CursorMoved * if mode()!~?'v'\|call SneakCancel()\|autocmd! Sneak_Esc_Workaround\|endif"<bar>augroup END<cr>
	xnoremap T  <cmd>if g:sneak_mode!=#'T'<bar>call CollapseVisual()<bar>exec "normal! m`"<bar>endif<bar>let prev_sneak_mode=g:sneak_mode<bar>let g:sneak_mode = 'T'<bar>call sneak#wrap('',1,1,0,0)<bar>exec "normal! my"<bar>let g:visual_mode="char"<bar>let g:pseudo_visual=v:true<bar>execute "normal! `'o`y"<bar>if prev_sneak_mode !=# g:sneak_mode<bar>execute "xunmap t<"."cr>"<bar>endif<bar>unlet prev_sneak_mode<bar>call AfterSomeEvent("CursorMoved,ModeChanged", "if !sneak#is_sneaking()\|\|g:sneak_mode !=# 't'\|execute \"xnoremap t<"."cr> <"."cmd>call V_DoT_Cr()<"."cr>\"\|endif", {name -> "if !sneak#is_sneaking()\|\|g:sneak_mode !=# 't'\|autocmd! ".name."\|endif"})<bar>execute "xunmap T<"."esc>"<bar>call AfterSomeEvent("CursorMoved", "if !sneak#is_sneaking()\|execute \"xnoremap T<"."esc> <"."cmd><"."cr>\"\|endif", {name -> "if !sneak#is_sneaking()\|autocmd! ".name."\|endif"})<cr>
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
endif
