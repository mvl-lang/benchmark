// CWE-787: Out-of-bounds Write
// Rust version - compile-time prevention in safe Rust

fn vulnerable_copy(input: &[u8]) {
    let mut buffer = [0u8; 10];

    // This would be a compile error - can't just index past bounds
    // buffer[..input.len()].copy_from_slice(input); // ERROR if input.len() > 10

    // Safe version - Rust forces you to handle the bounds:
    let len = std::cmp::min(input.len(), buffer.len());
    buffer[..len].copy_from_slice(&input[..len]);

    println!("Copied: {:?}", &buffer[..len]);
}

// With unsafe, you CAN have buffer overflows:
unsafe fn unsafe_copy(input: &[u8]) {
    let mut buffer = [0u8; 10];
    // This compiles but is UB if input.len() > 10
    std::ptr::copy_nonoverlapping(input.as_ptr(), buffer.as_mut_ptr(), input.len());
}

fn main() {
    vulnerable_copy(b"This is too long for the buffer!");
}
