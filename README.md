# What is this

My scripts and configs for Linux

# Dependencies to install

- `coreutils` >= 8.22
- `rustc` and `cargo`
- `chsh`
- `git`
- `ping`
- `wget` or `curl`
- `ncurses` (not necessary)
- package manager: `pkg`, `apt`, `apt-get`, `winget`, `pacman`, `zypper`, `xbps-install`, `yum`, `aptitude`, `dnf`, `emerge`, `up2date`, `urpmi`, `slackpkg`, `apk`, `brew`, `flatpak` or `snap`
- `sudo` or `doas`
- `awk` or `gawk`

# Consists configs for

- `nvim` (NeoVim) or `vim`
- `emacs` (WIP)
- `nano`
- `alacritty`
- `git`

# Automatic installation

## Cloning the repository

```console
$ git clone https://github.com/TwoSpikes/dotfiles.git
$ cd dotfiles
```

## Installation

```console
$ sh .dotfiles-setup.sh .
```

Or to install everything

```console
$ yes | sh .dotfiles-setup.sh .
```

> [!Note]
> After installation it is safe to remove local dotfiles repository

# Manual installation

## .dotfiles-setup.sh

### Installation

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

```console
$ cp ./.gitconfig-default ~/
$ cp ~/.gitconfig-default ~/.gitconfig
```
Now, in file `~/.gitconfig`
Uncomment lines `[user] name` and `[user] email`\
Change `Your Name` to your name\
Change `youremail@example.com` to your email

```console
$ cp ./.gitmessage ~/
```

## .config/nvim/

### What is this?

This is NeoVim/Vim configuration

<details open><summary>
Screenshots
</summary>

<img src=.github/images/a4.jpg width=100px height=100px>
<img src=.github/images/Screenshot_2024-05-21-22-05-31-89_84d3000e3f4017145260f7618db1d683.jpg width=100px height=100px>
<img src=.github/images/a2.jpg width=100px height=100px>
<img src=.github/images/a1.jpg width=100px height=100px>

</details>

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

### Installation

```console
$ cp -r ./.config/nvim/ ~/.config/
```

### Extra step for Vim

```console
$ echo "so ~/.config/nvim/init.vim" >> ~/.vimrc
```

</details>

<details><summary>
Config for dotfiles
</summary>

#### Where is it?

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

#### Default config

> [!Note]
> Fields starting with `_comment` are comments

```json
{
"_comment_01":"Transparent background",
"_comment_02":"Values:",
"_comment_03":"    always - In dark and light theme",
"_comment_04":"    dark   - In dark theme",
"_comment_05":"    light  - In light theme",
"_comment_06":"    never  - Non-transparent",
	"use_transparent_bg": "dark",

"_comment_07":"Prevent setting up LSP if false",
"_comment_08":"Useful if it does not work",
	"setup_lsp": false,

"_comment_09":"light - light background",
"_comment_10":"dark  - dark background",
	"background": "dark",

"_comment_11":"Use italic style for text",
"_comment_12":"Useful to disable for terminals with bugged italic font (like Termux)",
	"use_italic_style": false,

"_comment_13":"Enable or disable highlighting for current column",
	"cursorcolumn": false,

"_comment_14":"Enable or disable highlighting for current line",
	"cursorline": true,

"_comment_15":"Enable or disable showing line numbers",
	"linenr": true,

"_comment_16":"Change the style of line numbers",
"_comment_17":"Aviable: absolute, relative",
	"linenr_style": true,

"_comment_18":"Change style of cursorline",
"_comment_19":"    dim       - Small fogging (default)",
"_comment_20":"    reverse   - Swap fg with bg",
"_comment_21":"    underline - Underline a line",
	"cursorline_style": "dim",

"_comment_22":"Open quickui menu on start",
	"open_menu_on_start": false,

"_comment_23":"Change quickui_border_style",
"_comment_24":"1 - Dashed, non-Unicode",
"_comment_25":"2 - Solid",
"_comment_26":"3 - Double outer border (default)",
	"quickui_border_style": "3",

"_comment_27":"Change quickui colorscheme",
"_comment_28":"Aviable: borland, gruvbox, solarized, papercol dark, papercol light",
"_comment_29":"See them at https://github.com/skywind3000/vim-quickui/blob/master/MANUAL.md",
	"quickui_color_scheme": "papercol dark",

"_comment_30":"Open ranger on start",
	"open_ranger_on_start": true,

"_comment_31":"Enable Github Copilot",
"_comment_32":"Useful to disable if you do not have a subscription to it",
	"use_github_copilot": false,

"_comment_33":"Confirm dialogue width (vim-quickui)",
"_comment_34":"Default: 30",
	"pad_amount_confirm_dialogue": 30,

"_comment_35":"Change cursor style",
"_comment_36":"Aviable styles:",
"_comment_37":"  block (default)   █",
"_comment_38":"  bar               ⎸",
"_comment_39":"  underline         _",
	"cursor_style": "block",

"_comment_40":"Show or do not show tabline",
"_comment_41":"  0     Do not show",
"_comment_42":"  1     Show if there is only one tab",
"_comment_43":"  2     Show always (default)",
	"showtabline": 2,

"_comment_44":"Path style of tab in tabline",
"_comment_45":"  name      Show only filename (default)",
"_comment_46":"  short     Short path (relative to cwd and $HOME)",
"_comment_47":"  shortdir  Short path, reduce dirnames to 1 symbol",
"_comment_48":"  full      Show full filepath",
	"tabline_path": "name",

"_comment_49":"Spacing between tabs in tabline",
"_comment_50":"  none         abCd",
"_comment_51":"  full          a  b █C█ d ",
"_comment_52":"  transition    a  b  C  d (default)",
"_comment_53":"  partial       a b█c█d ",
	"tabline_spacing": "transition",

"_comment_54":"Show modified symbol ● on modified files",
	"tabline_modified": true,

"_comment_55":"Show icons before filename in tabline",
"_comment_56":"NOTE: You will need Nerd font",
	"tabline_icons": true,

"_comment_60":"Use nvim-cmp instead of coc.nvim",
	"use_nvim_cmp": false,

"_comment_61":"Show random text at start in alpha-nvim",
	"enable_fortune": false,

"_comment_62":"Show icons in quickui dialogues",
	"quickui_icons": true,

"_comment_63":"Interface language",
"_comment_64":"Aviable: auto (default), english, russian)",
"_comment_65":"This option does not change system locale and Vim interface language",
	"language": "auto",

"_comment_end":"Ending field to not put comma every time"
}
```

</details>

## tsch.sh [deprecated]

### What is this?

It is a script that runs tsch (`TwoSpikes ChooseHub`)\
It is my old thing that asks for my several most used commands but no I do not use it.

### Installation

```console
$ echo "source ./shscripts/tsch.sh" >> ~/.bashrc
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

```console
$ cp -r ./.emacs.d/ ~/
```

# Contribution and other stuff

## Copy configs to this repo and commit

After installing dotfiles, run:
```console
$ dotfiles commit
```

If using Vim/NeoVim:
```console
:DotfilesCommit
```

## Get dotfiles version

```console
dotfiles version
```
