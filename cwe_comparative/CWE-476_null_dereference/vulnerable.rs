// CWE-476: NULL Pointer Dereference (Rust: .unwrap() on None panics)
struct User {
    id: u32,
    name: String,
}

fn find_user(id: u32) -> Option<User> {
    if id == 42 {
        Some(User { id: 42, name: "alice".to_string() })
    } else {
        None
    }
}

fn main() {
    // PANIC: called `Option::unwrap()` on a `None` value
    let u = find_user(99).unwrap();
    println!("User: {}", u.name);
}
