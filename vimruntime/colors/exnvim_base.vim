hi Loading ctermfg=0 ctermbg=10 cterm=bold guifg=#303030 guibg=#ffff9f gui=bold
hi ExNvimLogo ctermfg=214 ctermbg=0 cterm=NONE guifg=#ffaa00 guibg=NONE
if g:show_ascii_logo
	hi ExNvimLogo gui=bold
else
	hi ExNvimLogo gui=bold,italic
endif
