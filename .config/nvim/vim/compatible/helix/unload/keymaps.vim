unlet g:pseudo_visual
unlet g:yank_mode
unlet g:visual_mode

unlet g:lx
unlet g:ly
unlet g:rx
unlet g:ry

delfunction Do_V_0
nunmap gh
xunmap gh
nunmap 0
xunmap 0
delfunction Do_V_Dollar
nunmap gl
nunmap $
delfunction Fix_NPV_Dollar
xunmap gl
xunmap $

xunmap ge
xunmap G

nunmap ge
nunmap gs
xunmap gs
xunmap gg

delfunction ExitVisual
delfunction CollapseVisual

delfunction Do_N_D
nunmap d
delfunction PV
delfunction SetYankMode
delfunction V_DoD
xunmap d
delfunction N_DoX_Define
if exists('*N_DoX')
	delfunction N_DoX
endif
nunmap x
nunmap X
xunmap ~
delfunction ChangeVisModeBasedOnSelectedText
delfunction SimulateCorrectPasteMode
nunmap p
nunmap P
xunmap p
xunmap P
nunmap gp
nunmap gP
xunmap gp
xunmap gP
nunmap c
nunmap q
nunmap Q
xunmap q
xunmap Q
if !g:use_nvim_cmp && has('nvim')
	noremap ySS <Plug>YSsurround
	noremap ySs <Plug>YSsurround
	noremap yss <Plug>Yssurround
	noremap yS <Plug>YSurround
	noremap ys <Plug>Ysurround
	noremap y<c-g> :<c-u>call setreg(v:register, fugitive#Object(@%))<cr>
endif
nunmap y
delfunction Do_N_T_Cr
nunmap t<cr>
nunmap mm
xunmap mm
iunmap <c-x>
iunmap <c-p>
nunmap <a-o>
nunmap <a-.>
xunmap R
delfunction Do_N_R
nunmap r
delfunction Do_V_R
xunmap r
nunmap ~
nunmap >
nunmap <
xunmap <
xunmap >
if has('nvim') && PluginExists('vim-sneak')
	delfunction SneakCancel
	if maparg('f<Esc>', 'x') !=# ''
		xunmap f<esc>
		xunmap F<esc>
	endif
	if maparg('t<Esc>', 'x') !=# ''
		xunmap t<esc>
		xunmap T<esc>
	endif
	if maparg('s<Esc>', 'x') !=# ''
		xunmap s<esc>
		xunmap S<esc>
		xunmap gw<esc>
		xunmap gW<esc>
	endif
	if maparg('t<Cr>', 'x') !=# ''
		xunmap t<cr>
	endif
	delfunction V_DoT_Cr
	if maparg('<esc>', 'n') =~# "'s'\\.'neak#cancel'"
		silent! unmap <esc>
	endif
	nunmap f<esc>
	nunmap F<esc>
	nunmap t<esc>
	nunmap T<esc>
	nunmap s<esc>
	nunmap S<esc>
	nunmap gw<esc>
	nunmap gW<esc>
	autocmd! Sneak_Esc_Workaround *
	nunmap f
	nunmap F
	nunmap t
	nunmap T
	nunmap s
	nunmap S
	xunmap f
	xunmap F
	xunmap t
	xunmap T
	delfunction V_DoSneak_S
	delfunction V_DoSneak_Gw
	xunmap s
	xunmap S
	unlet g:sneak_mode
	unlet g:first_sneak
endif
if !g:use_nvim_cmp
	if has('nvim') && PluginExists('vim-surround')
		noremap cS <Plug>CSurround
		noremap cs <Plug>Csurround
	endif
endif
nnoremap <silent> dd ddk
if has('nvim') && PluginExists('vim-surround')
	noremap ds <Plug>Dsurround
endif
delfunction ReorderRightLeft
delfunction SavePosition
delfunction N_DoW
nunmap w
delfunction N_DoE
nunmap e
delfunction N_DoB
nunmap b
nunmap W
delfunction N_DoEWhole
nunmap E
delfunction N_DoBWhole
nunmap B
noremap <esc> <cmd>let @/=""<cr>
delfunction N_DoV
nunmap v
delfunction N_DoVLine
nunmap V
nunmap <c-v>
delfunction V_DoV
xunmap v
delfunction V_DoVLine
xunmap V
delfunction V_DoVBlock
xunmap <c-v>
xunmap <esc>
delfunction MoveLeft
xunmap i
delfunction MoveRight
xnoremap a% <Plug>(MatchitVisualTextObject)
xunmap a
delfunction V_DoS
delfunction V_DoX
xunmap x
delfunction V_DoXDoNotExtendSubsequentLines
xunmap X
delfunction V_DoH
xunmap h
xunmap <left>
delfunction V_DoL
xunmap l
xunmap <right>
delfunction V_DoW
xunmap w
delfunction V_DoWWhole
xunmap W
delfunction V_DoE
xunmap e
delfunction V_DoEWhole
xunmap E
delfunction V_DoB
xunmap b
delfunction V_DoBWhole
xunmap B
delfunction V_DoC
xunmap c
delfunction V_DoY
xunmap y
xunmap ;
delfunction N_DoSemicolon
nunmap ;
xunmap o
xunmap O
xunmap <leader>xo
xunmap <leader>xO
nunmap C
xunmap C
nunmap ,
xunmap ,
nunmap <c-s>
nunmap U
nunmap g.
delfunction V_DoUndo
xunmap u
delfunction V_DoRedo
xunmap U
unmap <a-.>
unmap %
if g:compatible =~# "^helix_hard"
	nunmap *
	unmap q
	unmap Q
	noremap <silent> q <cmd>q<cr>
	noremap <silent> Q <cmd>q!<cr>
endif
nunmap [<space>
xunmap [<space>
nunmap ]<space>
xunmap ]<space>
if PluginInstalled('convert')
	exec "source" stdpath('config')."/lua/packages/convert/keymaps.vim"
	xnoremap <leader>c <c-\><c-n><cmd>call X_CommentOutDefault()<cr>
	nnoremap <leader>c <cmd>call N_CommentOutDefault()<cr>
endif

unmap :

delfunction V_Do_CtrlU
xunmap <c-u>

if !PluginInstalled('endscroll')
	delfunction V_Do_CtrlD
	xunmap <c-d>
endif

nunmap <leader>f
if !g:use_nvim_cmp
	nnoremap <silent> <leader>fr <cmd>lua require('telescope').extensions.recent_files.pick()<cr>
	nnoremap <silent> <leader>fh :lua require('telescope.builtin').help_tags(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
	nnoremap <silent> <leader>fb :lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
	nnoremap <silent> <leader>fg :lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown({winblend = 0 }))<cr>
	nnoremap <silent> <leader>ff <cmd>call FuzzyFind()<cr>
endif
nunmap <leader>F
nunmap <leader>j
nunmap <leader>s
nunmap <leader>S
nunmap <leader>d
nunmap <leader>D
nunmap <leader>ww
nunmap <leader>w<c-w>
nunmap <leader>ws
nunmap <leader>w<c-s>
nunmap <leader>wv
nunmap <leader>w<c-v>
nunmap <leader>wt
nunmap <leader>w<c-t>
nunmap <leader>wf
nunmap <leader>wF
nunmap <leader>wq
nunmap <leader>w<c-q>
nunmap <leader>wo
nunmap <leader>w<c-o>
nunmap <leader>wh
nunmap <leader>w<c-h>
nunmap <leader>wj
nunmap <leader>w<c-j>
nunmap <leader>wk
nunmap <leader>w<c-k>
nunmap <leader>wl
nunmap <leader>w<c-l>
nunmap <leader>w<left>
nunmap <leader>w<down>
nunmap <leader>w<up>
nunmap <leader>w<right>
nunmap <leader>wH
nunmap <leader>wJ
nunmap <leader>wK
nunmap <leader>wL
nunmap <leader>y
nunmap <leader>Y
xunmap <leader>y
xunmap <leader>Y
nunmap <leader>R
nunmap <leader>xr
nunmap <leader>k
nunmap <leader>r
nunmap <leader><c-c>
