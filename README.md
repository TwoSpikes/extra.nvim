My scripts for Termux (yes, I program in Termux)
But I think it will work on Arch and Debian too :)

# .bashrc

## Dependencies:
- coreutils
- cal
- text editor
- git
- package manager
- sed
- make
- cargo
- grep
- git

## Quick install

Warning: you need to be in repositiory directory
```console
$ cp ./.bashrc ~/
```

Then you need to restart your shell

# .nvimrc

Since last commits, it is usable for both [`vim`](https://vim.org) and [`neovim`](https://neovim.io) (see instructions for installation)

## Installation for vim

Warning: you need to be in this repository directory
```console
$ cp ./.nvimrc ~/.vimrc
```

## Installation for vim (alternative version)

Warning: you need to be in this repository directory
```console
$ echo "so ~/dotfiles/.nvimrc" > ~/.vimrc
```
Where `~/dotfiles` is a path to this repository

Or

Warning: you need to be in this repository directory
```console
$ cp ~/dotfiles/.nvimrc ~/
$ echo "so ~/.nvimrc" > ~/.vimrc
```
Where `~/dotfiles` is a path to this repository

## Installation for neovim

Warning: you need to be in this repository directory
```console
$ mkdir -p ~/.config/nvim
$ cp ./.nvimrc ~/.config/nvim/init.vim
```

## Installlation for neovim (alternative version)

Warning: you need to be in this repository directory
```console
$ mkdir -p ~/.config/nvim
$ echo "so ~/dotfiles/.nvimrc" > ~/.config/nvim/init.vim
```
Where `~/dotfiles` is a path to this repository

Or

```console
$ cp ~/dotfiles/.nvimrc ~/
$ mkdir -p ~/.config/nvim
$ echo "so ~/.nvimrc" > ~/.config/nvim/init.vim
```
Where `~/dotfiles` is a path to this repository

## Running for vim
```console
vim
```

## Running for neovim
```console
nvim
```

# tsch.sh (deprecated)

It is a script that runs tsch (`TwoSpikes ChooseHub`)\
It is my old thing that asks for my several most used commands but no I do not use it.

## Installation
```console
$ echo "source ~/dotfiles/tsch.sh" >> ~/.bashrc
```
Where `~/dotfiles` is a path to this repository

Then you need to restart the shell

## Running
```console
$ tsch
```

# xterm-color-table.vim

## Installation

It is an xterm color table (256 colors) for vim/neovim.\
Fork from [this repository](https://github.com/guns/xterm-color-table.vim)

```console
$ cp ~/dotfiles/xterm-color-table.vim ~/
```
Where `~/dotfiles` is a path to this repository

## Running in vim

```console
$ vim
```

Then you need to run this command

For horizontal split
```
:Sxct
```

For vertical split
```
:Vxct
```

In new tab
```
:Txct
```

In new buffer
```
:Exct
```

In new buffer (fullscreen)
```
:Oxct
```
Or
```
:Exct|only
```
