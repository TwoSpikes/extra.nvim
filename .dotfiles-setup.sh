#!/bin/sh

set -e

subcommands() {
	echo "SUBCOMMANDS:"
	echo "	[OPTION]... DOTFILES_PATH"
	echo "	[OPTION]... DOTFILES_PATH HOME_PATH ROOT_PATH"
}
options() {
	echo "OPTIONS:"
	echo "	--help		Display this message"
}
envvars() {
	echo "ENVIRONMENT VARIABLES:"
	echo "	DO_NOT_STOP_AT_FIRST_ERROR"
	echo "			If not empty, set +e"
}
help() {
	echo "${0} is a script to setup dotfiles"
	echo ""
	subcommands
	echo ""
	options
	echo ""
	envvars
	exit 0
}

if [ "${1}" = "--help" ] \
|| [ "${2}" = "--help" ] \
|| [ "${3}" = "--help" ] \
|| [ "${4}" = "--help" ]; then
	help
fi

if [ $DO_NOT_STOP_AT_FIRST_ERROR ]; then
	set +e
fi

if [ -z ${1} ]; then
	echo "Please provide path to dotfiles"
	echo ""
	subcommands
	exit 1
fi

home=${HOME}
if [ ! -z ${2} ]; then
	home=${2}
fi

dotfiles=${1}

if [ -z ${PREFIX} ]; then
	root=/
else
	root=${PREFIX}/..
fi
if [ ! -z ${3} ]; then
	root=${3}
fi

clear
echo "==== Starting ===="
echo ""

echo "Path to dotfiles is:"
echo "<<< ${dotfiles}"

echo "Path to home is:"
echo "<<< ${home}"

echo "Path to / is:"
echo "<<< ${root}"

echo ""
echo -n "That is right? (y/N): "
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
read user_input
case ${user_input} in
	"y")
		break
		;;
	*)
		echo "Abort"
		exit 1
		;;
esac

clear
echo "==== Checking misc stuff ===="
echo ""

ping -c 1 8.8.8.8 > /dev/null
ping_errorcode=${?}
if [ ${ping_errorcode} -eq 0 ]; then
	echo "You have an internet"
else
	echo "You do not have an internet"
fi

if ! command -v "git"; then
	echo "Git not found"
	git_found=false
else
	echo "Git found"
	git_found=true
fi

if [ -d ${dotfiles} ]; then
	echo "Dotfiles directory exists"
else
	echo "Dotfiles directory does not exist"
	echo -n "Do you want to create it? (y/N): "
	read user_input
	user_input=$(echo ${user_input}|awk '{print tolower($0)}')
	case ${user_input} in
		"y")
			mkdir ${dotfiles}
			;;
		*)
			echo "Abort"
			return 1
			;;
	esac
fi

if [ -z "$(ls -A ${dotfiles})" ]; then
	echo "Directory is empty"
else
	echo "Directory is not empty"
fi

if [ -f ${dotfiles}/.dotfiles-version ]; then
	echo "Dotfiles found"
else
	echo "Dotfiles not found"
	echo -n "Do you want to download them? (y/N): "
	read user_input
	user_input=$(echo ${user_input}|awk '{print tolower($0)}')
	case ${user_input} in
		"y")
			if [ ! ${git_found} ]; then
				echo "Abort: No Git found"
				return 1
			else
				git clone --depth=1 https://github.com/TwoSpikes/dotfiles.git ${dotfiles}
			fi
			;;
		*)
			echo "Abort"
			return 1
			;;
	esac
fi

echo "Now we are ready to start"

echo -n "Do you want to copy .bashrc and its dependencies? (y/N/exit): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case ${user_input} in
	"y")
		cp ${dotfiles}/.zshrc ${home}
		cp ${dotfiles}/.bashrc ${home}
		cp ${dotfiles}/checkhealth.sh ${home}
		cp ${dotfiles}/funcname.sh ${home}
		cp ${dotfiles}/timer.sh ${home}
		cp ${dotfiles}/tsch.sh ${home}
		;;
	"exit"|"x"|"e"|"q")
		echo "Abort"
		return 1
		;;
	*)
		;;
esac

clear
echo "==== Checking if editors exist ===="
echo ""

if ! command -v "nvim"; then
	echo "Neovim not found"
	neovim_found=false
else
	echo "Neovim found"
	neovim_found=true
fi

if ! command -v "vim"; then
	echo "Vim not found"
	vim_found=false
else
	echo "Vim found"
	vim_found=true
fi

if ${vim_found}; then
	if ${neovim_found}; then
		echo "Set editor for:"
		echo "1. Vim"
		echo "2. Neovim"
		echo "Other. Abort"
		echo -n ">>> "
		read user_input
		case "${user_input}" in
			"1")
				setting_editor_for=vim
				;;
			"2")
				setting_editor_for=nvim
				;;
			*)
				echo "Abort"
				return 1
				;;
		esac
	else
		setting_editor_for=vim
	fi
else
	if ${neovim_found}; then
		setting_editor_for=nvim
	else
		echo "Vim/NeoVim not found"
		echo "Abort"
		return 1
	fi
fi

clear
echo "==== Setting config for editor: ${setting_editor_for} ===="
echo ""

echo -n "That is right? (y/N): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case ${user_input} in
	"y")
		echo "Ok"
		;;
	*)
		echo "Abort"
		return 1
		;;
esac

clear
echo "==== Checking if config for editor ${setting_editor_for} exists ===="
echo ""

if [ -d ${dotfiles}/.config/nvim ]; then
	echo "Directory exists"
else
	echo "Abort: Directory does not exist"
	return 1
fi

if [ -z "$(ls ${dotfiles}/.config/nvim)" ]; then
	echo "Abort: Directory is empty"
	return 1
else
	echo "Directory is not empty"
fi

if [ -f ${dotfiles}/.config/nvim/init.vim ]; then
	echo "Config for ${setting_editor_for} exists"
else
	echo "Abort: Config for ${setting_editor_for} does not exist"
	return 1
fi

echo -n "Do you want to copy config for ${setting_editor_for}? (y/N): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case ${user_input} in
	"y")
		clear
		echo "==== Copying ${setting_editor_for} config ===="
		echo ""

set -x
		cp -r ${dotfiles}/.config/nvim ${home}/.config/${setting_editor_for}
		if [ "${setting_editor_for}" = "nvim" ]; then
			cp ${dotfiles}/blueorange.vim ${root}/usr/share/nvim/runtime/colors
		fi
		if [ "${setting_editor_for}" = "vim" ]; then
			cp ${dotfiles}/blueorange.vim ${root}/usr/share/vim/vim90/colors
			echo 'exec printf("source %s/.config/vim/init.vim", $HOME)' > ${home}/.vimrc
		fi
set +x

		echo ""
		echo -n "Press ENTER to continue: "
		read user_input

		;;
	*)
		;;
esac
clear

echo "==== Installing packer.nvim ===="
echo ""

# FIXME: make work for Vim with Lua or change Plugin Manager
echo -n "Checking if packer.nvim is installed: "
if [ -e ${root}/usr/share/nvim/site/pack/packer/start/packer.nvim ]; then
	echo "YES"
else
	echo "NO"
	if ${neovim_found}; then
		echo -n "Do you want to install packer.nvim to NeoVim (y/N): "
		read user_input
		user_input=$(echo ${user_input}|awk '{print tolower($0)}')
		case ${user_input} in
			"y")
				git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	 ${root}/usr/share/nvim/site/pack/packer/start/packer.nvim
				;;
			*)
				;;
		esac
	else
		echo "Cannot install packer.nvim: NeoVim not found"
	fi
fi

echo ""
echo -n "Press ENTER to continue: "
read user_input

clear
echo "==== Configuring ${setting_editor_for} configuration"
echo ""

echo -n "Checking if directory for configuration exists: "
if [ -d ${home}/.config/${setting_editor_for}/options ]; then
	echo "YES"
else
	echo "NO"
	echo -n "Making a directory for configuration: "
	mkdir ${home}/.config/${setting_editor_for}/options
	echo "OK"
fi
echo ""

echo -n "Do you want ${setting_editor_for} to install LSP (recommended)? (Y/n): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case ${user_input} in
	"n")
		touch ${home}/.config/nvim/options/do_not_setup_lsp.null
		;;
	*)
		if [ -e ${home}/.config/${setting_editor_for}/options/do_not_setup_lsp.null ]; then
			rm ${home}/.config/${setting_editor_for}/options/do_not_setup_lsp.null
		fi
		;;
esac

echo -n "Press ENTER to continue: "
read user_input

echo "Not implemented yet"
return 0
