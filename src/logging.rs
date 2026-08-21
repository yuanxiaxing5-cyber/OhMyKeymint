use std::sync::OnceLock;

use anyhow::Result;
use log::LevelFilter;

const DEFAULT_LOG_PATH: &str = "/data/misc/keystore/omk/logs/keymint.log";
const PATTERN: &str = "{d(%Y-%m-%d %H:%M:%S %Z)(utc)} [{h({l})}] {M} - {m}{n}";

static LOGGER_INIT: OnceLock<()> = OnceLock::new();

pub fn init_logger() {
    let _ = LOGGER_INIT.get_or_init(|| {
        if let Err(error) = init_logger_inner() {
            eprintln!("keymint logging failed to initialize: {error:#}");
        }
    });
}

fn init_logger_inner() -> Result<()> {
    // Use only android_logger (logcat). Disable file appender to avoid frequent
    // disk log writes. This preserves logcat output for debugging while
    // preventing growth of files under /data/misc/keystore/omk/logs/.
    let config = android_logger::Config::default()
        .with_max_level(LevelFilter::Trace)
        .with_tag("OhMyKeymint");

    let android_logger = android_logger::AndroidLogger::new(config);

    // Initialize logger with only the Android logger (no file logger).
    multi_log::MultiLogger::init(vec![Box::new(android_logger)], log::Level::Trace)?;
    log::set_max_level(LevelFilter::Debug);

    log::info!("keymint logging initialized with file appender disabled");

    Ok(())
}
