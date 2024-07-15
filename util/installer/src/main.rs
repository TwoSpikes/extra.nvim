macro_rules! usage {
    ($program_name:expr) => {
        println!("{}: [OPTION]...", $program_name);
        println!("{}: [OPTION]... HOME", $program_name);
        println!();
        println!("OPTIONS (case sensitive):");
        println!("  --help -h   See this message");
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
fn install(target: ::std::path::PathBuf) -> ::std::io::Result<()> {
    let is_termux: bool = ::std::env::var("TERMUX_VERSION").is_ok();
    copy_dir_all("./.config/nvim", target.join(".config/nvim"))?;
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
    let vimruntime = ::std::path::Path::new(vimruntime.as_str());
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

    Ok(())
}

fn main() {
    let mut args = ::std::env::args();
    let program_name = &args.nth(0).expect("cannot get program name");

    match ::std::env::set_current_dir(
        match ::std::env::current_dir() {
            Ok(dir) => dir,
            Err(e) => {
                eprintln!("{}: error: Cannot get current directory: {}", program_name, e);
                ::std::process::exit(1);
            },
        }.parent().expect("Cannot get parent directory").parent().expect("Cannot get parent directory")
    ) {
        Ok(()) => (),
        Err(e) => {
            eprintln!("{}: error: Cannot set current directory: {}", program_name, e);
            ::std::process::exit(1);
        },
    }

    if args.len() > 1 {
        eprintln!("{}: Too many arguments: expected 1, found {}", program_name, args.len());
        usage!(program_name);
        ::std::process::exit(1);
    }
    let home = if args.len() == 0 {
        match ::home::home_dir() {
            Some(path) => path,
            None => {
                eprintln!("{}: error: Cannot get home directory", program_name);
                ::std::process::exit(1);
            },
        }
    } else {
        ::std::path::PathBuf::from(match args.nth(0) {
            Some(arg) => arg,
            None => {
                eprintln!("{}: Cannot get command line argument", program_name);
                usage!(program_name);
                ::std::process::exit(1);
            },
        })
    };
    match install(home) {
        Ok(()) => (),
        Err(e) => {
            eprintln!("{}: Failed to install: {}", program_name, e);
            ::std::process::exit(2);
        },
    };
}
