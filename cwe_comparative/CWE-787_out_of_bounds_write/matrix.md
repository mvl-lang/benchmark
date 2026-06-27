# CWE-787: Out-of-bounds Write

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| C | ❌ Silent | - | No bounds checking, UB |
| Go | ⚠️ Runtime | Panic | Bounds checked at runtime |
| Rust (safe) | ✅ Compile | Borrow checker | Forces explicit bounds handling |
| Rust (unsafe) | ❌ Silent | - | unsafe bypasses checks |
| TypeScript | ⚠️ Runtime | Exception | Array bounds checked at runtime |
| **MVL** | ✅ Compile | Type system | Slices carry bounds, checked ops |

## Analysis

**C**: No protection. `strcpy`, `memcpy`, direct array access all allow overflow.

**Go**: Runtime panic prevents exploitation but program crashes. Better than silent corruption.

**Rust (safe)**: Compiler forces you to handle bounds explicitly. Can't compile code that might overflow without handling the case.

**Rust (unsafe)**: `std::ptr::copy_nonoverlapping` etc. can overflow. Same risk as C.

**MVL**: Slices are the only way to access contiguous memory. All slice operations are bounds-checked. No raw pointers, no escape hatch.
