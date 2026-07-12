// CWE-22: Path Traversal (Rust)
// Path::join does NOT sanitize ".." — it resolves components as-is
use std::fs;
use std::path::Path;

const BASE_DIR: &str = "/var/www/files";

fn read_file(user_filename: &str) {
    // BUG: join preserves ".." — path escapes the base directory
    // Path::new("/var/www/files").join("../../etc/passwd") = "/etc/passwd"
    let full_path = Path::new(BASE_DIR).join(user_filename);

    match fs::read_to_string(&full_path) {
        Ok(content) => println!("{}", content),
        Err(e) => println!("Error: {}", e),
    }
}

fn main() {
    read_file("../../etc/passwd");
}
