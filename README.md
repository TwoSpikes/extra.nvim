# What is this

My scripts and configs for Linux

# Automatic installation

Warning: you need to be in this repositiory directory
```console
git clone https://github.com/TwoSpikes/dotfiles.git
cd dotfiles
sh .dotfiles-setup.sh .
```

# Manual installation

## .bashrc

### Installation

Warning: you need to be in this repositiory directory
```console
$ cp ./.bashrc ~/
```

Then you need to restart your shell

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

<img src=.github/images/Screenshot_2023-11-05-14-45-03-516_com.termux.png>
<img src=.github/images/Screenshot_2023-11-05-12-13-23-092_com.termux.png>

### Note №1

It works better in NeoVim,\
and plugin manager does not work yet in version of Vim/NeoVim without Lua.

### Note №2

To prevent lsp setup, run this command in terminal

```console
touch ~/.config/nvim/options/do_not_setup_lsp.null
```

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
