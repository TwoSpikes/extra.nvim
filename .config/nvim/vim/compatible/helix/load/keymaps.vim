" Files of hcm (Helix compatibility mode)

"" LEGEND
" hcm: Helix compatibility mode
" Do_V_*, V_Do_*, V_Do*: xnoremap action
" N_Do_*: nnoremap action
" *_NPV_*: non-pseudo visual mode action
" *_PV_*: pseudo visual mode action
" MoveLeft(x1, y1, x2, y2): move to the left of the selection ((x1, y1) — coordinates of the left of the selection, (x2, y2) — coordinates of the right of the selection)
" MoveRight(x1, x2, y1, y2): move to the right of the selection ((x1, y1) — coordinates of the left of the selection, (x2, y2) — coordinates of the right of the selection)

function! Do_V_0()
	if g:pseudo_visual
		execute "normal! \<c-\>\<c-n>"
	endif
	normal! 0
endfunction
nnoremap gh <cmd>call Do_V_0()<cr>
xnoremap gh <cmd>call Do_V_0()<cr>
nnoremap 0 <cmd>call Do_V_0()<cr>
xnoremap 0 <cmd>call Do_V_0()<cr>
function! Do_V_Dollar()
	if g:pseudo_visual
		execute "normal! \<c-\>\<c-n>"
	endif
	normal! $
endfunction
nnoremap gl <cmd>call Do_V_Dollar()<cr>
nnoremap $ <cmd>call Do_V_Dollar()<cr>
function! Fix_NPV_Dollar()
	if strlen(getline('.')) && mode() =~? '^v'
		exe"normal! h"
	endif
endfunction
if !g:do_not_save_previous_column_position_when_going_up_or_down
	xnoremap gl <cmd>call Do_V_Dollar()<cr><cmd>call Fix_NPV_Dollar()<cr>
	xnoremap $ <cmd>call Do_V_Dollar()<cr><cmd>call Fix_NPV_Dollar()<cr>
else
	xnoremap gl <cmd>call Do_V_Dollar()<cr><cmd>call Fix_NPV_Dollar()<cr>mz`z
	xnoremap $ <cmd>call Do_V_Dollar()<cr><cmd>call Fix_NPV_Dollar()<cr>mz`z
endif

function! Do_V_ge_base_define(name, count)
execute "
\xnoremap ".a:name." <cmd>
\if g:pseudo_visual<bar>
\execute \"normal! v\"<bar>
\endif<bar>
\call feedkeys(".a:count.".\"G\", \"n\")
\<cr>"
endfunction
call Do_V_ge_base_define('ge', 'v:prevcount')
call Do_V_ge_base_define('G', 'v:count')
delfunction Do_V_ge_base_define

nnoremap ge G
nnoremap gs ^
xnoremap gs ^
xnoremap gg <cmd>
\if g:pseudo_visual<bar>
\execute "normal! v"<bar>
\endif<bar>
\call feedkeys(v:count."gg", "n")
\<cr>

if g:compatible =~# "^helix_hard"
	set noruler
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
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: ExitVisual: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
function! CollapseVisual()
	if v:false
	elseif g:visual_mode ==# "char"
		normal! vv
	elseif g:visual_mode ==# "line"
		normal! VV
	elseif g:visual_mode ==# "block"
		normal! <c-v><c-v>
	else
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: CollapseVisual: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction

set notildeop
let &whichwrap="b,s,h,l,<,>,~,[,]"
set virtualedit=onemore

function! Do_N_D(count)
	if col('.') ==# col('$')
		normal! mz
		join!
		normal! `z
	else
		execute "normal! ".a:count."x"
	endif
endfunction
nnoremap d <cmd>call Do_N_D(v:count1)<cr>
function! PV()
	normal! gv
	let g:pseudo_visual = v:true
endfunction
function! SetYankMode()
	let lend=len(getline(g:lx))+1
	let rend=len(getline(g:rx))+1
	if v:false
	elseif v:false
	\|| g:ly ==# 1
	\&& g:ry ==# rend
		let g:yank_mode = "line"
	else
		let g:yank_mode = "char"
	endif
endfunction
function! V_DoD()
	if !&modifiable
		echohl ErrorMsg
		echomsg "extra.nvim: V_DoD: file is not modifiable"
		echohl Normal
		return
	endif
	let register = v:register
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft(line('.'), col('.'), g:lx, g:ly)
	normal! o
	call SetYankMode()
	execute "normal! \"".register."d"
endfunction
xnoremap d <cmd>call V_DoD()<cr>
function! N_DoX_Define()
let result = "
\function! N_DoX(count)
\\n	let g:pseudo_visual=v:true
\\n	let g:visual_mode=\"char\"
\\n	normal! 0v
\\n	let g:lx = line('.')
\\n	let g:ly = col('.')
\\n"
if g:disable_animations ==# v:false
  let result .= "
  \	let i=1
  \\n while i<#a:count
  \\n	call feedkeys('j', 'n')
  \\n	let i+=1
  \\n endwhile
  \\n unlet i
  \"
else
  let result .= "
  \	call feedkeys(a:count>#1?a:count-1.'j':'', 'n')
  \"
endif
let result .= "
\\n	normal! $
\\n	let g:rx = line('.')
\\n	let g:ry = col('.')
\\nendfunction
\"
execute result
endfunction
call N_DoX_Define()
nnoremap x <cmd>call N_DoX(v:count1)<cr>
nnoremap X <cmd>call N_DoX(v:count1)<cr>
xnoremap ~ <c-\><c-n><cmd>call Do_V_Tilde()<bar>execute "normal! gv"<bar>let g:pseudo_visual=v:true<bar>execute "Showtab"<cr>
function! ChangeVisModeBasedOnSelectedText()
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft(g:rx, g:ry, g:lx, g:ly)
	normal! o
	if v:false
	\|| g:ly !=# 1
	\|| g:ry <# strlen(getline(g:rx))
	else
		if mode() !~# 'V'
			call feedkeys("V", 'n')
		endif
	endif
	if v:false
	\|| g:yank_mode ==# "line"
	\|| g:yank_mode ==# "line_post"
	  call feedkeys('h', 'n')
	endif
endfunction
function! SimulateCorrectPasteMode(cmd, register)
	if v:false
	elseif v:false
	\|| g:yank_mode ==# 'char'
		if v:false
		elseif a:cmd ==# '$'
			if col('.') ==# col('$')
				if line('.') ==# line('$')
					call append(line('.'), '')
				endif
				let paste_cmd = 'j0P'
			else
				let paste_cmd = 'p'
			endif
		elseif a:cmd ==# '0'
			let paste_cmd = 'P'
		else
			echohl ErrorMsg
			echomsg "extra.nvim: hcm: SimulateCorrectPasteMode: Internal error: wrong a:cmd: ".a:cmd
			echohl Normal
		endif
	elseif g:yank_mode ==# "line"
		if v:false
		elseif a:cmd ==# '$'
			if line('.') ==# line('$')
				call append(line('.'), '')
				let paste_cmd = "jP\<bs>"
			else
				let paste_cmd = 'j0P'
			endif
		elseif a:cmd ==# '0'
			execute "normal! 0"
			let paste_cmd = 'P'
		else
			echohl ErrorMsg
			echomsg "extra.nvim: hcm: SimulateCorrectPasteMode: Internal error: wrong a:cmd: ".a:cmd
			echohl Normal
		endif
	else
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: SimulateCorrectPasteMode: Internal error: wrong yank mode: ".g:yank_mode
		echohl Normal
	endif

	let the_user_is_an_incredible_idiot_and_is_doing_some_crazy_stuff = g:yank_mode ==# "line" && a:cmd ==# '$' && line('.') + 1 ==# line('$')

	execute "normal! \"".a:register.paste_cmd

	if the_user_is_an_incredible_idiot_and_is_doing_some_crazy_stuff
		let old_start = getpos("'[")
		let old_end = getpos("']")
		let old_end[1] -= 1
		let old_end[2] = len(getline(old_end[1])) + 1
		undojoin | execute "normal! G$a\<bs>\<c-\>\<c-n>"
		call setpos("'[", old_start)
		unlet old_start
		call setpos("']", old_end)
		unlet old_end
	endif
endfunction
nnoremap p <cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('$', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>if g:compatible=~#"^helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
nnoremap P <cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('0', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>if g:compatible=~#"^helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
xnoremap p <esc><cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('$', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>if g:compatible=~#"^helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
xnoremap P <esc><cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('0', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>if g:compatible=~#"^helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
nnoremap gp <cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('$', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>exe"norm! o"<bar>if g:compatible=~#"^helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
nnoremap gP <cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('0', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>exe"norm! o"<bar>if g:compatible=~#"^helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
xnoremap gp <esc><cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('$', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>exe"norm! o"<bar>if g:compatible=~#"^helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
xnoremap gP <esc><cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('0', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>exe"norm! o"<bar>if g:compatible=~#"^helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
nnoremap c <cmd>call Do_N_D(v:count1)<cr>i

if len(maparg("y\<c-g>")) !=# 0
	unmap y<c-g>
endif
if len(maparg('ySS')) !=# 0
	unmap ySS
endif
if len(maparg('ySs')) !=# 0
	unmap ySs
endif
if len(maparg('yss')) !=# 0
	unmap yss
endif
if len(maparg('yS')) !=# 0
	unmap yS
endif
if len(maparg('ys')) !=# 0
	unmap ys
endif

nnoremap y <cmd>let register=v:register<bar>exe"norm! v\"".register."y"<cr>
function! Do_N_T_Cr()
	let g:lx = line('.')
	let g:ly = col('.')
	execute "normal! v$"
	let g:rx = line('.')
	let g:ry = line('.')
	let g:pseudo_visual = v:true
	let g:visual_mode = "char"
endfunction
nnoremap t<cr> <cmd>call Do_N_T_Cr()<cr>
nnoremap mm %
xnoremap mm %
inoremap <c-x> <c-p>
inoremap <c-p> <c-x>
nnoremap <a-o> viw
nnoremap <a-.> ;
xnoremap R "_dP
function! Do_N_R_define()
	let defer_expression = "
	\\n call cursor(old_position)
	\\n	let &guicursor=old_guicursor
	\\n	unlet old_guicursor
	\\n	unlet old_position
	\"
	let result = "
	\function! Do_N_R(count)
	\\n	let old_position=getpos('.')[1:]
	\\n	let old_guicursor=&guicursor
	\\n	let &guicursor='a:block-blinkwait175-blinkoff150-blinkon175-CursorReplace'
	\\n	let c=getchar()
	\\n	if c ==# 27
	\".defer_expression."
	\\n		return
	\\n	endif
	\\n	if col('.') ==# col('$')
	\\n		let wl=winline()
	\\n		call append(line('.'), nr2char(c))
	\\n		unlet c
	\\n		if line('.') ==# line('$') - 1
	\\n			join!
	\\n		else
	\\n			,+2join!
	\\n		endif
	\\n		if winheight(winnr()) - wl <# &scrolloff
	\\n			normal! \<c-y>
	\\n		endif
	\\n		unlet wl
	\\n	else
	\\n		let c=nr2char(c)
	\\n		call inputsave()
	\"
	if has('nvim')
		let result .= "
		\\n		silent! call nvim_buf_set_text(bufnr(), line('.')-1, col('.')-1, line('.')-1, col('.')+a:count-1, [repeat(c, a:count)])
		\"
	else
		let result .= "
		\\n		let line=getline(line('.'))
		\\n		let line=line[:col('.')-2].repeat(c, a:count).line[col('.')+a:count-1:]
		\\n		call setline(line('.'), line)
		\\n		unlet line
		\"
	endif
	let result .= "
	\\n		unlet c
	\\n		call inputrestore()
	\\n	endif
	\".defer_expression."
	\\nendfunction
	\"
	execute result
endfunction
call Do_N_R_define()
delfunction Do_N_R_define
nnoremap r <cmd>call Do_N_R(v:count1)<cr>
nnoremap ~ <cmd>call Do_N_Tilde()<cr>
nnoremap > >>
nnoremap < <<
xnoremap < <gv<cmd>let g:pseudo_visual=v:true<cr>
xnoremap > >gv<cmd>let g:pseudo_visual=v:true<cr>
function! V_DoT_Cr()
	call CollapseVisual()
	normal! $
	let g:pseudo_visual = v:true
	let g:visual_mode = "char"
endfunction
xnoremap t<cr> <cmd>call V_DoT_Cr()<cr>
if len(maparg('cS')) !=# 0
	unmap cS
endif
if len(maparg('cs')) !=# 0
	unmap cs
endif
if len(maparg('ds')) !=# 0
	unmap ds
endif
let g:pseudo_visual = v:false
let g:lx=1
let g:ly=1
let g:rx=1
let g:ry=1
let g:visual_mode = "no"
function! ReorderRightLeft()
	if g:lx>#g:rx||(g:lx==#g:rx&&g:ly>g:ry)
		let g:lx=xor(g:rx,g:lx)
		let g:rx=xor(g:lx,g:rx)
		let g:lx=xor(g:rx,g:lx)
		let g:ly=xor(g:ry,g:ly)
		let g:ry=xor(g:ly,g:ry)
		let g:ly=xor(g:ry,g:ly)
	endif
	return ''
endfunction
function! SavePosition(old_c, old_l, new_c, new_l)
	if a:old_c==#g:ly&&a:old_l==#g:lx
		let g:lx=a:new_l
		let g:ly=a:new_c
	else
		let g:rx=a:new_l
		let g:ry=a:new_c
	endif
endfunction
function! N_DoW()
	let g:pseudo_visual = v:true
	let g:visual_mode="char"
	let g:lx = line('.')
	let g:ly = col('.')
	let old_c = col('.')
	let old_l = line('.')
	if v:false
	\|| charclass(getline(old_l)[old_c-1]) ==# 0
	\&& charclass(getline(old_l)[old_c]) !=# 0
	\|| charclass(getline(old_l)[old_c-1]) ==# 2
	\&& charclass(getline(old_l)[old_c]) !=# 2
	\|| charclass(getline(old_l)[old_c-1]) !=# 2
	\&& charclass(getline(old_l)[old_c]) ==# 2
	\|| old_c ==# col('$')
		normal! l
	endif
	normal! vwh
	let g:rx = line('.')
	let g:ry = col('.')
endfunction
nnoremap w <cmd>call N_DoW()<cr>
function! N_DoE()
	let g:pseudo_visual = v:true
	let g:visual_mode = "char"
	let g:lx = line('.')
	let g:ly = col('.')
	let old_c = col('.')
	let old_l = line('.')
	execute "normal! ve"
	if getline(old_l)[old_c] ==# ''
		execute "normal! ollo"
	elseif v:false
	\|| charclass(getline(old_l)[old_c-1]) !=# 2
	\&& charclass(getline(old_l)[old_c]) !=# 2
	\|| charclass(getline(old_l)[old_c-1]) ==# 0
		execute
	elseif charclass(getline(old_l)[old_c-1]) !=# 2
		execute "normal! olo"
	else
		execute
	endif
	let g:rx = line('.')
	let g:ry = col('.')
endfunction
nnoremap e <cmd>call N_DoE()<cr>
function! N_DoB()
	let g:pseudo_visual = v:true
	let g:visual_mode = "char"
	let g:rx = line('.')
	let g:ry = col('.')
	let old_c = col('.')
	let old_l = line('.')
	execute "normal! vb"
	if getline(old_l)[old_c-2] ==# ''
		execute "normal! ohho"
	elseif v:false
	\|| charclass(getline(old_l)[old_c-1]) !=# 2
	\&& charclass(getline(old_l)[old_c-2]) !=# 2
	\|| charclass(getline(old_l)[old_c-1]) ==# 0
		execute
	elseif v:false
	\|| charclass(getline(old_l)[old_c-1]) !=# 2
	\|| charclass(getline(old_l)[old_c-2]) ==# 0
		execute "normal! oho"
	else
		execute
	endif
	let g:lx = line('.')
	let g:ly = col('.')
endfunction
nnoremap b <cmd>call N_DoB()<cr>
" nnoremap b <cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>execute "normal! v".v:count1."b"<bar>let g:lx=line('.')<bar>let g:ly=col('.')<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:visual_mode="char"<cr><cmd>call ReorderRightLeft()<cr>
nnoremap W <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>execute "normal! v".v:count1."W"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:visual_mode="char"<cr><cmd>call ReorderRightLeft()<cr>
function! N_DoEWhole()
	let g:pseudo_visual = v:true
	let g:visual_mode = "char"
	let g:lx = line('.')
	let g:ly = col('.')
	execute "normal! vE"
	let g:rx = line('.')
	let g:ry = col('.')
	if g:ly ># len(getline(g:lx))
		execute "normal! olo"
	elseif getline(line('.'))[g:ly] ==# ''
		execute "normal! ollo"
	elseif v:false
	\|| charclass(getline(line('.'))[g:ly]) ==# 0
		execute "normal! olo"
	elseif v:true
	\&& g:lx ==# line('.')
		execute
	else
		execute "normal! ollo"
	endif
	call ReorderRightLeft()
endfunction
nnoremap E <cmd>call N_DoEWhole()<cr>
function! N_DoBWhole()
	let g:pseudo_visual = v:true
	let g:visual_mode = "char"
	let g:rx = line('.')
	let g:ry = col('.')
	execute "normal! vB"
	let g:lx = line('.')
	let g:ly = col('.')
	if g:ry ># len(getline(g:rx))
		execute "normal! oho"
	elseif getline(line('.'))[g:ry] ==# ''
	elseif v:false
	\|| charclass(getline(line('.'))[g:ry-2]) ==# 0
	\&& charclass(getline(line('.'))[g:ry-1]) !=# 0
		execute "normal! oho"
	elseif v:true
	\&& g:rx ==# line('.')
		execute
	else
		execute "normal! ohho"
	endif
	call ReorderRightLeft()
endfunction
nnoremap B <cmd>call N_DoBWhole()<cr>
unmap <esc>
function! N_DoV()
	let g:pseudo_visual=v:false
	let g:rx=line('.')
	let g:ry=col('.')
	let g:lx=g:rx
	let g:ly=g:ry
	let g:visual_mode="char"
endfunction
nnoremap v v<cmd>call N_DoV()<cr>
nnoremap gv v<cmd>call N_DoV()<cr>
function! N_DoVLine()
	let result = ""
	let result .= "v"
	let result .= "0o$"
	let g:pseudo_visual=v:false
	let g:visual_mode="char"
	return result
endfunction
nnoremap <expr> V N_DoVLine()
nnoremap <c-v> <c-v><cmd>let g:pseudo_visual=v:false<cr><cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>let g:lx=rx<bar>let g:ly=ry<cr><cmd>let g:visual_mode="block"<cr>
function! V_DoV()
	if v:false
	elseif g:visual_mode ==# "no"
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: V_DoV: Internal error: It is not visual mode"
		echohl Normal
	elseif v:false
	\|| g:visual_mode ==# "char"
	\|| g:visual_mode ==# "line"
	\|| g:visual_mode ==# "block"
		let g:pseudo_visual = g:pseudo_visual?v:false:v:true
		Showtab
		return ""
	else
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: V_DoV: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
xnoremap <expr> v V_DoV()
function! V_DoVLine()
	if v:false
	elseif g:visual_mode ==# "no"
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: V_DoVLine: Internal error: It is not visual mode"
		echohl Normal
	elseif v:false
	\|| g:visual_mode ==# "char"
	\|| g:visual_mode ==# "line"
	\|| g:visual_mode ==# "block"
		let g:pseudo_visual = g:pseudo_visual?v:false:v:true
		Showtab
	else
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: V_DoVLine: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
xnoremap V <cmd>call V_DoVLine()<cr>
function! V_DoVBlock()
	if v:false
	elseif g:visual_mode ==# "no"
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: V_DoVBlock: Internal error: It is not visual mode"
		echohl Normal
	elseif v:false
	\|| g:visual_mode ==# "char"
	\|| g:visual_mode ==# "line"
	\|| g:visual_mode ==# "block"
		let g:pseudo_visual = g:pseudo_visual?v:false:v:true
		Showtab
	else
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: V_DoVBlock: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
xnoremap <c-v> <cmd>call V_DoVBlock()<cr>
xnoremap <nowait> <esc> <cmd>let g:pseudo_visual=v:true<cr>
function! MoveLeft(x1, y1, x2, y2)
	let c=col('.')
	let l=line('.')
	if v:false
	elseif v:false
	\|| g:visual_mode ==# "char"
	\|| g:visual_mode ==# "block"
		if v:false
		\|| a:x1>#a:x2
		\|| a:x1==#a:x2
		\&& a:y1>#a:y2
			return "o"
		endif
		return "oo"
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
		echomsg "extra.nvim: hcm: MoveLeft: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
xnoremap <expr> i MoveLeft(line('.'), col('.'), g:lx, g:ly)."\<esc>i"
function! MoveRight(x1, y1, x2, y2)
	let c=col('.')
	let l=line('.')
	if v:false
	elseif v:false
	\|| g:visual_mode ==# "char"
	\|| g:visual_mode ==# "block"
		if v:false
		\|| a:x1<#a:x2
		\|| a:x1==#a:x2
		\&& a:y1<#a:y2
			return "o"
		endif
		return "oo"
	elseif v:false
	\|| g:visual_mode ==# "line"
		if l==#g:lx
			return "o$"
		endif
		return "$"
	else
		echohl ErrorMsg
		echomsg "extra.nvim: hcm: MoveRight: Internal error: Wrong visual mode: ".g:visual_mode
		echohl Normal
	endif
endfunction
if len(maparg('a%')) !=# 0
	unmap a%
endif
xnoremap <expr> a MoveRight(line('.'), col('.'), g:rx, g:ry)."\<esc>a"
function! V_DoS()
	if exists('#sneak#CursorMoved') && g:sneak_mode ==# 's'
		call V_DoSneak_S()
		return
	endif
	if has('nvim') && PluginExists('vim-quickui')
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
	call feedkeys(MoveLeft(line('.'), col('.'), g:lx, g:ly), 't')
	call ExitVisual()
	let cnt = count(GetVisualSelection(), select)
	echomsg "cnt is: ".cnt
	if cnt !=# 0
		execute "VMSearch" select
		for _ in range(cnt-1)
			call vm#commands#find_next(v:false, v:false)
		endfor
	endif
endfunction
xnoremap s <cmd>call V_DoS()<cr>
function! V_DoX_Define()
let result = "
\	function! V_DoX(count, count1)
\\n		let g:lx = line('.')
\\n		let g:ly = col('.')
\\n		normal! o
\\n		let g:rx = line('.')
\\n		let g:ry = col('.')
\\n		normal! o
\\n		call ReorderRightLeft()
\\n		execute \"normal! \".MoveLeft(line('.'), col('.'), g:lx, g:ly)
\\n		normal! o
\\n		let g=&wrap&&v:count==#0?'g':''
\\n		let not_full = v:false
		\|| g:ly !=# 1
		\|| g:ry ==# strlen(getline(g:rx)) - 1
\\n		if not_full
\\n			execute \"normal! o\".g.\"0o\"
\\n		else
\\n			normal! j
\\n		endif
\\n		let down = g.'j'
\\n		if a:count1 ># 2 - not_full
\"
if g:disable_animations
let result .= "
\\n		  call feedkeys((a:count1 - 1).down, 'n')
\"
else
let result .= "
\\n		  let i=1
\\n		  while i<#a:count1
\\n			call feedkeys(down, 'n')
\\n			let i+=1
\\n		  endwhile
\\n		  unlet i
\"
endif
let result .= "
\\n		endif
\\n		unlet not_full
\\n		unlet down
\\n		execute \"normal! \".g.\"$\"
\\n	endfunction
\"
execute result
endfunction
call V_DoX_Define()
delfunction V_DoX_Define
xnoremap x <cmd>call V_DoX(v:count, v:count1)<cr>
function! V_DoXDoNotExtendSubsequentLines()
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft(line('.'), col('.'), g:lx, g:ly)
	let lx=line('.')
	let ly=col('.')
	normal! o
	let rx=line('.')
	let ry=col('.')
	if v:false
	\|| ly !=# 1
	\|| ry <# strlen(getline(rx))
		normal! o0o$
	endif
endfunction
xnoremap X <cmd>call V_DoXDoNotExtendSubsequentLines()<cr>
function! V_DoH(c)
	if g:pseudo_visual
		execute "normal! \<esc>".a:c.'h'
	else
		let old_l=line('.')
		let old_c=col('.')
		execute 'normal!' a:c.'h'
		call ReorderRightLeft()
		call SavePosition(old_c, old_l, col('.'), line('.'))
	endif
endfunction
xnoremap h <cmd>call V_DoH(v:count1)<cr>
xnoremap <left> <cmd>call V_DoH(v:count1)<cr>
function! V_DoL(c)
	if g:pseudo_visual
		execute "normal! \<esc>".a:c.'l'
	else
		let old_c = col('.')
		let old_l = line('.')
		execute 'normal!' a:c.'l'
		call ReorderRightLeft()
		call SavePosition(old_c, old_l, col('.'), line('.'))
	endif
endfunction
xnoremap l <cmd>call V_DoL(v:count1)<cr>
xnoremap <right> <cmd>call V_DoL(v:count1)<cr>
function! V_DoW()
	let g:lx = line('.')
	let g:ly = col('.')
	if g:pseudo_visual
		execute "normal! \<esc>"
	endif
	if v:false
	\|| charclass(getline(g:lx)[g:ly-1]) ==# 0
	\&& charclass(getline(g:lx)[g:ly]) !=# 0
	\|| charclass(getline(g:lx)[g:ly-1]) ==# 2
	\&& charclass(getline(g:lx)[g:ly]) !=# 2
	\|| charclass(getline(g:lx)[g:ly-1]) !=# 2
	\&& charclass(getline(g:lx)[g:ly]) ==# 2
	\|| g:ly ==# col('$')
		normal! l
	endif
	if g:pseudo_visual
		normal! v
	endif
	normal! wh
	let g:rx = line('.')
	let g:ry = col('.')
endfunction
xnoremap w <cmd>call V_DoW()<cr>
function! V_DoWWhole()
	if g:pseudo_visual
		execute "normal! \<esc>wviW"
	else
		normal! W
	endif
endfunction
xnoremap W <cmd>call V_DoWWhole()<cr>
function! V_DoE()
	let g:lx = line('.')
	let g:ly = col('.')
	if g:pseudo_visual
		execute "normal! \<esc>ve"
		if getline(g:lx)[g:ly] ==# ''
			execute "normal! ollo"
		elseif v:false
		\|| charclass(getline(g:lx)[g:ly]) !=# 2
		\&& charclass(getline(g:lx)[g:ly-1]) ==# 2
		\|| charclass(getline(g:lx)[g:ly-1]) !=# 2
		\&& charclass(getline(g:lx)[g:ly]) ==# 2
		\|| charclass(getline(g:lx)[g:ly]) ==# 0
		\&& charclass(getline(g:lx)[g:ly-1]) !=# 0
			execute "normal! olo"
		else
			execute
		endif
	else
		execute "normal! e"
	endif
	let g:rx = line('.')
	let g:ry = col('.')
endfunction
xnoremap e <cmd>call V_DoE()<cr>
function! V_DoEWhole()
	let old_c = col('.')
	let old_l = line('.')
	if g:pseudo_visual
		execute "normal! ".MoveRight(old_l, old_c, g:rx, g:ry)."\<esc>lvE"
"		execute "normal! ".MoveRight(g:lx, g:ly, g:rx, g:ry)."\<esc>lvE"
		if getline(line('.'))[old_c] ==# ''
			execute "normal! olo"
		elseif v:false
		\|| getline(line('.'))[old_c] ==# ' '
			execute
		elseif old_l ==# line('.')
			execute "normal! oho"
		else
			execute "normal! olo"
		endif
	else
		execute "normal! E"
	endif
	call SavePosition(old_c, old_l, col('.'), line('.'))
	call ReorderRightLeft()
endfunction
xnoremap E <cmd>call V_DoEWhole()<cr>
function! V_DoB()
	let g:rx = line('.')
	let g:ry = col('.')
	if g:pseudo_visual
		execute "normal! \<esc>vb"
		if getline(g:rx)[g:ry-2] ==# ''
			execute "normal! ohho"
		elseif v:false
		\|| charclass(getline(g:rx)[g:ry-1]) !=# 2
		\&& (v:false
		\|| charclass(getline(g:rx)[g:ry-2]) ==# 2
		\|| charclass(getline(g:rx)[g:ry-2]) ==# 0
		\)
		\|| charclass(getline(g:rx)[g:ry-2]) !=# 2
		\&& charclass(getline(g:rx)[g:ry-1]) ==# 2
			execute "normal! oho"
		else
			execute
		endif
	else
		execute "normal! b"
	endif
	let g:lx = line('.')
	let g:ly = col('.')
endfunction
xnoremap b <cmd>call V_DoB()<cr>
function! V_DoBWhole()
	let old_c = col('.')
	let old_l = line('.')
	if g:pseudo_visual
		execute "normal! ".MoveLeft(g:lx, g:ly, g:rx, g:ry)."\<esc>hvB"
		if getline(line('.'))[old_c - 2] ==# ''
			execute "normal! olo"
		elseif v:false
		\|| getline(line('.'))[old_c - 2] ==# ' '
			execute
		elseif old_l ==# line('.')
			execute "normal! olo"
		else
			execute "normal! oho"
		endif
	else
		execute "normal! B"
	endif
	call SavePosition(old_c, old_l, col('.'), line('.'))
	call ReorderRightLeft()
endfunction
xnoremap B <cmd>call V_DoBWhole()<cr>
function! V_DoC()
	if !&modifiable
		echohl ErrorMsg
		echomsg "extra.nvim: V_DoC: file is not modifiable"
		echohl Normal
		return
	endif
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft(line('.'), col('.'), g:lx, g:ly)
	normal! o
	let rxlen = strlen(getline(g:rx))
	call SetYankMode()
	normal! d
	if v:false
	elseif v:false
	\|| g:ly !=# 1
	\|| g:ry !=# rxlen + 1
		startinsert
	else
		normal! O
		call feedkeys("\"_cc", 'n')
	endif
endfunction
xnoremap c <cmd>call V_DoC()<cr>
let g:yank_mode = "char"
function! V_DoY()
	let register = v:register
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft(line('.'), col('.'), g:lx, g:ly)
	normal! o
	call SetYankMode()

	if v:false
	elseif v:false
	\|| g:yank_mode ==# "char"
		execute "normal! \"".register."y"
	elseif v:false
	\|| g:yank_mode ==# "line"
	\|| g:yank_mode ==# "line_post"
		execute "normal! \<esc>mzgv`z\"".register."y"
	else
		echohl ErrorMsg
		echomsg "extra.nvim: V_DoY: Internal error: wrong yank mode: ".g:yank_mode
		echohl Normal
	endif

	execute "normal! gv"
	let g:pseudo_visual = v:true

	if mode() ==# "\<c-v>"
		let g:visual_mode = "block"
		let startcol = getpos("'<")[2]
		let endcol = getpos("'>")[2]
		if col('.') !=# (startcol>#endcol?startcol:endcol)
			execute "normal! O"
		endif
	else
		let g:visual_mode = "char"
	endif
endfunction
xnoremap y <cmd>call V_DoY()<cr>
nunmap ;
if !has('nvim') || !PluginInstalled('sneak')
	xnoremap ; <esc>
else
	xnoremap ; <esc><cmd>call timer_start(0, {->SneakCancel()})<cr>
endif
function! N_DoSemicolon()
	if !&modifiable
		return
	endif
	let linenr = line('.')
	let col = col('$')
	let line = getline(linenr)
	let len = len(line)
	if len <# 1
		normal! A;
		return
	endif
	if line[len-1] !=# ';'
		normal! A;
	else
		call setline(linenr, substitute(line, ';\+$', '', ''))
	endif
endfunction
nnoremap ; mz<cmd>call N_DoSemicolon()<cr>`z
xnoremap o <esc>o
xnoremap O <esc>O
xnoremap <leader>xo o<cmd>call ReorderRightLeft()<cr>
xnoremap <leader>xO O<cmd>call ReorderRightLeft()<cr>
nnoremap C <c-v>j
xnoremap C j
nnoremap , <nop>
xnoremap , <esc>
nnoremap <c-s> m'
nnoremap U <c-r>
nnoremap g. g;
function! V_DoUndo()
	if g:pseudo_visual
		undo
		execute "normal! \<c-\>\<c-n>"
	else
		normal! ugv
		let g:pseudo_visual = v:true
	endif
endfunction
xnoremap u <cmd>call V_DoUndo()<cr>
function! V_DoRedo()
	if g:pseudo_visual
		redo
		execute "normal! \<c-\>\<c-n>"
	else
		normal! Ugv
		let g:pseudo_visual = v:true
	endif
endfunction
xnoremap U <cmd>call V_DoRedo()<cr>
noremap <a-.> ;
noremap % <cmd>if v:count==#0<bar>call SelectAll()<bar>else<bar>execute "normal! ".v:count1."%"<bar>endif<cr>
if g:compatible =~# "^helix_hard"
	nnoremap * <cmd>let c=getline(line('.'))[col('.')-1]<bar>let @/=c<bar>echomsg "register '/' set to '".c."'"<cr>
	unmap q
	unmap Q
	noremap q <cmd>if v:register==#'"'<bar>execute "normal! @q"<bar>else<bar>execute "normal! @".v:register<bar>endif<bar>let g:no_currently_selected_register = v:true<cr>
	noremap Q <cmd>if v:register==#'"'<bar>execute "normal! qq"<bar>else<bar>execute "normal! q".v:register<bar>endif<bar>let g:no_currently_selected_register = v:true<cr>
endif
nnoremap [<space> mzO<esc>`z
xnoremap [<space> mz<esc>O<esc>`z
nnoremap ]<space> mzo<esc>`z
xnoremap ]<space> mz<esc>o<esc>`zgv
if len(maparg('<leader>cc')) !=# 0
	unmap <leader>cc
endif
if len(maparg('<leader>cn')) !=# 0
	unmap <leader>cn
endif

noremap : <cmd>let mode=mode()<cr><c-\><c-n><cmd>call V_Do_Colon(mode)<cr>:<c-u>

function! V_Do_CtrlU()
	if g:pseudo_visual
		execute "normal! \<c-\>\<c-n>"
	endif
	execute "normal! \<c-u>"
endfunction
xnoremap <c-u> <cmd>call V_Do_CtrlU()<cr>

if !PluginInstalled('endscroll')
	function! V_Do_CtrlD()
		if g:pseudo_visual
			execute "normal! \<c-\>\<c-n>"
		endif
		execute "normal! \<c-d>"
	endfunction
	xnoremap <c-u> <cmd>call V_Do_CtrlD()<cr>
endif

nnoremap <leader>f <cmd>call FuzzyFind()<cr>
nnoremap <leader>F <cmd>call FuzzyFind()<cr>
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
xnoremap <leader>y y
xnoremap <leader>Y y
nnoremap <leader>R <cmd>for i in range(line("'>")-line("'<"))<bar>let l=line("'<")+i<bar>call setline(l,substitute(getline(l),getreg('x')))<bar>endfor<cr>
nnoremap <leader>xr <cmd>call OpenRangerCheck()<cr>
nnoremap <leader>k K
nnoremap <leader>r <Plug>(coc-rename)
nnoremap <leader><c-c> <cmd>Telescope commands<cr>

nnoremap <c-w>nv <cmd>vsplit<bar>enew<cr>
nnoremap <c-w>n<c-v> <cmd>vsplit<bar>enew<cr>
nnoremap <c-w>ns <cmd>split<bar>enew<cr>
nnoremap <c-w>n<c-s> <cmd>split<bar>enew<cr>
