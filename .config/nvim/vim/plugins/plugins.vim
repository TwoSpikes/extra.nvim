" Install vim-plug if not found
if has('nvim')
	if !filereadable(g:LOCALSHAREPATH . '/site/autoload/plug.vim')
		!curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/TwoSpikes/plugnplay.vim/master/plug.vim
	endif
else
	if !filereadable(expand('~/.vim/autoload/plug.vim'))
		!curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/TwoSpikes/plugnplay.vim/master/plug.vim
	endif
endif

call plug#begin()

Plug 'nvim-tree/nvim-web-devicons'
Plug 'goolord/alpha-nvim'

call plug#end()

if PluginInstalled('alpha')
	execute 'luafile' g:PLUGINS_SETUP_PATH.'/alpha/setup.lua'
endif

function! OpenOnStart()
	if g:open_menu_on_start
		call RebindMenus()
		autocmd User ExNvimLoaded call timer_start(50, {->quickui#menu#nvim_open_menu({"name": "system", "next": 1})})
	endif

	if argc() <= 0 && expand('%') == '' || isdirectory(expand('%'))
		let to_open = 1
		let to_open *= !g:DO_NOT_OPEN_ANYTHING
		let to_open *= !g:PAGER_MODE
		if to_open
			if g:open_on_start ==# 'alpha' && !isdirectory(expand('%')) && PluginInstalled('alpha')
				lua require('alpha').start()
			elseif v:false
			\|| g:open_on_start ==# "explorer"
			\|| !has('nvim') && g:open_on_start ==# 'alpha'
			\|| g:open_on_start !=# "ranger"
				edit ./
			elseif g:open_on_start ==# "ranger"
				if argc() ># 0
					call timer_start(0, {->OpenRanger(argv(0))})
				else
					call timer_start(0, {->OpenRanger("./")})
				endif
			endif
		endif
	endif
endfunction
function! JKWorkaroundAlpha()
	noremap <buffer> j <cmd>call ProcessGBut('j')<cr>
	noremap <buffer> k <cmd>call ProcessGBut('k')<cr>
	if !g:open_cmd_on_up
		noremap <buffer> <up> <cmd>call ProcessGBut('k')<cr>
	endif
	noremap <buffer> <down> <cmd>call ProcessGBut('j')<cr>
endfunction
call OpenOnStart()
mode

let g:plug_patch_dir = $HOME.'/.config/nvim/patch'

call plug#begin()

Plug 'nvim-tree/nvim-web-devicons'
Plug 'goolord/alpha-nvim'

Plug 'justinmk/vim-sneak'

Plug 'skywind3000/vim-quickui'

Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'folke/noice.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'mfussenegger/nvim-lint'
Plug 'smartpde/telescope-recent-files'

Plug 'TwoSpikes/endscroll.nvim'

Plug 'declancm/cinnamon.nvim'

Plug 'nvimtools/none-ls-extras.nvim'
Plug 'nvimtools/none-ls.nvim'

Plug 'stevearc/conform.nvim'

Plug 'cjodo/convert.nvim'

Plug 'windwp/nvim-ts-autotag'

Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'

Plug 'sindrets/diffview.nvim'

Plug 'folke/trouble.nvim'

Plug 'L3MON4D3/LuaSnip', { 'tag': 'v2.*', 'build': 'make install_jsregexp' }

Plug 'kevinhwang91/nvim-bqf', { 'for': 'qf' }

Plug 'nvim-lua/popup.nvim'
Plug 'RishabhRD/lspactions'

Plug 'nvim-treesitter/nvim-treesitter', { 'do': 'TSUpdate' }
Plug 'nvim-treesitter/playground'

Plug 'weizheheng/nvim-workbench'

Plug 'norcalli/nvim-colorizer.lua'

Plug 'prichrd/netrw.nvim'

if g:enable_which_key
	Plug 'folke/which-key.nvim'
endif

if g:enable_nvim_treesitter_context
	Plug 'nvim-treesitter/nvim-treesitter-context'
endif

if !g:use_nvim_cmp
	Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'npm ci' }
endif

Plug 'nvim-pack/nvim-spectre'

Plug 'vim-jp/vital.vim'

Plug 'RRethy/vim-illuminate'

Plug 'folke/todo-comments.nvim'

Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'mfussenegger/nvim-dap-python'
Plug 'leoluz/nvim-dap-go'
Plug 'mfussenegger/nvim-jdtls'

Plug 'scalameta/nvim-metals'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'lewis6991/gitsigns.nvim'

Plug 'olimorris/persisted.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'Julian/lean.nvim'

Plug 'tommcdo/vim-lion'

Plug 'lyokha/vim-xkbswitch'

Plug 'danymat/neogen'

Plug 'folke/yanky.nvim'

Plug 'neoclide/vim-jsx-improve'

Plug 'voldikss/vim-floaterm'

Plug 'vim-utils/vim-man'

Plug 'tpope/vim-surround'

Plug 'alvan/vim-closetag'

Plug 'yuezk/vim-js'

Plug 'maxmellon/vim-jsx-pretty'

Plug 'kmoschcau/emmet-vim'

if g:use_github_copilot
	Plug 'github/copilot.vim'
endif

Plug 'erietz/vim-terminator'

Plug 'tpope/vim-fugitive'

Plug 'mg979/vim-visual-multi', { 'branch': 'master' }

Plug 'folke/edgy.nvim'

Plug 'echasnovski/mini.bracketed'

Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v3.x' }

if g:use_codeium
	Plug 'Exafunction/codeium.vim'
endif

Plug 'TwoSpikes/music-player.vim'

if g:compatible !~# '^helix'
	Plug 'airblade/vim-gitgutter'
endif

if g:enable_beacon
	Plug 'danilamihailov/beacon.nvim'
endif

Plug 'm-demare/hlargs.nvim'

Plug 'RaafatTurki/hex.nvim'

if has('nvim')
	Plug 'TwoSpikes/pkgman.nvim'
endif

Plug 'TwoSpikes/ani-cli.nvim'

Plug 'TwoSpikes/hlchunk.nvim'

Plug 'jinzhongjia/LspUI.nvim'

if has('gui_running')
	Plug 'Thiago4532/mdmath.nvim'
endif

Plug 'roobert/activate.nvim'

Plug 'abecodes/tabout.nvim'

if g:enable_scrollview
	Plug 'dstein64/nvim-scrollview'
endif

Plug 'kwkarlwang/bufresize.nvim'

Plug 'junegunn/goyo.vim'

Plug 'junegunn/limelight.vim'

Plug 'rust-lang/rust.vim'

Plug 'preservim/tagbar'

call plug#end()

" Run PlugInstall if there are missing plugins
autocmd User ExNvimLoaded if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall
\| endif

autocmd User ExNvimLoaded if &filetype ==# "alpha"
	\| AlphaRedraw
	\| AlphaRemap
\| endif
