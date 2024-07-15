# Extra.nvim

## What is this?

This is NeoVim/Vim configuration

<details open><summary>
Screenshots
</summary>

<img src=.github/images/a4.jpg width=100px height=222px>
<img src=.github/images/Screenshot_2024-05-21-22-05-31-89_84d3000e3f4017145260f7618db1d683.jpg width=100px height=100px>
<img src=.github/images/a2.jpg width=100px height=222px>
<img src=.github/images/a1.jpg width=100px height=222px>

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
$ ONLY_SETUP_COC_SH_CRUTCH=true ./.dotfiles-setup.sh .
```

</details>

Change to light theme: `:set background=light` \
Change to dark theme: `:set background=dark`

<details><summary>
Manual installation
</summary>

## Installation

```console
$ git clone https://github.com/TwoSpikes/extra.nvim ~/extra.nvim
$ cd ~/extra.nvim/util/installer
$ cargo run --
```

## Extra step for Vim

```console
$ echo "so ~/.config/nvim/init.vim" >> ~/.vimrc
```

</details>

<details open><summary>
Config for dotfiles
</summary>

### Autogenerate

```console
$ dotfiles setup dotfiles vim
```

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

> [!Warning]
> Do not delete code that seems strange, maybe you will break something
