hi Loading ctermfg=0 ctermbg=10 cterm=bold guifg=#303030 guibg=#ffff9f gui=bold
hi ExNvimLogo ctermfg=214 ctermbg=0 cterm=NONE guifg=#ffaa00 guibg=NONE
if g:show_ascii_logo
	hi ExNvimLogo gui=bold
else
	hi ExNvimLogo gui=bold,italic
endif
hi QuickTip ctermfg=202 ctermbg=85 cterm=bold guifg=#ffff9f guibg=#0f8fff gui=bold
if !IsHighlightGroupDefined('Statuslinemod')
	hi Statuslinemod guifg=#f0f0ff guibg=#0080a0 gui=bold
endif
if !IsHighlightGroupDefined('MultiCursor')
	hi MultiCursor ctermfg=0 ctermbg=48 cterm=NONE guifg=#000000 guibg=#00ffaa gui=NONE
endif
