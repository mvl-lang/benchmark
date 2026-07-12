// CWE-190: Integer Overflow (Rust: panics in debug, wraps silently in release)
fn alloc_size(rows: u32, cols: u32, item_size: u32) -> u32 {
    // debug: arithmetic overflow panics
    // release (--release): wraps silently — same risk as C
    rows * cols * item_size
}

fn main() {
    let rows: u32 = 65537;
    let cols: u32 = 65537;
    // debug: panics; release: silently returns wrong (small) value
    let size = alloc_size(rows, cols, 1);
    println!("Size: {} bytes", size);
}
