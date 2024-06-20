pub mod colors;
pub mod timer;
pub mod checkhealth;

use std::path::PathBuf;
use std::io::Write;
use std::borrow::Borrow;

use timer::timer_end_silent;
#[allow(unused_imports)] use timer::{timer_endln, timer_start_silent, timer_startln, timer_total_time};

#[allow(unused_macros)] macro_rules! clear {
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
        println!("\tversion --version -V     ");
        println!("\t             Show version");
        println!("\tinit         Initialize dotfiles");
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
    _ = ::std::fs::create_dir_all(&dst);
    for entry in ::std::fs::read_dir(src)? {
        let entry = entry?;
        let ty = entry.file_type()?;
        if ty.is_dir() {
            _ = copy_dir_all(entry.path(), dst.as_ref().join(entry.file_name()));
        } else {
            _ = ::std::fs::copy(entry.path(), dst.as_ref().join(entry.file_name()));
        }
    }
    Ok(())
}
fn find_vim_vimruntime_path(is_termux: bool) -> String {
    let paths = ::std::fs::read_dir(if cfg!(target_os = "windows") {
        "/c/Program Files/Vim/share/vim"
    } else {
        if is_termux {
            "/data/data/com.termux/files/usr/share/vim"
        } else {
            "/usr/share/vim"
        }
    }).unwrap();
    let mut maxver: Option<u16> = None;
    for path in paths {
        let path = path.unwrap().path();
        let mut filename = path.file_name().unwrap().to_str().unwrap();
        if filename.starts_with("vim") {
            let mut chars = filename.chars();
            _ = chars.next();
            _ = chars.next();
            _ = chars.next();
            filename = chars.as_str();
            let version = filename.parse::<u16>().unwrap();
            if match maxver {
                None => {
                    true
                },
                Some(maxver) => {
                    version > maxver
                },
            } {
                maxver = Some(version);
            }
        }
    }
    format!("vim{}", maxver.unwrap())
}
fn commit(only_copy: bool, #[allow(non_snake_case)] HOME: PathBuf) -> ::std::io::Result<()> {
    let is_termux: bool = ::std::env::var("TERMUX_VERSION").is_ok();
    _ = ::std::fs::copy(HOME.join(".dotfiles-script.sh"), "./.dotfiles-script.sh");
    _ = copy_dir_all(HOME.join("shscripts"), "./shscripts");
    _ = ::std::fs::copy(HOME.join(".profile"), "./.profile");
    _ = ::std::fs::copy(HOME.join(".zprofile"), "./.zprofile");
    _ = ::std::fs::copy(HOME.join(".bashrc"), "./.bashrc");
    _ = ::std::fs::copy(HOME.join(".zshrc"), "./.zshrc");
    _ = ::std::fs::copy(HOME.join(".config/nvim/init.vim"), "./.config/nvim/init.vim");
    _ = copy_dir_all(HOME.join(".config/nvim/lua"), "./.config/nvim/lua");
    _ = copy_dir_all(HOME.join(".config/nvim/vim"), "./.config/nvim/vim");
    _ = copy_dir_all(HOME.join(".config/nvim/ftplugin"), "./.config/nvim/ftplugin");
    _ = ::std::fs::copy(HOME.join("bin/viman"), "./bin/viman");
    _ = ::std::fs::copy(HOME.join("bin/vipage"), "./bin/vipage");
    _ = ::std::fs::copy(HOME.join("bin/inverting.sh"), "./bin/inverting.sh");
    _ = ::std::fs::copy(HOME.join("bin/ls"), "./bin/ls");
    _ = ::std::fs::copy(HOME.join("bin/n"), "./bin/n");
    #[allow(non_snake_case)] let VIMRUNTIME = if ::which::which("nvim").is_ok() {
        if cfg!(target_os = "windows") {
            "/c/Program Files/Neovim/share/nvim/runtime"
        } else {
            if is_termux {
                "/data/data/com.termux/files/usr/share/nvim/runtime"
            } else {
                "/usr/share/nvim/runtime"
            }
        }.to_string()
    } else {
        find_vim_vimruntime_path(is_termux)
    };
    let VIMRUNTIME = ::std::path::Path::new(VIMRUNTIME.as_str());
    _ = ::std::fs::create_dir_all("./vimruntime/syntax");
    _ = run_as_superuser_if_needed!("cp", &[VIMRUNTIME.join("syntax/book.vim").to_str().expect("Cannot convert path to str"), "./vimruntime/syntax/"]);
    _ = ::std::fs::create_dir_all("./vimruntime/colors");
    _ = run_as_superuser_if_needed!("cp", &[VIMRUNTIME.join("colors/blueorange.vim").to_str().expect("Cannot convert path to str"), "./vimruntime/colors/"]);
    _ = ::std::fs::copy(HOME.join(".config/nvim/vim/xterm-color-table.vim"), "./.config/nvim/vim/xterm-color-table.vim");
    _ = ::std::fs::copy(HOME.join(".tmux.conf"), "./.tmux.conf");
    _ = ::std::fs::copy(HOME.join(".gitconfig-default"), "./.gitconfig-default");
    _ = ::std::fs::copy(HOME.join(".gitmessage"), "./.gitmessage");
    _ = ::std::fs::copy(HOME.join(".termux/colors.properties"), "./.termux/colors.properties");
    _ = ::std::fs::copy(HOME.join(".termux/termux.properties"), "./.termux/termux.properties");
    _ = copy_dir_all(HOME.join(".config/alacritty"), "./.config/alacritty");
    _ = ::std::fs::copy(HOME.join(".nanorc"), "./.nanorc");
    _ = ::std::fs::copy(HOME.join(".config/coc/extensions/node_modules/bash-language-server/out/cli.js"), "./\"coc-sh crutch\"/");
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

fn init(home: PathBuf) -> ::std::io::Result<()> {
    let home_str = home.clone().into_os_string().into_string().expect("Cannot convert os_string into string");
    if ::std::env::var("GOPATH") == Err(::std::env::VarError::NotPresent) {
        ::std::env::set_var("GOPATH", format!("{}/go", home_str));
    }
    if ::std::env::var("GOBIN") == Err(::std::env::VarError::NotPresent) {
        ::std::env::set_var("GOBIN", format!("{}/go", home_str));
    }
    ::std::env::set_var("PATH", format!("{}:{}",
            ::std::env::var("PATH").expect("Cannot get $PATH environment variable"),
            ::std::env::var("GOBIN").expect("Cannot get $PATH environment variable")));

    ::std::env::set_var("HISTSIZE", "5000");
    ::std::env::set_var("DISPLAY", "0");
    if ::std::path::Path::new("/data/data/com.termux/files/usr/lib/libtermux-exec.so").exists() {
        ::std::env::set_var("LD_PRELOAD", "/data/data/com.termux/files/usr/lib/libtermux-exec.so");
    }

    if ::std::env::var("XDG_CONFIG_HOME") == Err(::std::env::VarError::NotPresent) {
        ::std::env::set_var("XDG_CONFIG_HOME", format!("{}/.config", home_str));
    }
    if ::std::env::var("PREFIX") == Err(::std::env::VarError::NotPresent) {
        ::std::env::set_var("PREFIX", "/usr");
    }
    if ::std::env::var("JAVA_HOME") == Err(::std::env::VarError::NotPresent) {
        ::std::env::set_var("JAVA_HOME", format!("{}/share/jdk8", ::std::env::var("PREFIX").expect("Cannot get environment variable")));
    }

    crate::colors::init();

    let mut timer = timer_start_silent();

    ::std::env::set_var("VISUAL", "nvim");
    ::std::env::set_var("EDITOR", "nvim");

    if ::which::which("most").is_ok() {
        ::std::env::set_var("PAGER", "most");
    } else if ::which::which("less").is_ok() {
        ::std::env::set_var("PAGER", "less");
    } else {
        ::std::env::set_var("PAGER", "more");
    }

    let mut f = ::std::fs::File::create(home.join("bin/ls"))?;
    if ::which::which("lsd").is_ok() {
        _ = f.write_all(b"#!/bin/env sh\nlsd $@");
    } else {
        _ = f.write_all(b"#!/bin/env sh\nls $@");
    }

    if ::std::env::var("ZSH_VERSION").is_ok() {
        _ = ::std::process::Command::new("autoload -Uz compinit").spawn();
        _ = ::std::process::Command::new("compinit").spawn();
        _ = ::std::process::Command::new("compdef _directories md").spawn();
        _ = ::std::process::Command::new("compdef _directories nd").spawn();
    }

    print!("\x1b[5 q");

    timer_end_silent(&mut timer);

    let mut sys = ::sysinfo::System::new_all();
    sys.refresh_all();
    let disks = ::sysinfo::Disks::new_with_refreshed_list();
    let disk_free_space = &disks.last().expect("Cannot get last element of an array").available_space();
    timer_total_time(&mut timer, &format!("free space: {}{} GiB{} loading time",
            ::std::env::var("YELLOW_COLOR").expect("Cannot get environment variable"),
            *disk_free_space as f64 / 1_000_000_000.0f64,
            ::std::env::var("RESET_COLOR").expect("Cannot get environment variable")));

    let todo_path = home.join("todo");
    if todo_path.exists() {
        let content = ::std::fs::read_to_string(todo_path).expect("Cannot read file");
        if content.is_empty() {
            eprintln!("[ERROR] todo_is_empty");
        } else {
            println!("[NOTE] todo file: {}", content);
        }
    }
    Ok(())
}

fn version() {
    println!(include_str!("../../../.dotfiles-version"));
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
        INIT,
        VERSION,
    }
    #[allow(non_snake_case)] let HOME = match ::home::home_dir() {
        Some(path) => path,
        None => panic!("Cannot get HOME directory"),
    };
    {
        let path_to_dotfiles = HOME.as_path().join("dotfiles");
        assert!(::std::env::set_current_dir(&path_to_dotfiles).is_ok());
    }
    let mut state = State::NONE;
    while args.len() > 0 {
        match args.nth(0).unwrap().as_str() {
            "--help"|"help" => {
                help!(program_name);
                ::std::process::exit(0);
            },
            "commit" => {
                match state {
                    State::NONE => {
                        state = State::COMMIT{only_copy: false};
                    },
                    _ => {
                        eprintln!("Subcommands can be used only with first cmdline argument");
                        short_help!(program_name);
                        ::std::process::exit(1);
                    },
                }
            },
            "init" => {
                match state {
                    State::NONE => {
                        state = State::INIT;
                    },
                    _ => {
                        eprintln!("Subcommands can be used only with first cmdline argument");
                        short_help!(program_name);
                        ::std::process::exit(1);
                    },
                }
            },
            "version"|"--version"|"-V" => {
                match state {
                    State::NONE => {
                        state = State::VERSION;
                    },
                    _ => {
                        eprintln!("Subcommands can be used only with first cmdline argument");
                        short_help!(program_name);
                        ::std::process::exit(1);
                    },
                }
            },
            "--only-copy" => {
                match state {
                    State::COMMIT { only_copy: _ } => {
                        state = State::COMMIT { only_copy: true };
                    },
                    _ => {
                        eprintln!("This option can only be used with `commit` subcommand");
                        short_help!(program_name);
                        ::std::process::exit(1);
                    },
                }
            },
            "++only-copy" => {
                match state {
                    State::COMMIT { only_copy: _ } => {
                        state = State::COMMIT { only_copy: false };
                    },
                    _ => {
                        println!("This option can only be used with `commit` subcommand");
                        short_help!(program_name);
                        ::std::process::exit(1);
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
            match commit(only_copy, HOME) {
                Ok(_) => {
                    ::std::process::exit(0);
                },
                Err(e) => {
                    println!("error: {}", e);
                    ::std::process::exit(1);
                },
            };
        },
        State::INIT => {
            match init(HOME) {
                Ok(_) => {
                    ::std::process::exit(0);
                },
                Err(e) => {
                    println!("error: {}", e);
                    ::std::process::exit(1);
                },
            };
        },
        State::VERSION => {
            version();
        },
    }
}
