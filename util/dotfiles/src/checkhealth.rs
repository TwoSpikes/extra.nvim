use crate::timer::{timer_endln, timer_startln, timer_total_time};

pub fn check_for(program: &str) {
    print!("Checking for {}: ", program);

    if let Err(e) = ::std::process::Command::spawn(&mut ::std::process::Command::new(program)) {
        println!("Error: {}", e);
        try_install(program);
    }
}

pub fn try_install(_program: &str) {
    println!("try_install: Not implemented yet");
}

pub fn checkhealth() {
    let mut timer = timer_startln("checking needed stuff...");
    check_for("sh");
    timer_endln(&mut timer);
    timer_total_time(&mut timer, "checking stuff took");
}
