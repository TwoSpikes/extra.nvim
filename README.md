# Extra.nvim

## What is this?

This is NeoVim/Vim configuration

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

- RAM: 60 MiB (minimal), 128 MiB (recommended)
- Free disk space: 146,4 MiB (minimal, including all plugins)
- Internet connection (to download plugins)
- `vim`
- `vim-runtime` (it is often already installed as a `vim` dependency)

> [!Warning]
> Implies to use [Nerd Fonts](https://www.nerdfonts.com)

> [!Warning]
> It works better in NeoVim, and packer.nvim does not work in version of Vim/NeoVim without Lua.

> [!Note]
> Press `SPACE ?` to see help

> [!Warning]
> After updating coc-sh language server, you need to reinstall coc-sh crutch:

<details><summary>
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

## Extra step for Vim

```console
$ echo "so ~/.config/nvim/init.vim" >> ~/.vimrc
```

</details>

<details open><summary>
Config for dotfiles
</summary>

### Where is it?

```console
$ mkdir -p ~/.config/dotfiles/vim/
$ vim ~/.config/dotfiles/vim/config.json
```

If you want to change default dotfiles config path:
```console
$ DOTFILES_VIM_CONFIG_PATH=your_path nvim
```

Like
```console
$ DOTFILES_VIM_CONFIG_PATH=~/dnsjajsbdn/vim/ nvim
```

</details>

# Contribution

## Copy configs to this repo and commit

```console
$ exnvim commit
```

### Only copy configs, but not commit:

```console
$ exnvim commit --only-copy
```
Or
```console
$ exnvim commit -o
```

#### If using Vim/NeoVim:

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
