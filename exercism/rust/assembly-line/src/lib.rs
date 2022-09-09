// This stub file contains items that aren't used yet; feel free to remove this module attribute
// to enable stricter warnings.
#![allow(unused)]

pub fn production_rate_per_hour(speed: u8) -> f64 {
    // unimplemented!("calculate hourly production rate at speed: {}", speed)
    if speed < 1 {
	println!("no cars produced");
	return 0.0;
	// might be a "between" function in rust I guess?
    } else if 1 <= speed && speed <= 4 {
	return 221.0 * speed as f64;
    } else if 5 <= speed && speed <= 8 {
	return (221.0 * speed as f64) * 0.9;
    } else if 9 <= speed && speed <= 10 {
	return (221.0 * speed as f64) * 0.77;
    } 

    return 0.0;
}

pub fn working_items_per_minute(speed: u8) -> u32 {
    // unimplemented!("calculate the amount of working items at speed: {}", speed)
    (production_rate_per_hour(speed) / 60.0) as u32
}
