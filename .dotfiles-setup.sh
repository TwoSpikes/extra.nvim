#!/bin/env sh

set +xe

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
	echo "	STOP_AT_FIRST_ERROR"
	echo "			set +e"
	echo "	NO_INTERNET"
	echo "			Presume you do not have internet"
	echo "	NO_PACKAGE_MANAGER"
	echo "			Presume you do not have package manager"
	echo "Example: ENVVAR=true ${0}"
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
short_help() {
	subcommands
	echo ""
	echo "To see full help, run:"
	echo "	${0} --help"
}
press_enter() {
	echo ""
	echo -n "Press ENTER to continue: "
	read user_input
}
install_package() {
	if  test -z "${PACKAGE_COMMAND}" || test -z "${package_manager_is_winget}"; then
		echo "Please run determine_package_manager"
		return 1
	fi
	stdpkg=${1}
	wingetpkg=${2}
	if test -z ${stdpkg} && test -z ${wingetpkg}; then
		echo "Too few cmdline arguments"
		return 1
	fi
	if ${package_manager_not_found}; then
		echo "erorr: package manager not found"
		return 1
	fi
	if ! ${package_manager_is_winget}; then
		if test -z ${stdpkg}; then
			echo "Package to install is not defined"
			return 1
		fi
		install_package_command="${PACKAGE_COMMAND} ${stdpkg}"
		run_as_superuser_if_needed "${install_package_command}"
	else
		if test -z ${wingetpkg}; then
			echo "Package to install with winget is not defined"
			return 1
		fi
		winget install ${wingetpkg}
	fi
}
run_as_superuser_if_needed() {
	needed_command="${1}"

	if test ${need_to_run_as_superuser} = "no"; then
		${needed_command}
	elif test ${need_to_run_as_superuser} = "yes"; then
		${run_as_superuser} ${needed_command}
	elif test ${need_to_run_as_superuser} = "not found"; then
		echo "Error: superuser command not found"
		return 1
	else
		echo "run_as_superuser_if_needed: internal error"
	fi
}

if test "${1}" = "--help" \
|| test "${2}" = "--help"  \
|| test "${3}" = "--help"  \
|| test "${4}" = "--help" ; then
	help
fi

if test "${STOP_AT_FIRST_ERROR}" = "true"; then
	set -e
fi
if test "${NO_INTERNET}" = "true"; then
	presume_no_internet=true
else
	presume_no_internet=false
fi
if test "${NO_PACKAGE_MANAGER}" = "true"; then
	presume_no_package_manager=true
else
	presume_no_package_manager=false
fi

if test -z ${1}; then
	echo "Please provide path to dotfiles"
	echo ""
	short_help
	exit 1
fi

home=${HOME}
if ! test -z ${2}; then
	home=${2}
fi

dotfiles=${1}

if test -z ${PREFIX}; then
	root=/
else
	root=${PREFIX}/..
fi
if ! test -z ${3}; then
	root=${3}
fi

clear
echo "==== Starting ===="
echo ""
if ! test $(whoami) = "root" && test -z ${TERMUX_VERSION}; then
	if command -v "sudo" > /dev/null 2>&1; then
		run_as_superuser="sudo"
		need_to_run_as_superuser="yes"
	elif command -v "doas" > /dev/null 2>&1; then
		run_as_superuser="doas"
		need_to_run_as_superuser="yes"
	else
		echo "Warning: sudo or doas command not found"
		echo ""
		run_as_superuser=""
		need_to_run_as_superuser="not found"
	fi
else
	need_to_run_as_superuser="no"
fi
echo "need_to_run_as_superuser: ${need_to_run_as_superuser}"


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

if ! test -z ${TERMUX_VERSION}; then
	OS=Termux
	VER=${TERMUX_VERSION}
elif test -f ${root}/etc/os-release; then
	. ${root}/etc/os-release
	OS=${NAME}
	VER=${VERSION}
else
    OS=$(uname -s)
    VER=$(uname -r)
fi
echo "Current system: ${OS}"
echo "Current system version: ${VER}"

determine_package_manager() {
	package_manager_is_winget=false
	package_manager_not_found=false
	if ${presume_no_package_manager}; then
		package_manager_not_found=true
	else
		if command -v "pkg" > /dev/null 2>&1; then
			PACKAGE_COMMAND="pkg install -y"
		elif command -v "apt" > /dev/null 2>&1; then
			PACKAGE_COMMAND="apt install -y"
		elif command -v "apt-get" > /dev/null 2>&1; then
			PACKAGE_COMMAND="apt-get install -y"
		elif command -v "winget" > /dev/null 2>&1; then
			package_manager_is_winget=true
		elif command -v "pacman" > /dev/null 2>&1; then
			PACKAGE_COMMAND="pacman -Suy --noconfirm"
		elif command -v "zypper" > /dev/null 2>&1; then
			PACKAGE_COMMAND="zypper install -y"
		elif command -v "xbps-install" > /dev/null 2>&1; then
			PACKAGE_COMMAND="xbps-install -Sy"
		elif command -v "yum" > /dev/null 2>&1; then
			PACKAGE_COMMAND="yum install -y"
		elif command -v "aptitude" > /dev/null 2>&1; then
			PACKAGE_COMMAND="aptitude install -y"
		elif command -v "dnf" > /dev/null 2>&1; then
			PACKAGE_COMMAND="dnf install -y"
		elif command -v "emerge" > /dev/null 2>&1; then
			PACKAGE_COMMAND="emerge --ask --verbose"
		elif command -v "up2date" > /dev/null 2>&1; then
			PACKAGE_COMMAND="up2date"
		elif command -v "urpmi" > /dev/null 2>&1; then
			PACKAGE_COMMAND="urpmi --force"
		elif command -v "slackpkg" > /dev/null 2>&1; then
			PACKAGE_COMMAND="slackpkg"
		elif command -v "flatpak" > /dev/null 2>&1; then
			PACKAGE_COMMAND="flatpak install"
		elif command -v "snap" > /dev/null 2>&1; then
			PACKAGE_COMMAND="snap install"
		else
			package_manager_not_found=true
		fi
	fi
	if ! ${package_manager_not_found}; then
		if ${package_manager_is_winget}; then
			echo "Package manager is winget"
		else
			echo "Package command is: ${PACKAGE_COMMAND}"
		fi
	else
		echo "Package manager not found"
	fi
	export PACKAGE_COMMAND
	export package_manager_is_winget
	export package_manager_not_found
}
determine_package_manager

echo ""

if ! "${presume_no_internet}"; then
	ping -c 1 8.8.8.8 > /dev/null
	ping_errorcode=${?}
	if test ${ping_errorcode} -eq 0; then
		echo "You have an internet"
		have_internet=true
	else
		echo "You do not have an internet"
		have_internet=false
	fi
else
	have_internet=false
fi

if ! command -v "git" > /dev/null 2>&1; then
	echo "Git not found"
	git_found=false
else
	echo "Git found"
	git_found=true
fi

if test -d ${dotfiles}; then
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

if test -z "$(ls -A ${dotfiles})"; then
	echo "Directory is empty"
else
	echo "Directory is not empty"
fi

if "${have_internet}"; then
	TMPFILE=$(mktemp -u)
	if command -v curl >/dev/null 2>&1; then
		curl -fsSLo "${TMPFILE}" https://raw.githubusercontent.com/TwoSpikes/dotfiles/master/.dotfiles-version
	else
		wget -O "${TMPFILE}" https://raw.githubusercontent.com/TwoSpikes/dotfiles/master/.dotfiles-version
	fi
	latest_dotfiles_version=$(cat "${TMPFILE}")
	echo "Latest dotfiles version: ${latest_dotfiles_version}"
	rm "${TMPFILE}"
	unset TMPFILE
	latest_dotfiles_version_known=true
else
	echo "warning: you need internet to check latest dotfiles version"
	latest_dotfiles_version_known=false
fi

if test -f ${dotfiles}/.dotfiles-version; then
	local_dotfiles_version=$(cat ${dotfiles}/.dotfiles-version)
	have_local_dotfiles=true
else
	have_local_dotfiles=false
fi
if "${have_local_dotfiles}"; then
	if "${latest_dotfiles_version_known}"; then
		if test "${local_dotfiles_version}" = "${latest_dotfiles_version}"; then
			have_latest_dotfiles=true
		else
			have_latest_dotfiles=false
		fi
	else
		have_latest_dotfiles=true
	fi
else
	have_latest_dotfiles=false
fi

if "${have_latest_dotfiles}"; then
	echo "Dotfiles found"
	echo -n "Local dotfiles version: "
	cat ${dotfiles}/.dotfiles-version
else
	if ! test -f ${dotfiles}/.dotfiles-version; then
		echo "Dotfiles not found"
	else
		echo "Dotfiles is old, new version if aviable"
	fi
	if "${have_internet}"; then
		echo -n "Do you want to download it? (y/N): "
		read user_input
		user_input=$(echo ${user_input}|awk '{print tolower($0)}')
		case ${user_input} in
			"y")
				if ! test ${git_found}; then
					echo "Abort: No Git found"
					return 1
				else
	set -x
					git clone --depth=1 https://github.com/TwoSpikes/dotfiles.git ${dotfiles}
	set +x
				fi
				;;
			*)
				if ! "${have_local_dotfiles}"; then
					echo "fatal: no dotfiles and you rejected to download them"
					return 1
				fi
				;;
		esac
	else
		if ! "${have_local_dotfiles}"; then
			echo "fatal: you need internet to download them"
			echo "maybe you handed the wrong path to dotfiles?"
			return 1
		fi
	fi
fi

echo "Now we are ready to start"

press_enter

clear
echo "==== Setupping shell ===="
echo ""
echo -n "Do you want to copy .bashrc and its dependencies? (y/N/exit): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case ${user_input} in
	"y")
		cp ${dotfiles}/.zshrc ${home}
		cp ${dotfiles}/.dotfiles-script.sh ${home}
		cp ${dotfiles}/tsch.sh ${dotfiles}/.fr.sh ${dotfiles}/inverting.sh ${home}
		cp -r ${dotfiles}/shlib/ ${home}
		cp ${dotfiles}/.profile ${dotfiles}/.zprofile ${home}
		;;
	"exit"|"x"|"e"|"q")
		echo "Abort"
		return 1
		;;
	*)
		;;
esac

press_enter

clear
echo "==== Installing Zsh ===="
echo ""

if ! command -v zsh > /dev/null 2>&1; then
	echo -n "Do you want to install Zsh? (Y/n): "
	read user_input
	user_input=$(echo ${user_input}|awk '{print tolower($0)}')
	case ${user_input} in
		"n")
			;;
		*)
			install_package zsh
			;;
	esac
fi

press_enter

clear
echo "==== Making Zsh your default shell ===="
echo ""

echo -n "Do you want to make Zsh your default shell? (Y/n): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case ${user_input} in
	"n")
		;;
	*)
		chsh
		;;
esac

press_enter

clear
echo "==== Installing zsh4humans ===="
echo ""

echo -n "Do you want to install zsh4humans? (Y/n): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case ${user_input} in
	"n")
		;;
	*)
		echo -n "Fetching zsh4humans... "
		TMPFILE_DOWNLOADED=mktemp
		if command -v curl >/dev/null 2>&1; then
			curl -fsSLo "${TMPFILE_DOWNLOADED}" https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install
		else
			wget -O "${TMPFILE_DOWNLOADED}" https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install
		fi
		chmod +x "${TMPFILE_DOWNLOADED}"
		echo "OK"

		echo -n "Changing zsh4humans... "
		TMPFILE_EDITED=mktemp
		head -n -1 "${TMPFILE_DOWNLOADED}" > "${TMPFILE_EDITED}"
		echo "OK"

		echo "Running zsh4humans..."
		sh "${TMPFILE_EDITED}"
		z4h_errcode=${?}
		echo "zsh4humans: exit code: ${z4h_errcode}"

		echo -n "Deleting tmp files... "
		rm "${TMPFILE_EDITED}"
		rm "${TMPFILE_DOWNLOADED}"
		unset TMPFILE_EDITED
		unset TMPFILE_DOWNLOADED
		echo "OK"
		;;
esac

press_enter

clear
echo "==== Checking if editors exist ===="
echo ""

if ! command -v "nvim" 2>&1; then
	echo "Neovim not found"
	neovim_found=false
else
	echo "Neovim found"
	neovim_found=true
fi

if ! command -v "vim" 2>&1; then
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

if test "${setting_editor_for}" = "vim"; then
	VIMRUNTIME=${root}/usr/share/vim/vim*
else
	VIMRUNTIME=${root}/usr/share/nvim/runtime
fi

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

if test -d ${dotfiles}/.config/nvim; then
	echo "Directory exists"
else
	echo "Abort: Directory does not exist"
	return 1
fi

if test -z "$(ls ${dotfiles}/.config/nvim)"; then
	echo "Abort: Directory is empty"
	return 1
else
	echo "Directory is not empty"
fi

if test -f ${dotfiles}/.config/nvim/init.vim; then
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

		if ! test -d ${home}/.config; then
			mkdir -pv ${home}/.config
		fi
		cp -r ${dotfiles}/.config/nvim ${home}/.config/${setting_editor_for}
		run_as_superuser_if_needed "cp -v ${dotfiles}/blueorange.vim ${VIMRUNTIME}/colors"
		if test "${setting_editor_for}" = "vim"; then
			echo 'exec printf("source %s/.config/vim/init.vim", $HOME)' > ${home}/.vimrc
		fi
		if ! test -d ${home}/bin; then
			mkdir -pv ${home}/bin
		fi
		if ! test -d ${home}/sbin; then
			mkdir -pv ${home}/sbin
		fi
		cp -v ${dotfiles}/sbin/* ${home}/sbin/

		press_enter
		;;
	*)
		;;
esac
clear

echo "==== Installing packer.nvim ===="
echo ""

# FIXME: make work for Vim with Lua or change Plugin Manager
echo -n "Checking if packer.nvim is installed: "
if test -e ${root}/usr/share/nvim/site/pack/packer/start/packer.nvim; then
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

press_enter

clear
echo "==== Configuring ${setting_editor_for} configuration"
echo ""

echo -n "Checking if directory for configuration exists: "
if test -d ${home}/.config/${setting_editor_for}/options; then
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
		if test -e ${home}/.config/${setting_editor_for}/options/do_not_setup_lsp.null; then
			rm ${home}/.config/${setting_editor_for}/options/do_not_setup_lsp.null
		fi
		;;
esac

press_enter

clear
echo "==== Miscellaneous stuff ===="
echo ""

echo -n "Do you want to copy xterm-color-table.vim (recommended)? (Y/n): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case ${user_input} in
	"n")
		;;
	*)
		cp ${dotfiles}/xterm-color-table.vim ${home}
		;;
esac

clear
echo "==== Setting up git ===="
echo ""

echo -n "Checking if Git is installed: "
if $git_found; then
	echo "YES"
	echo ""

	echo -n "Do you want to setup Git? (Y/n): "
	read user_input
	user_input=$(echo ${user_input}|awk '{print tolower($0)}')
	case ${user_input} in
		"n")
			;;
		*)
			cp ${dotfiles}/.gitconfig-default ${home}
			cp ${home}/.gitconfig-default ${home}/.gitconfig
			cp ${dotfiles}/.gitmessage ${home}
			
			echo -n "Your Name: "
			read user_input
			git config --global user.name "${user_input}"
			echo -n "Your email: "
			read user_input
			git config --global user.email "${user_input}"

			echo "Git setup done"
	esac
else
	echo "NO"
	echo "Error: Git not found"
fi

press_enter

if test ${OS} = "Termux"; then
clear
echo "==== Setupping termux ===="
echo ""

echo -n "Do you want to setup Termux? (Y/n): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case ${user_input} in
	"n")
		;;
	*)
		termux-setup-storage
		cp -r ${dotfiles}/.termux/ ${home}/
		if test -e ${home}/.termux/colors.properties; then
			rm ${home}/.termux/colors.properties
		fi
		if test -e ${home}/.termux/termux.properties; then
			rm ${home}/.termux/termux.properties
		fi

		echo -n "Do you want to install my Termux colorscheme? (y/N): "
		read user_input
		user_input=$(echo ${user_input}|awk '{print tolower($0)}')
		case ${user_input} in
			"y")
				if ! test -d ${home}/.termux; then
					mkdir ${home}/.termux
				fi
				cp ${dotfiles}/.termux/colors.properties ${home}/.termux/
				;;
			*)
				;;
		esac

		echo -n "Do you want to install my Termux settings? (Y/n): "
		read user_input
		user_input=$(echo ${user_input}|awk '{print tolower($0)}')
		case ${user_input} in
			"n")
				;;
			*)
				if ! test -d ${home}/.termux; then
					mkdir ${home}/.termux
				fi
				cp ${dotfiles}/.termux/termux.properties ${home}/.termux/
				;;
		esac

		echo -n "Reloading Termux settings... "
		termux-reload-settings
		echo "OK"
		fi
		;;
esac

clear
echo "==== Setting up Tmux ===="
echo ""

echo -n "Do you want to setup Tmux? (Y/n): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case "${user_input}" in
	"n")
		;;
	*)
		if ! command -v "tmux" > /dev/null 2>&1; then
			echo "Tmux is not installed"
			echo -n "Do you want to install it? (Y/n): "
			read user_input
			user_input=$(echo ${user_input}|awk '{print tolower($0)}')
			case "${user_input}" in
				n)
					;;
				*)
					install_package tmux
					;;
			esac
		fi
		if command -v "tmux" > /dev/null 2>&1; then
			echo -n "Copying config for Tmux... "
			cp ${dotfiles}/.tmux.conf ${home}/
			echo "OK"
		fi
		;;
esac

clear
echo "==== Setting up Nano ===="
echo ""

echo -n "Do you want to setup Nano? (Y/n): "
read user_input
user_input=$(echo ${user_input}|awk '{print tolower($0)}')
case "${user_input}" in
	"n")
		;;
	*)
		if ! command -v "nano" > /dev/null 2>&1; then
			echo "Nano is not installed"
			echo -n "Do you want to install it? (Y/n): "
			read user_input
			user_input=$(echo ${user_input}|awk '{print tolower($0)}')
			case "${user_input}" in
				n)
					;;
				*)
					install_package nano
					;;
			esac
		fi
		if command -v "nano" > /dev/null 2>&1; then
			echo -n "Copying config for Nano... "
			cp ${dotfiles}/.nanorc ${home}/
			echo "OK"
		fi
		;;
esac

echo "Dotfiles setup ended successfully"
echo "It is recommended to restart your shell"
return 0
