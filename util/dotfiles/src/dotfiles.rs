macro_rules! clear {
    () => {
        print!("{esc}[2J{esc}[1;1H", esc = 27 as char);
    };
}

macro_rules! usage {
    ($program_name:expr) => {
        println!("{}: [OPTION]... COMMAND", stringify!($program_name));
    };
}

macro_rules! commands {
    () => {
        println!("COMAMNDS (case sensitive):");
        println!("\tcommit       Commit changes to dotfiles repo");
        println!("\thelp         Show this help");
    };
}

macro_rules! options {
    () => {
        println!("OPTIONS (case sensitive):");
        println!("\tFor 'commit' subcommand:");
        println!("\t\t--only-copy     Only copy, but not commit");
    };
}

macro_rules! help {
    ($program_name:expr) => {
        usage!($program_name);
        println!();
        commands!();
        println!();
        options!();
    };
}

macro_rules! help_invitation {
    ($program_name:expr) => {
        println!("To see full help, run:");
        println!("{} --help", stringify!($program_name));
    };
}

macro_rules! short_help {
    ($program_name:expr) => {
        usage!($program_name);
        println!();
        help_invitation!($program_name);
    };
}

macro_rules! run_as_superuser_if_needed {
    ($name:expr, $args:expr) => {
        if ::whoami::realname() != "root" && !::std::env::var("TERMUX_VERSION").expect("Cannot get envvar").is_empty() {
            ::std::process::Command::new($name)
                .args($args)
                .status()
                .expect("failed to execute child process")
        } else {
            ::runas::Command::new($name)
                .args($args)
                .status()
                .expect("failed to execute child process")
        }
    };
}

// Copyied from StackOverflow: https://stackoverflow.com/questions/26958489/how-to-copy-a-folder-recursively-in-rust
fn copy_dir_all(src: impl AsRef<::std::path::Path> + ::std::convert::AsRef<::std::path::Path>, dst: impl AsRef<::std::path::Path> + ::std::convert::AsRef<::std::path::Path>) -> ::std::io::Result<()> {
    ::std::fs::create_dir_all(&dst)?;
    for entry in ::std::fs::read_dir(src)? {
        let entry = entry?;
        let ty = entry.file_type()?;
        if ty.is_dir() {
            copy_dir_all(entry.path(), dst.as_ref().join(entry.file_name()))?;
        } else {
            ::std::fs::copy(entry.path(), dst.as_ref().join(entry.file_name()))?;
        }
    }
    Ok(())
}

/*_df_c() {
    "${CLEAR_PROGRAM}"
	"${CD_PROGRAM}" ~/dotfiles/
# Sbin
	"${CP_PROGRAM}" ~/bin/viman ~/dotfiles/bin/
# Bashrc script and its dependencies
	"${CP_PROGRAM}" ~/.dotfiles-script.sh ~/dotfiles/
	"${CP_PROGRAM}" -r ~/shscripts/ ~/dotfiles/
	"${CP_PROGRAM}" -r ~/shlib/ ~/dotfiles/
	"${CP_PROGRAM}" ~/.profile ~/.zprofile ~/dotfiles/
	"${CP_PROGRAM}" ~/.bashrc ~/.zshrc ~/dotfiles/
## Vim/NeoVim configs
    "${CP_PROGRAM}" ~/.config/nvim/init.vim ~/dotfiles/.config/nvim/
    "${CP_PROGRAM}" -r ~/.config/nvim/lua/ ~/dotfiles/.config/nvim/
    "${CP_PROGRAM}" ~/bin/viman ~/dotfiles/
## Vim/NeoVim themes
    "${CP_PROGRAM}" ${PREFIX}/share/nvim/runtime/syntax/book.vim ~/dotfiles/
    "${CP_PROGRAM}" ${PREFIX}/share/nvim/runtime/colors/blueorange.vim ~/dotfiles/
## Vim/NeoVim scripts
	"${CP_PROGRAM}" ~/xterm-color-table.vim ~/dotfiles/
## Tmux
	"${CP_PROGRAM}" ~/.tmux.conf ~/dotfiles/
	# "${CP_PROGRAM}" -r ~/.tmux/ ~/dotfiles/
## Git
	"${CP_PROGRAM}" ~/.gitconfig-default ~/.gitmessage ~/dotfiles/
## Termux
	"${CP_PROGRAM}" ~/.termux/colors.properties ~/dotfiles/.termux/
	"${CP_PROGRAM}" ~/.termux/termux.properties ~/dotfiles/.termux/
## Alacritty
	"${CP_PROGRAM}" -r ~/.config/alacritty/ ~/dotfiles/.config/
## Nano
	"${CP_PROGRAM}" ~/.nanorc ~/dotfiles/
# Commit
	"${GIT_PROGRAM}" commit --all --verbose
}*/

fn commit(only_copy: bool) -> ::std::io::Result<()> {
    let is_termux: bool = ::std::env::var("TERMUX_VERSION").is_ok();
    let HOME = match ::std::env::home_dir() {
        Some(path) => path,
        None => panic!("Cannot get HOME directory"),
    };
    {
        let path_to_dotfiles = HOME.as_path().join("dotfiles");
        assert!(::std::env::set_current_dir(&path_to_dotfiles).is_ok());
    }
    ::std::fs::copy(HOME.join(".dotfiles-script.sh"), "./.dotfiles-script.sh")?;
    copy_dir_all(HOME.join("shscripts"), "./shscripts")?;
    copy_dir_all(HOME.join("shlib"), "./shlib")?;
    ::std::fs::copy(HOME.join(".profile"), "./.profile")?;
    ::std::fs::copy(HOME.join(".zprofile"), "./.zprofile")?;
    ::std::fs::copy(HOME.join(".bashrc"), "./.bashrc")?;
    ::std::fs::copy(HOME.join(".zshrc"), "./.zshrc")?;
    ::std::fs::copy(HOME.join(".config/nvim/init.vim"), "./.config/nvim/init.vim")?;
    copy_dir_all(HOME.join(".config/nvim/lua"), "./.config/nvim/lua")?;
    copy_dir_all(HOME.join(".config/nvim/vim"), "./.config/nvim/vim")?;
    copy_dir_all(HOME.join(".config/nvim/ftplugin"), "./.config/nvim/ftplugin")?;
    ::std::fs::copy(HOME.join("bin/viman"), "./bin/viman")?;
    let VIMRUNTIME = ::std::path::Path::new(if ::which::which("nvim").is_ok() {
        if cfg!(target_os = "windows") {
            "/c/Program Files/Neovim/share/nvim/runtime"
        } else {
            if is_termux {
                "/data/data/com.termux/files/usr/share/nvim/runtime"
            } else {
                "/usr/share/nvim/runtime"
            }
        }
    } else {
        let paths = ::std::fs::read_dir(if cfg!(target_os = "windows") {
            "/c/Program Files/Vim/share/vim"
        } else {
            if is_termux {
                "/data/data/com.termux/files/usr/share/vim"
            } else {
                "/usr/share/vim"
            }
        }).unwrap();
        for path in paths {
            println!("path is: {}", path.unwrap().path().display());
        }
        "/dksk"
    });
    ::std::fs::create_dir_all("./vimruntime/syntax")?;
    _ = run_as_superuser_if_needed!("cp", &[VIMRUNTIME.join("syntax/book.vim").to_str().expect("Cannot convert path to str"), "./vimruntime/syntax/"]);
    ::std::fs::create_dir_all("./vimruntime/colors")?;
    _ = run_as_superuser_if_needed!("cp", &[VIMRUNTIME.join("colors/blueorange.vim").to_str().expect("Cannot convert path to str"), "./vimruntime/colors/"]);
    ::std::fs::copy(HOME.join("xterm-color-table.vim"), "./xterm-color-table.vim")?;
    ::std::fs::copy(HOME.join(".tmux.conf"), "./.tmux.conf")?;
    ::std::fs::copy(HOME.join(".gitconfig-default"), "./.gitconfig-default")?;
    ::std::fs::copy(HOME.join(".gitmessage"), "./.gitmessage")?;
    ::std::fs::copy(HOME.join(".termux/colors.properties"), "./.termux/colors.properties")?;
    ::std::fs::copy(HOME.join(".termux/termux.properties"), "./.termux/termux.properties")?;
    copy_dir_all(HOME.join(".config/alacritty"), "./.config/alacritty")?;
    ::std::fs::copy(HOME.join(".nanorc"), "./.nanorc")?;
    if !only_copy {
        match ::std::process::Command::new("git")
            .args(["commit", "--all", "--verbose"])
            .stdout(::std::process::Stdio::inherit())
            .stdin(::std::process::Stdio::inherit())
            .output() {
                Ok(_) => Ok(()),
                Err(e) => Err(e),
        }
    } else {
        Ok(())
    }
}

fn main() {
    let mut args = ::std::env::args();
    #[allow(unused_variables)]
    let program_name = &args.nth(0).expect("cannot get program name");
    if args.len() == 0 {
        println!("{}: Not enough arguments", program_name);
        short_help!(program_name);
        ::std::process::exit(1);
    }
    enum State {
        NONE,
        COMMIT{only_copy: bool},
    }
    let mut state = State::NONE;
    while args.len() > 0 {
        match args.nth(0).unwrap().as_str() {
            "--help"|"help" => {
                help!(program_name);
                ::std::process::exit(0);
            },
            "commit" => {
                state = State::COMMIT{only_copy: false};
            },
            "--only-copy" => {
                match state {
                    State::NONE => {
                        println!("This option can only be used with 'commit' subcommand");
                        short_help!(program_name);
                        ::std::process::exit(1);
                    },
                    State::COMMIT { only_copy: _ } => {
                        state = State::COMMIT { only_copy: true };
                    },
                }
            },
            "++only-copy" => {
                match state {
                    State::NONE => {
                        println!("This option can only be used with 'commit' subcommand");
                        short_help!(program_name);
                        ::std::process::exit(1);
                    },
                    State::COMMIT { only_copy } => {
                        state = State::COMMIT { only_copy: false };
                    },
                }
            },
            &_ => {
                println!("Unknown argument");
                short_help!(program_name);
                ::std::process::exit(1);
            },
        }
    }
    match state {
        State::NONE => {},
        State::COMMIT { only_copy } => {
            match commit(only_copy) {
                Ok(_) => {},
                Err(e) => {
                    println!("error: {}", e);
                    ::std::process::exit(1);
                },
            };
            ::std::process::exit(0);
        },
    }
}
