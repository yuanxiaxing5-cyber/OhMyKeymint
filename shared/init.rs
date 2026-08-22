use log::error;
use std::panic;

pub fn setup_panic_hook() {
    panic::set_hook(Box::new(|panic_info| {
        error!("Fatal runtime panic occurred: {panic_info}");
    }));
}
pub fn apply_log_level(level_str: &str) {
    let level = level_str
        .trim()
        .parse()
        .unwrap_or(log::LevelFilter::Debug);
    log::set_max_level(level);
}

