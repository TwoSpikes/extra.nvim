pub fn init() {
    ::std::env::set_var("RESET_COLOR", format!("\x1b[0m"));
    ::std::env::set_var("GRAY_COLOR", format!("\x1b[90m"));
    ::std::env::set_var("RED_COLOR", format!("\x1b[91m"));
    ::std::env::set_var("GREEN_COLOR", format!("\x1b[92m"));
    ::std::env::set_var("YELLOW_COLOR", format!("\x1b[93m"));
    ::std::env::set_var("BLUE_COLOR", format!("\x1b[94m"));
    ::std::env::set_var("VIOLET_COLOR", format!("\x1b[95m"));
    ::std::env::set_var("LIGHT_BLUE_COLOR", format!("\x1b[96m"));
    ::std::env::set_var("WHITE_COLOR", format!("\x1b[97m"));
    ::std::env::set_var("GRAY_BACK_COLOR", format!("\x1b[100m"));
    ::std::env::set_var("RED_BACK_COLOR", format!("\x1b[101m"));
    ::std::env::set_var("GREEN_BACK_COLOR", format!("\x1b[102m"));
    ::std::env::set_var("YELLOW_BACK_COLOR", format!("\x1b[103m"));
    ::std::env::set_var("BLUE_BACK_COLOR", format!("\x1b[104m"));
    ::std::env::set_var("VIOLET_BACK_COLOR", format!("\x1b[105m"));
    ::std::env::set_var("LIGHT_BLUE_BACK_COLOR", format!("\x1b[106m"));
    ::std::env::set_var("WHITE_BACK_COLOR", format!("\x1b[107m"));
}
