# Extra.nvim

<img src=https://i.imgur.com/ZmdjS8i.png />

## What is this?

This is NeoVim/Vim configuration

> [!Note]
> 100%-compatible with Termux

<details open><summary>
Screenshots
</summary>

<img src=https://i.imgur.com/5mH5Dko.jpeg width=100px height=222px />
<img src=https://i.imgur.com/4w3YoOV.jpeg width=100px height=222px />
<img src=https://i.imgur.com/WEGmaj0.jpeg width=100px height=222px />
<img src=https://i.imgur.com/tvM6cbs.jpeg width=100px height=222px />
<img src=https://i.imgur.com/4V1da5Q.jpeg width=100px height=222px />
<img src=https://i.imgur.com/Paf2BIr.jpeg width=100px height=222px />

</details>

## Minimal requirements (approximate)

- Free RAM: 60 MiB (minimal), 128 MiB (recommended)
- Free disk space: 278,1 MiB (minimal, including all plugins)
- Internet connection (to download plugins)
- [Nerd Fonts](https://www.nerdfonts.com) (or some symbols will look like squares ("not found" symbol))

## Dependencies

- `neovim` or `vim`
- `nodejs` (for `coc.nvim`)
- `jq` (for `coc.nvim`)
- `git` (to download plugins)
- `grep`
- `ripgrep` (Optional, for `nvim-spectre`)
- `tree-sitter` (Optional)
- `ranger` (Optional)
- `lazygit` (Optional)
- `mc`, `far` or `far2l` (Optional)
- `ctags` (Optional)

> [!Warning]
> First run may be longer

> [!Warning]
> It works better in NeoVim, and pckr.nvim does not work in version of Vim/NeoVim without Lua.

> [!Note]
> Press `SPACE ?` to see help
> Press `f10` or `f9` to open menu, `hjkl` to navigate in it, `SPC` to select menu item

> [!Warning]
> After updating coc-sh language server, you need to reinstall coc-sh crutch:

<details open><summary>
Reinstall coc-sh crutch
</summary>

Run this:
```console
$ exnvim install-coc-sh-crutch -f
```

</details>

Change to light theme: `:set background=light` \
Change to dark theme: `:set background=dark`

<details open><summary>
Installation
</summary>

## Installation

```console
$ git clone https://github.com/TwoSpikes/extra.nvim extra.nvim
$ cd extra.nvim
$ cargo install --path util/exnvim
$ exnvim install
$ exnvim setup
```

### Extra step for Vim

```console
$ echo "so ~/.config/nvim/init.vim" >> ~/.vimrc
```

</details>

<details><summary>
Config for extra.nvim
</summary>

### Where is it?

```console
$ mkdir -p ~/.config/exnvim/
$ nvim ~/.config/exnvim/config.json
```

If you want to change default extra.nvim config path:
```console
$ EXNVIM_CONFIG_PATH=your_path nvim
```

Like
```console
$ EXNVIM_CONFIG_PATH=~/dnsjajsbdn/exnvim/ nvim
```

> Warning: if installing to Vim, remove all non-unique keys

</details>

## Use colorscheme in clean Vim/NeoVim

```vim
:set nocompatible
:set termguicolors
:colorscheme blueorange
```

# Contribution

## Copy config to this repo and commit

```console
$ exnvim commit
```

### Only copy config, but not commit:

```console
$ exnvim commit --only-copy
```
Or
```console
$ exnvim commit -o
```

### If using Vim/NeoVim:

```console
:ExNvimCommit
```

## Get extra.nvim version

```console
$ exnvim version
```

> [!Warning]
> Do not delete code that seems strange, maybe you will break something

> [!Warning]
> Due to version is built in `exnvim` binary, you should recompile it every time `.exnvim-version` changes

# Also see

- [dotfiles](https://github.com/TwoSpikes/dotfiles.git)
- [NeoVim](https://neovim.io/)
- [Vim](https://www.vim.org/)
- [Vim docs](https://vimdoc.sourceforge.net/)
- [helix](https://helix-editor.com/)
- [Git](https://git-scm.com/)

# Plug-ins used

- [pckr.nvim](https://github.com/TwoSpikes/pckr.nvim)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [lspactions](https://github.com/RishabhRD/lspactions)
- [popup.nvim](https://github.com/nvim-lua/popup.nvim)
- [nvim-notify](https://github.com/rcarriga/nvim-notify)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nvim-treesitter/playground](https://github.com/nvim-treesitter/playground)
- [nvim-workbench](https://github.com/weizheheng/nvim-workbench)
- [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)
- [netrw.nvim](https://github.com/prichrd/netrw.nvim)
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) (disabled)
- [which-key.nvim](https://github.com/folke/which-key.nvim)
- [bufresize.nvim](https://github.com/kwkarlwang/bufresize.nvim) (disabled)
- [goyo.nvim](https://github.com/junegunn/goyo.vim)
- [limelight.vim](https://github.com/junegunn/limelight.vim)
- [rust.vim](https://github.com/rust-lang/rust.vim)
- [tagbar](https://github.com/preservim/tagbar)
- [vim-devicons](https://github.com/ryanoasis/vim-devicons)
- [vim-quickui](https://github.com/skywind3000/vim-quickui)
- [coc.nvim](https://github.com/neoclide/coc.nvim)
- [vim-jsx-improve](https://github.com/neoclide/vim-jsx-improve)
- [vim-floaterm](https://github.com/voldikss/vim-floaterm)
- [vim-man](https://github.com/https://github.com/vim-utils/vim-man)
- [vim-surround](https://github.com/tpope/vim-surround)
- [vim-closetag](https://github.com/alvan/vim-closetag)
- [vim-js](https://github.com/yuezk/vim-js)
- [vim-jsx-pretty](https://github.com/maxmellon/vim-jsx-pretty)
- [emmet-vim](https://github.com/kmoschcau/emmet-vim)
- [copilot.vim](https://github.com/github/copilot.vim) (disabled by default)
- [vim-terminator](https://github.com/erietz/vim-terminator)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [vim-visual-multi](https://github.com/mg979/vim-visual-multi)
- [vital.vim](https://github.com/vim-jp/vital.vim)
- [nvim-spectre](https://github.com/nvim-pack/nvim-spectre)
- [vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [nvim-nio](https://github.com/nvim-neotest/nvim-nio)
- [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text)
- [telescope-dap.nvim](https://github.com/nvim-telescope/telescope-dap.nvim)
- [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python)
- [nvim-dap-go](https://github.com/leoluz/nvim-dap-go)
- [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
- [nvim-metals](https://github.com/scalameta/nvim-metals)
- [fidget.nvim](https://github.com/j-hui/fidget.nvim)
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
- [cmp-path](https://github.com/hrsh7th/cmp-path)
- [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [cmp-vsnip](https://github.com/hrsh7th/cmp-vsnip)
- [vim-vsnip](https://github.com/hrsh7th/vim-vsnip)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [alpha-nvim](https://github.com/goolord/alpha-nvim)
- [persisted.nvim](https://github.com/olimorris/persisted.nvim)
- [lean.nvim](https://github.com/Julian/lean.nvim) (disabled)
- [vim-lion](https://github.com/tommcdo/vim-lion)
- [vim-xkbswitch](https://github.com/lyokha/vim-xkbswitch)
- [neogen](https://github.com/danymat/neogen)
- [yanky.nvim](https://github.com/folke/yanky.nvim)
- [nvim-lint](https://github.com/mfussenegger/nvim-lint)
- [telscope-recent-files](https://github.com/smartpde/telescope-recent-files)
- [noice.nvim](https://github.com/folke/noice.nvim)
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- [egdy.nvim](https://github.com/folke/edgy.nvim)
- [mini.bracketed](https://github.com/echasnovski/mini.bracketed)
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [image.nvim](https://github.com/3rd/image.nvim)
- [endscroll.nvim](https://github.com/TwoSpikes/endscroll.nvim)
- [cinnamon.nvim](https://github.com/declancm/cinnamon.nvim)
- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)
- [none-ls-extras](https://github.com/nvimtools/none-ls-extras.nvim)
- [conform.nvim](https://github.com/stevearc/conform.nvim)
- [convert.nvim](https://github.com/cjodo/convert.nvim)
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)
- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)
- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
- [promise-async](https://github.com/kevinhwang91/promise-async)
- [diffview.nvim](https://github.com/sindrets/diffview.nvim)
- [trouble.nvim](https://github.com/folke/trouble.nvim)
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [vim-sneak](https://github.com/justinmk/vim-sneak)
- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)
- [fzf](https://github.com/junegunn/fzf)
- [codeium.nvim](https://github.com/Exafunction/codeium.vim) (disabled by default)
- [music-player.vim](https://github.com/TwoSpikes/music-player.vim)
- [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
- [hlargs.nvim](https://github.com/m-demare/hlargs.nvim)
- [beacon.nvim](https://github.com/danilamihailov/beacon.nvim)
- [hex.nvim](https://github.com/RaafatTurki/hex.nvim)
- [pkgman.nvim](https://github.com/TwoSpikes/pkgman.nvim)
