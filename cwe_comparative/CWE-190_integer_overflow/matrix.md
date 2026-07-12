# CWE-190: Integer Overflow or Wraparound

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| C | ❌ Silent | - | Unsigned wraps; signed overflow is UB |
| Go | ❌ Silent | - | All integer types wrap silently |
| Rust (debug) | ⚠️ Runtime | Panic | Overflow panics in debug builds only |
| Rust (release) | ❌ Silent | - | Wraps silently with `*`; must use `.checked_mul()` manually |
| **MVL** | ✅ Compile | Solver | Refinement types bound inputs; solver proves product is safe |

## Analysis

**C**: Unsigned integer overflow is defined (wraps mod 2^n); signed overflow is undefined behaviour. Neither is caught by default. The classic exploit: `malloc(count * size)` where the product wraps to a small number, followed by writes that corrupt the heap.

**Go**: All integer arithmetic wraps on overflow with no runtime check or compiler warning. The behaviour is defined but silently produces the wrong result.

**Rust (debug)**: Integer overflow panics in debug builds. In release builds, Rust uses wrapping arithmetic for performance — the same silent wraparound as C. Developers must manually use `.checked_mul()` or `.saturating_mul()`.

**Rust (release)**: The default `*` operator wraps. Safe overflow handling requires deliberate use of checked/saturating/wrapping variants — easy to forget under pressure.

**MVL**: Refinement types express upper bounds on inputs (`GridDim = Int where self <= 4096`). The SMT solver verifies at every call site that the constraint holds and that arithmetic on bounded values cannot overflow 64-bit `Int`. No runtime check needed — proven at compile time.

## Key Insight

Rust moves overflow detection to debug builds but removes it in release mode. MVL uses refinement types to make overflow structurally impossible: if the inputs are bounded, the solver proves the product is in range before the program compiles.
