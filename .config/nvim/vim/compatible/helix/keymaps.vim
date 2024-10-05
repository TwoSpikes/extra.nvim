" Files of hcm (Helix compatibility mode)

"" LEGEND
" hcm: Helix compatibility mode
" Text*: text and any number of symbols after it (template to match function name)
" Do_V_*, V_Do_*: xnoremap action
" N_Do_*: nnoremap action
" *_NPV_*: non-pseudo visual mode action
" *_PV_*: pseudo visual mode action

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

nnoremap ge G
nnoremap gs ^
xnoremap gs ^
xnoremap gg <cmd>
\if g:pseudo_visual<bar>
\execute "normal! v"<bar>
\endif<bar>
\call feedkeys(v:count."gg", "n")
\<cr>

if g:compatible ==# "helix_hard"
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

set notildeop
let &whichwrap="b,s,h,l,<,>,~,[,]"
set virtualedit=onemore

nnoremap d x
function! PV()
	normal! gv
	let g:pseudo_visual = v:true
endfunction
function! PV_x()
	execute "normal! ".N_DoX()
	let g:pseudo_visual = v:true
endfunction
function! SetYankMode()
	if v:false
	elseif v:false
	\|| g:ly ==# len(getline(g:lx))+1
	\&& g:ry ==# len(getline(g:rx))+1
		let g:yank_mode = "line"
	elseif v:true
	\&& (v:false
	\|| g:ry ==# len(getline(g:rx))
	\|| g:ry ==# len(getline(g:rx))+1
	\|| v:false)
	\&& g:ly ==# 1
		let g:yank_mode = "line_post"
	else
		let g:yank_mode = "char"
	endif
endfunction
function! V_DoD()
	let register = v:register
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft()
	normal! o
	call SetYankMode()
	execute "normal! \"".register."d"
endfunction
xnoremap d <cmd>call V_DoD()<cr>
function! N_DoX()
	let result = ""
	let result .= "v"
	let result .= "0o$"
	let g:pseudo_visual=v:true
	let g:visual_mode="char"
	return result
endfunction
nnoremap <expr> x N_DoX()
nnoremap <expr> X N_DoX()
xnoremap u ugv
xnoremap U Ugv
xnoremap ~ <c-\><c-n><cmd>call Do_V_Tilde()<bar>execute "normal! gv"<bar>let g:pseudo_visual=v:true<bar>execute "Showtab"<cr>
function! ChangeVisModeBasedOnSelectedText()
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft()
	normal! o
	if v:false
	\|| g:ly !=# 1
	\|| g:ry <# strlen(getline(g:rx))
	else
		echomsg "YES"
		if mode() !~# 'V'
			call feedkeys("V")
		endif
	endif
endfunction
function! SimulateCorrectPasteMode(cmd, register)
	if v:false
	elseif v:false
	\|| g:yank_mode ==# 'char'
		if v:false
		elseif a:cmd ==# '$'
			let paste_cmd = 'p'
		elseif a:cmd ==# '0'
			let paste_cmd = 'P'
		else
			echohl ErrorMsg
			echomsg "extra.nvim: hcm: SimulateCorrectPasteMode: Internal error: wrong a:cmd: ".a:cmd
			echohl Normal
		endif
	elseif g:yank_mode ==# "line"
		execute "normal! ".a:cmd
		if v:false
		elseif a:cmd ==# '$'
			let paste_cmd = 'p'
		elseif a:cmd ==# '0'
			let paste_cmd = 'P'
		else
			echohl ErrorMsg
			echomsg "extra.nvim: hcm: SimulateCorrectPasteMode: Internal error: wrong a:cmd: ".a:cmd
			echohl Normal
		endif
	elseif g:yank_mode ==# "line_post"
		if v:false
		elseif a:cmd ==# '$'
			execute "normal! j0"
			let paste_cmd = 'P'
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

	execute "normal! \"".a:register.paste_cmd
endfunction
nnoremap p <cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('$', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>if g:compatible==#"helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
nnoremap P <cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('0', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>if g:compatible==#"helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
xnoremap p <esc><cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('$', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>if g:compatible==#"helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
xnoremap P <esc><cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('0', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>if g:compatible==#"helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
nnoremap gp <cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('$', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>exe"norm! o"<bar>if g:compatible==#"helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
nnoremap gP <cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('0', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>exe"norm! o"<bar>if g:compatible==#"helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
xnoremap gp <esc><cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('$', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>exe"norm! o"<bar>if g:compatible==#"helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
xnoremap gP <esc><cmd>if &modifiable<bar>let register=v:register<bar>call SimulateCorrectPasteMode('0', register)<bar>exe"norm! `[v"<bar>let g:visual_mode="char"<bar>exe"norm! `]"<bar>call ChangeVisModeBasedOnSelectedText()<bar>exe"norm! o"<bar>if g:compatible==#"helix_hard"<bar>let g:no_currently_selected_register = v:true<bar>endif<bar>let g:pseudo_visual=v:true<bar>exe"Showtab"<bar>endif<cr>
nnoremap c xi
if !g:use_nvim_cmp
	if has('nvim')
		if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/vim-surround")
			unmap ySS
			unmap ySs
			unmap yss
			unmap yS
			unmap ys
			unmap y<c-g>
		endif
	endif
endif
nnoremap y <cmd>let register=v:register<bar>exe"norm! v\"".register."y"<cr>
nnoremap t<cr> v$
nnoremap mm %
xnoremap mm %
nnoremap <c-c> <cmd>call CommentOutDefault<cr>
inoremap <c-x> <c-p>
inoremap <c-p> <c-x>
nnoremap <a-o> viw
nnoremap <a-.> ;
xnoremap R "_dP
nnoremap ~ <cmd>call Do_N_Tilde()<cr>
nnoremap > >>
nnoremap < <<
xnoremap < <gv<cmd>let g:pseudo_visual=v:true<cr>
xnoremap > >gv<cmd>let g:pseudo_visual=v:true<cr>
xnoremap t<cr> $
if !g:use_nvim_cmp
	if has('nvim')
		if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/vim-surround")
			unmap cS
			unmap cs
		endif
	endif
	unmap ci_
endif
unmap dd
if has('nvim')
	if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/vim-surround")
		unmap ds
	endif
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
xnoremap <expr> : g:pseudo_visual?":\<c-u>":":"
nnoremap w <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>execute "normal! v".v:count1."e"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:visual_mode="char"<cr><cmd>call ReorderRightLeft()<cr>
nnoremap e <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>execute "normal! v".v:count1."e"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:visual_mode="char"<cr><cmd>call ReorderRightLeft()<cr>
nnoremap b <cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>execute "normal! v".v:count1."b"<bar>let g:lx=line('.')<bar>let g:ly=col('.')<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:visual_mode="char"<cr><cmd>call ReorderRightLeft()<cr>
nnoremap W <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>execute "normal! v".v:count1."W"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:visual_mode="char"<cr><cmd>call ReorderRightLeft()<cr>
nnoremap E <cmd>let g:lx=line('.')<bar>let g:ly=col('.')<bar>execute "normal! v".v:count1."E"<bar>let g:rx=line('.')<bar>let g:ry=col('.')<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:visual_mode="char"<cr><cmd>call ReorderRightLeft()<cr>
nnoremap B <cmd>let g:rx=line('.')<bar>let g:ry=col('.')<bar>execute "normal! v".v:count1."B"<bar>let g:lx=line('.')<bar>let g:ly=col('.')<cr><cmd>let g:pseudo_visual = v:true<cr><cmd>let g:visual_mode="char"<cr><cmd>call ReorderRightLeft()<cr>
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
xnoremap <expr> i MoveLeft()."\<esc>i"
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
		return ""
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
unmap a%
xnoremap <expr> a ReorderRightLeft().MoveRight()."\<esc>a"
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
		execute "VMSearch" select
		for _ in range(cnt-1)
			call vm#commands#find_next(v:false, v:false)
		endfor
	endif
endfunction
xnoremap s <cmd>call V_DoS()<cr>
function! V_DoX()
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft()
	normal! o
	if v:false
	\|| g:ly !=# 1
	\|| g:ry <# strlen(getline(g:rx))
		normal! o0o$
	else
		normal! j$
	endif
endfunction
xnoremap x <cmd>call V_DoX()<cr>
function! V_DoXDoNotExtendSubsequentLines()
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft()
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
		execute "normal! \<esc>"
		let i=0
		while i<#a:c
			normal! h
			let i+=1
		endwhile
	else
		let old_l=line('.')
		let old_c=col('.')
		let i=0
		while i<#a:c
			normal! h
			let i+=1
		endwhile
		call ReorderRightLeft()
		call SavePosition(old_c, old_l, col('.'), line('.'))
	endif
endfunction
xnoremap h <cmd>call V_DoH(v:count1)<cr>
xnoremap <left> <cmd>call V_DoH(v:count1)<cr>
function! V_DoL(c)
	if g:pseudo_visual
		execute "normal! \<esc>"
		let i=0
		while i<#a:c
			normal! l
			let i+=1
		endwhile
	else
		let old_c = col('.')
		let old_l = line('.')
		let i=0
		while i<#a:c
			normal! l
			let i+=1
		endwhile
		call ReorderRightLeft()
		call SavePosition(old_c, old_l, col('.'), line('.'))
	endif
endfunction
xnoremap l <cmd>call V_DoL(v:count1)<cr>
xnoremap <right> <cmd>call V_DoL(v:count1)<cr>
function! V_DoW()
	if g:pseudo_visual
		execute "normal! \<esc>wviw"
	else
		normal! w
	endif
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
	if g:pseudo_visual
		execute "normal! \<esc>eviw"
	else
		normal! e
	endif
endfunction
xnoremap e <cmd>call V_DoE()<cr>
function! V_DoEWhole()
	if g:pseudo_visual
		execute "normal! \<esc>wviW"
	else
		normal! E
	endif
endfunction
xnoremap E <cmd>call V_DoEWhole()<cr>
function! V_DoB()
	if g:pseudo_visual
		execute "normal! \<esc>hviwo"
	else
		normal! b
	endif
endfunction
xnoremap b <cmd>call V_DoB()<cr>
function! V_DoBWhole()
	if g:pseudo_visual
		execute "normal! \<esc>hviW"
	else
		execute "normal! B"
	endif
endfunction
xnoremap B <cmd>call V_DoBWhole()<cr>
function! V_DoC()
	let g:lx = line('.')
	let g:ly = col('.')
	normal! o
	let g:rx = line('.')
	let g:ry = col('.')
	normal! o
	call ReorderRightLeft()
	execute "normal! ".MoveLeft()
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
	execute "normal! ".MoveLeft()
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
unmap ;
nnoremap ; <nop>
xnoremap ; <esc>
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
		execute "normal! \<c-r>gv"
		let g:pseudo_visual = v:true
	endif
endfunction
xnoremap U <cmd>call V_DoRedo()<cr>
noremap <a-.> ;
noremap % <cmd>if v:count==#0<bar>call SelectAll()<bar>else<bar>execute "normal! ".v:count1."%"<bar>endif<cr>
if g:compatible ==# "helix_hard"
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
nnoremap <c-c> <cmd>call CommentOutDefault()<cr>
if isdirectory(g:LOCALSHAREPATH."/site/pack/packer/start/convert.nvim")
	unmap <leader>cc
	unmap <leader>cn
endif

if !g:use_nvim_cmp
	unmap <leader>fr
	unmap <leader>fh
	unmap <leader>fb
	unmap <leader>fg
	unmap <leader>ff
endif
nnoremap <leader>f <cmd>call FuzzyFind()<cr>
nnoremap <leader>F <cmd>call FuzzyFind()<cr>
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
xnoremap <leader>y y
xnoremap <leader>Y y
nnoremap <leader>R <cmd>for i in range(line("'>")-line("'<"))<bar>let l=line("'<")+i<bar>call setline(l,substitute(getline(l),getreg('x')))<bar>endfor<cr>
nnoremap <leader>xr <cmd>call OpenRangerCheck()<cr>
nnoremap <leader>k K
nnoremap <leader>r <Plug>(coc-rename)
nnoremap <leader><c-c> <cmd>Telescope commands<cr>
