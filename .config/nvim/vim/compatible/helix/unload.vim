unlet g:pseudo_visual
unlet g:yank_mode
unlet g:visual_mode
unlet g:sneak_mode

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

nunmap d
delfunction PV
delfunction PV_x
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
nunmap ~
nunmap >
nunmap <
xunmap <
xunmap >
xunmap t<cr>
if !g:use_nvim_cmp
	if has('nvim') && luaeval("plugin_installed(_A[1])", ["vim-surround"])
		noremap cS <Plug>CSurround
		noremap cs <Plug>Csurround
	endif
	nnoremap ci_ yiwct_
endif
nnoremap <silent> dd ddk
if has('nvim') && luaeval("plugin_installed(_A[1])", ["vim-surround"])
	noremap ds <Plug>Dsurround
endif
delfunction ReorderRightLeft
delfunction SavePosition
xunmap :
nunmap w
nunmap e
nunmap b
nunmap W
nunmap E
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
xunmap s
delfunction V_DoX_Define
if exists('*V_DoX')
	delfunction V_DoX
endif
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
nunmap ;
xunmap ;
xnoremap ; <Plug>Sneak_;
nnoremap ; <Plug>Sneak_;
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
if g:compatible ==# "helix_hard"
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
nunmap <c-c>
if luaeval("plugin_installed(_A[1])", ["convert.nvim"])
	exec "source" g:CONFIG_PATH."/lua/packages/convert/keymaps.vim"
	xnoremap <leader>c <c-\><c-n><cmd>call X_CommentOutDefault()<cr>
	nnoremap <leader>c <cmd>call N_CommentOutDefault()<cr>
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
nunmap <leader>b
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
