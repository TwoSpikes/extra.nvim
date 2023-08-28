My scripts for Termux (yes, I program in Termux)
But I think it will work on Arch and Debian too :)

# .bashrc

Warning: you need to be in repositiory directory
```console
$ cp ./.bashrc ~/
```

Then you need to restart your shell

# .config/nvim/

Warning: you need to be in this repository directory
```console
$ cp -r ./.config/nvim/ ~/.config/
```

## Extra step for Vim

```console
$ echo "so ~/.config/nvim/init.vim" >> ~/.vimrc
```

# tsch.sh (deprecated)

It is a script that runs tsch (`TwoSpikes ChooseHub`)\
It is my old thing that asks for my several most used commands but no I do not use it.

## Installation

Warning: you need to be in this repository directory
```console
$ echo "source ./tsch.sh" >> ~/.bashrc
```

Then you need to restart the shell

## Running
```console
$ tsch
```

# xterm-color-table.vim

## Installation

It is an xterm color table (256 colors) for vim/neovim.\
Fork from [this repository](https://github.com/guns/xterm-color-table.vim)

Warning: you need to be in this repository directory
```console
$ cp ./xterm-color-table.vim ~/
```

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
