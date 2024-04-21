# What is this

My scripts and configs for Linux

# Automatic installation

## Cloning the repository

```console
$ git clone https://github.com/TwoSpikes/dotfiles.git
$ cd dotfiles
```

## Installation

Warning: you need to be in this repositiory directory
```console
$ sh .dotfiles-setup.sh .
```

Or to install everything

Warning: you need to be in this repositiory directory
```console
$ yes | sh .dotfiles-setup.sh .
```

# Manual installation

## .dotfiles-setup.sh

### Installation

Warning: you need to be in this repositiory directory
```console
$ cp ./.dotfiles-setup.sh ~/
```

Then you need to restart your shell

```console
$ exec $SHELL -l
```

## .gitconfig-default .gitmessage

### What is this?

This is a basic Git configuration

### Installation

Warning: you need to be in this repository directory
```console
$ cp ./.gitconfig-default ~/
$ cp ~/.gitconfig-default ~/.gitconfig
```
Now, in file `~/.gitconfig`
Uncomment lines `[user] name` and `[user] email`\
Change `Your Name` to your name\
Change `youremail@example.com` to your email

Warning: you need to be in this repository directory
```console
$ cp ./.gitmessage ~/
```

## .config/nvim/

### What is this?

This is NeoVim/Vim configuration

<img src=.github/images/Screenshot_2024-04-13-18-21-05-51_84d3000e3f4017145260f7618db1d683.jpg>
<img src=.github/images/Screenshot_2024-04-13-18-23-57-59_84d3000e3f4017145260f7618db1d683.jpg>

> [!Note]
> It works better in NeoVim,\
and packer.nvim does not work yet in version of Vim/NeoVim without Lua.

#### Change to light theme

```vim
:set background=light
```

#### Change to dark theme

```vim
:set background=dark
```

### Installation

Warning: you need to be in this repository directory
```console
$ cp -r ./.config/nvim/ ~/.config/
```

### Extra step for Vim

```console
$ echo "so ~/.config/nvim/init.vim" >> ~/.vimrc
```

### Some options

#### Make directory for options

```console
$ mkdir ~/.config/nvim/options
```

#### Prevent LSP setup

Useful if you do not want to setup LSP or if it does not work

```console
$ touch ~/.config/nvim/options/do_not_setup_lsp.null
```

#### Transparent background

Useful if you are using terminal with transparent background

```console
$ touch ~/.config/nvim/options/use_transparent_bg.null
```

### How to remove options

Just delete files connected with them and restart Vim/NeoVim

## tsch.sh [deprecated]

### What is this?

It is a script that runs tsch (`TwoSpikes ChooseHub`)\
It is my old thing that asks for my several most used commands but no I do not use it.

### Installation

Warning: you need to be in this repository directory
```console
$ echo "source ./tsch.sh" >> ~/.bashrc
```

Then you need to restart the shell

### Running
```console
$ tsch
```

## .emacs.d/

### What is this?

It is a configuration for GNU Emacs

### Installation

Warning: you need to be in this repository directory
```console
$ cp -r ./.emacs.d/ ~/
```

## xterm-color-table.vim

### What is this?

It is an xterm color table (256 colors) for vim/neovim.\
Fork from [this repository](https://github.com/guns/xterm-color-table.vim)

### Installation

Warning: you need to be in this repository directory
```console
$ cp ./xterm-color-table.vim ~/
```

### Running in Vim/NeoVim

```console
$ vim
```

Then you need to run this command

```vim
:Sxct       " In a horizontal split
:Vxct       " In a vertical split
:Txct       " In a new tab
:Exct       " In a new buffer
:Oxct       " In a fullscreen buffer
```
