// This stub file contains items that aren't used yet; feel free to remove this module attribute
// to enable stricter warnings.
#![allow(unused)]

/// various log levels
#[derive(Clone, PartialEq, Eq, Debug)]
pub enum LogLevel {
    Info,
    Warning,
    Error,
}
/// primary function for emitting logs
pub fn log(level: LogLevel, message: &str) -> String {
    // unimplemented!("return a message for the given log level")
    match level {
	LogLevel::Info => return info(message),
	LogLevel::Warning => return warn(message),
	LogLevel::Error => return error(message),
    }
}
pub fn info(message: &str) -> String {
    // unimplemented!("return a message for info log level")
    String::from("[INFO]: ") + message
}
pub fn warn(message: &str) -> String {
    // unimplemented!("return a message for warn log level")
    String::from("[WARNING]: ") + message
}
pub fn error(message: &str) -> String {
    // unimplemented!("return a message for error log level")
    String::from("[ERROR]: ") + message
}
