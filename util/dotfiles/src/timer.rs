#[derive(Clone)]
pub struct Timer {
    pub start_time:                 ::std::time::SystemTime,
    pub current_section_start_time: ::std::time::SystemTime,
}

pub fn to_timer_human_time(time: ::std::time::SystemTime) -> String {
    format!("{} ms", time.duration_since(::std::time::SystemTime::UNIX_EPOCH).expect("Time is before Unix epoch").as_micros() as f64 / 1000.0f64)
}

pub fn timer_start_silent() -> Timer {
    let now_time = ::std::time::SystemTime::now();
    return Timer {
        start_time:                 now_time,
        current_section_start_time: now_time,
    };
}
pub fn timer_start(message: &str) -> Timer {
    print!("[INFO] {}", message);
    return timer_start_silent();
}
pub fn timer_startln(message: &str) -> Timer {
    println!("[INFO] {}", message);
    return timer_start_silent();
}

pub fn timer_end_silent(timer: &mut Timer) -> ::std::time::SystemTime {
    let now_time = ::std::time::SystemTime::now();
    let took = now_time - timer.current_section_start_time.duration_since(::std::time::SystemTime::UNIX_EPOCH).expect("Time is before Unix epoch");
    timer.current_section_start_time = now_time;
    return took;
}
pub fn timer_end(timer: &mut Timer) {
    let took = timer_end_silent(timer);
    print!(" (took {}{}{})",
        ::std::env::var("YELLOW_COLOR").expect("Cannot get environment variable"),
        to_timer_human_time(took),
        ::std::env::var("RESET_COLOR").expect("Cannot get environment variable"));
}
pub fn timer_endln(timer: &mut Timer) {
    let took = timer_end_silent(timer);
    println!("[INFO] Took {}{}{}",
        ::std::env::var("YELLOW_COLOR").expect("Cannot get environment variable"),
        to_timer_human_time(took),
        ::std::env::var("RESET_COLOR").expect("Cannot get environment variable"));
}

pub fn timer_total_time(timer: &mut Timer, message: &str) {
    let now_time = ::std::time::SystemTime::now();
    let took = now_time - timer.start_time.duration_since(::std::time::SystemTime::UNIX_EPOCH).expect("Time is before Unix epoch");
    let took = to_timer_human_time(took);

    println!("[INFO] {}: {}{}{}",
        message,
        ::std::env::var("YELLOW_COLOR").expect("Cannot get environment variable"),
        took,
        ::std::env::var("RESET_COLOR").expect("Cannot get environment variable"));
}
