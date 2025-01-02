let reloading=exists('g:COMPATIBLE_ALREADY_LOADED')
let g:COMPATIBLE_ALREADY_LOADED = v:true

" Random options
set termguicolors
set encoding=utf-8
set helpheight=10
set splitbelow
set splitkeep=cursor
set nosplitright
set scrolloff=3
set notildeop
set errorfile=errors.err
set eventignore=
set noexrc
set fillchars=
set fixendofline
if !reloading
	set cmdheight=1
endif
set smoothscroll

" Bell signal options
set novisualbell
set belloff=all
set errorbells

" Search options
set nogdefault
set ignorecase
set smartcase
set incsearch
set magic

" Fold options
set foldclose=all
set foldenable
set foldexpr=0
set foldignore=#
set foldlevel=0
set foldmarker={{{,}}}
set foldmethod=marker
set foldnestmax=15
set foldcolumn=0

set signcolumn=auto

" Menus options
set showcmd
set showcmdloc=statusline
set laststatus=2

" Edit options
set hidden
set nowrap
set nolinebreak
let &breakat = "    !¡@*-+;:,./?¿{}[]^%&"
if has('nvim')
	set nolist
else
	set list
endif
set display=lastline
set fcs=lastline:>
set listchars=tab:>\ ,trail:_,nbsp:+
set shortmess=filmnrxwsWItCF
set showtabline=2
set noshowmode
set confirm
set virtualedit=onemore

setlocal nowrap

" Mappings and functions options
set matchpairs=(:),{:},[:],<:>
set noshowmatch
set matchtime=2
set maxfuncdepth=50
set maxmempattern=500
set history=10000
set modelineexpr
set updatetime=300
set timeout
set timeoutlen=500
set nottimeout
set ttimeoutlen=750

" Mouse options
set cursorlineopt=screenline,number
function! SetMouse()
	if g:enable_mouse
		set mouse=a
	else
		set mouse=
	endif
endfunction
call SetMouse()
let &mousefocus = g:mouse_focus
set nomousehide
set mousemodel=popup_setpos
set nomousemoveevent
if has('nvim')
	set mousescroll=ver:3,hor:6
endif
set mouseshape=i:beam,r:beam,s:updown,sd:cross,m:no,ml:up-arrow,v:rightup-arrow
set mousetime=400
set startofline

" Conceal options
set concealcursor=nc
set conceallevel=0

" Tab options
set tabstop=4
set shiftwidth=4
set smartindent
set smarttab
set noexpandtab
