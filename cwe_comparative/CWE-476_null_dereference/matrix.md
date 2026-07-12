# CWE-476: NULL Pointer Dereference

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| C | ❌ Silent | - | No null safety; segfault at runtime |
| Go | ⚠️ Runtime | Panic | nil dereference panics; no compile-time guarantee |
| Rust (safe) | ⚠️ Runtime | Panic | Option<T> enforced but `.unwrap()` still panics |
| Rust (unsafe) | ❌ Silent | - | Raw pointer deref in unsafe bypasses checks |
| **MVL** | ✅ Compile | Type system | No null type; Option[T] requires match before access |

## Analysis

**C**: Any pointer can be NULL, and dereference produces undefined behaviour (segfault in practice). The compiler issues no warning without `-Wall`, and even then only for trivial cases.

**Go**: `nil` dereferences panic at runtime — better than UB, but still crashes the program. The type system offers no compile-time guarantee.

**Rust (safe)**: `Option<T>` is idiomatic, but `.unwrap()` and `.expect()` are valid and panic at runtime when called on `None`. The risk is not eliminated, only made explicit.

**Rust (unsafe)**: Raw pointer dereference inside `unsafe` blocks has the same behaviour as C.

**MVL**: `Option[T]` is the only way to represent an absent value. There is no null, no `.unwrap()`, and the compiler requires a `match` covering `None`. A `User` (non-Option) is guaranteed non-null by construction.

## Key Insight

Rust reduces null dereferences but doesn't eliminate them — `.unwrap()` on `None` panics. MVL removes both null *and* unwrap, so the absence of a value is always handled before the value is accessed.
