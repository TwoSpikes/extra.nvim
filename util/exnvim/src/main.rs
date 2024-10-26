use std::{io::Write, os::unix::fs::PermissionsExt};

mod setup;

macro_rules! usage {
    ($program_name:expr) => {
        println!("{}: [OPTION]...", $program_name);
        println!("{}: [OPTION]... HOME", $program_name);
        println!();
        println!("SUBCOMMANDS (case sensitive):");
        println!("  install        Install configs from extra.nvim repo");
        println!("  install-coc-sh-crutch");
        println!("                 Install only coc-sh crutch");
        println!("  commit         Commit changes to extra.nvim repo");
        println!("  setup          Generate config for extra.nvim");
        println!("  help           Show this message");
        println!("  version        Show version");
        println!("OPTIONS (case sensitive):");
        println!("  For `commit` subcommand:");
        println!("    --only_copy -o  Only copy files, do not do actual commit");
        println!("    ++only_copy +o  Do actual commit, default");
        println!("  For `install` subcommand:");
        println!("    --without-coc-sh-crutch -w  Do not install coc-sh crutch");
        println!("    ++without-coc-sh-crutch +w  Install coc-sh crutch (default)");
        println!("  For `install-coc-sh-crutch` subcommand:");
        println!("    --force -f      Reinstall coc-sh crutch if it is already installed");
        println!("    ++force +f      Do not reinstall coc-sh crutch (default)");
        println!("  --help -h         Show this message");
        println!("  --version -V      Show version");
    };
}

macro_rules! run_as_superuser_if_needed {
    ($name:expr, $args:expr) => {
        if ::whoami::realname() != "root"
            && !::std::env::var("TERMUX_VERSION")
                .expect("Cannot get envvar")
                .is_empty()
        {
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
fn copy_dir_all(
    src: impl AsRef<::std::path::Path> + ::std::convert::AsRef<::std::path::Path>,
    dst: impl AsRef<::std::path::Path> + ::std::convert::AsRef<::std::path::Path>,
) -> ::std::io::Result<()> {
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
    })
    .unwrap();
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
                None => true,
                Some(maxver) => version > maxver,
            } {
                maxver = Some(version);
            }
        }
    }
    format!("vim{}", maxver.unwrap())
}
fn install(
    target: ::std::path::PathBuf,
    vimruntime: ::std::path::PathBuf,
    with_coc_sh_crutch: bool,
) -> ::std::io::Result<()> {
    copy_dir_all("./.config/nvim", target.join(".config/nvim"))?;
    _ = run_as_superuser_if_needed!(
        "cp",
        &[
            "-r",
            "./vimruntime",
            format!("{}{}",
                vimruntime
                    .to_str()
                    .expect("Cannot convert path to str"),
                "/*",
            ).as_str(),
        ]
    );

    if with_coc_sh_crutch {
        install_coc_sh_crutch(target, false)
    } else {
        Ok(())
    }
}

fn install_coc_sh_crutch(
    home: ::std::path::PathBuf,
    force: bool,
) -> ::std::io::Result<()> {
    let coc_sh_crutch_file = home.join(".config/coc/extensions/node_modules/coc-sh/node_modules/bash-language-server/out/cli.js_crutch");
    let orig_cli_file = home.join(".config/coc/extensions/node_modules/coc-sh/node_modules/bash-language-server/out/cli.js");
    if !force && coc_sh_crutch_file.exists() {
        return Ok(());
    }
    ::std::fs::rename(orig_cli_file.clone(), coc_sh_crutch_file.clone())?;
    ::std::fs::copy("./coc-sh crutch/cli.js", orig_cli_file.clone())?;
    let mut perms = ::std::fs::metadata(orig_cli_file.clone())?.permissions();
    perms.set_mode(0o700);
    ::std::fs::set_permissions(orig_cli_file, perms)?;
    Ok(())
}
fn commit(from: ::std::path::PathBuf, vimruntime: ::std::path::PathBuf, only_copy: bool, program_name: &String) {
    _ = copy_dir_all(from.join(".config/nvim"), "./.config/nvim");
    _ = run_as_superuser_if_needed!(
        "cp",
        &[
            format!("{}/colors/blueorange.vim",
                vimruntime
                    .to_str()
                    .expect("Cannot convert path to str"),
            ).as_str(),
            "./vimruntime/colors/",
        ]
    );
    _ = run_as_superuser_if_needed!(
        "cp",
        &[
            format!("{}/syntax/book.vim",
                vimruntime
                    .to_str()
                    .expect("Cannot convert path to str"),
            ).as_str(),
            "./vimruntime/syntax/",
        ]
    );
    if !only_copy {
        match ::std::process::Command::new("git")
            .args(["commit", "--all", "--verbose"])
            .stdout(::std::process::Stdio::inherit())
            .stdin(::std::process::Stdio::inherit())
            .output()
        {
            Ok(_) => (),
            Err(e) => {
                eprintln!("{}: error: Cannot commit: {}",
                    program_name,
                    e
                );
                ::std::process::exit(2);
            },
        }
    } else {
        ()
    }
}

fn version() {
    println!(include_str!("../../../.exnvim-version"));
    ::std::process::exit(0);
}

fn main() {
    let mut args = ::std::env::args();
    let program_name = &args.nth(0).expect("cannot get program name");

    if args.len() == 0 {
        eprintln!("{}: Not enough arguments: expected 1, found 0", program_name);
        usage!(program_name);
        ::std::process::exit(1);
    }

    #[allow(non_camel_case_types)]
    enum State {
        NONE,
        INSTALL {
            with_coc_sh_crutch: bool,
        },
        INSTALL_COC_SH_CRUTCH {
            force: bool,
        },
        COMMIT {
            only_copy: bool,
        },
        SETUP,
        VERSION,
    }
    let mut state = State::NONE;
    while args.len() > 0 {
        match match args.nth(0) {
            Some(arg) => arg,
            None => {
                eprintln!("Cannot get first command line argument");
                ::std::process::exit(1);
            }
        }.as_str() {
            "help"|"--help"|"-h" => {
                usage!(program_name);
                ::std::process::exit(0);
            },
            "commit" => {
                match state {
                    State::NONE => {
                        state = State::COMMIT {
                            only_copy: false,
                        };
                    },
                    _ => {
                        eprintln!("Cannot use subcommand while using another subcommand");
                        usage!(program_name);
                        ::std::process::exit(1);
                    },
                }
            },
            "--only-copy" | "-o" => match state {
                State::COMMIT {
                    only_copy: _,
                } => {
                    state = State::COMMIT {
                        only_copy: true,
                    };
                }
                _ => {
                    eprintln!("This option can only be used with `commit` subcommand");
                    usage!(program_name);
                    ::std::process::exit(1);
                }
            },
            "++only-copy" | "+o" => match state {
                State::COMMIT {
                    only_copy: _,
                } => {
                    state = State::COMMIT {
                        only_copy: false,
                    };
                }
                _ => {
                    println!("This option can only be used with `commit` subcommand");
                    usage!(program_name);
                    ::std::process::exit(1);
                }
            },
            "install" => {
                match state {
                    State::NONE => {
                        state = State::INSTALL {
                            with_coc_sh_crutch: true,
                        };
                    },
                    _ => {
                        eprintln!("Cannot use subcommand while using another subcommand");
                        usage!(program_name);
                        ::std::process::exit(1);
                    },
                }
            },
            "--without-coc-sh-crutch"|"-w" => match state {
                State::INSTALL {
                    with_coc_sh_crutch: _,
                } => {
                    state = State::INSTALL {
                        with_coc_sh_crutch: false,
                    };
                }
                _ => {
                    eprintln!("This option can only be used with `install` subcommand");
                    usage!(program_name);
                    ::std::process::exit(1);
                }
            },
            "++without-coc-sh-crutch"|"+W" => match state {
                State::INSTALL {
                    with_coc_sh_crutch: _,
                } => {
                    state = State::INSTALL {
                        with_coc_sh_crutch: true,
                    };
                }
                _ => {
                    eprintln!("This option can only be used with `install` subcommand");
                    usage!(program_name);
                    ::std::process::exit(1);
                }
            },
            "install-coc-sh-crutch" => {
                match state {
                    State::NONE => {
                        state = State::INSTALL_COC_SH_CRUTCH {
                            force: false,
                        };
                    },
                    _ => {
                        eprintln!("Cannot use subcommand while using another subcommand");
                        usage!(program_name);
                        ::std::process::exit(1);
                    },
                }
            },
            "--force"|"-f" => match state {
                State::INSTALL_COC_SH_CRUTCH {
                    force: _,
                } => {
                    state = State::INSTALL_COC_SH_CRUTCH {
                        force: true,
                    };
                }
                _ => {
                    eprintln!("This option can only be used with `install-coc-sh-crutch` subcommand");
                    usage!(program_name);
                    ::std::process::exit(1);
                }
            },
            "++force"|"+f" => match state {
                State::INSTALL_COC_SH_CRUTCH {
                    force: _,
                } => {
                    state = State::INSTALL_COC_SH_CRUTCH {
                        force: false,
                    };
                }
                _ => {
                    eprintln!("This option can only be used with `install-coc-sh-crutch` subcommand");
                    usage!(program_name);
                    ::std::process::exit(1);
                }
            },
            "setup" => {
                match state {
                    State::NONE => {
                        state = State::SETUP;
                    },
                    _ => {
                        eprintln!("Cannot use subcommand while using another subcommand");
                        usage!(program_name);
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
                        eprintln!("Cannot use subcommand while using another subcommand");
                        usage!(program_name);
                        ::std::process::exit(1);
                    },
                }
            },
            &_ => {
                eprintln!("{}: Unknown argument", program_name);
                usage!(program_name);
                ::std::process::exit(1);
            }
        }
    }

    let home = match ::home::home_dir() {
        Some(path) => path,
        None => {
            eprintln!("{}: error: Cannot get home directory", program_name);
            ::std::process::exit(1);
        },
    };
    let is_termux: bool = ::std::env::var("TERMUX_VERSION").is_ok();
    let vimruntime = if ::which::which("nvim").is_ok() {
        if cfg!(target_os = "windows") {
            "/c/Program Files/Neovim/share/nvim/runtime"
        } else {
            if is_termux {
                "/data/data/com.termux/files/usr/share/nvim/runtime"
            } else {
                "/usr/share/nvim/runtime"
            }
        }
        .to_string()
    } else {
        find_vim_vimruntime_path(is_termux)
    };
    let vimruntime = ::std::path::PathBuf::from(vimruntime.as_str());

    match state {
        State::NONE => {
            eprintln!("{}: Internal error: No action provided", program_name);
            ::std::process::exit(1);
        },
        State::INSTALL {
            with_coc_sh_crutch,
        } => {
            match install(home, vimruntime, with_coc_sh_crutch) {
                Ok(()) => (),
                Err(e) => {
                    eprintln!("{}: Failed to install: {}", program_name, e);
                    ::std::process::exit(2);
                },
            };
        },
        State::INSTALL_COC_SH_CRUTCH {
            force,
        } => {
            match install_coc_sh_crutch(home, force) {
                Ok(()) => (),
                Err(e) => {
                    eprintln!("{}: Failed to install coc-sh crutch: {}", program_name, e);
                    ::std::process::exit(2);
                },
            };
        },
        State::COMMIT {only_copy} => {
            _ = commit(home, vimruntime, only_copy, program_name);
        },
        State::SETUP => {
            match crate::setup::setup(home) {
                Ok(()) => (),
                Err(e) => {
                    eprintln!("{}: Failed to setup: {}", program_name, e);
                    ::std::process::exit(2);
                }
            };
        },
        State::VERSION => {
            version();
        },
    }
}
