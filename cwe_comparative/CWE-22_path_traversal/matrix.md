# CWE-22: Improper Limitation of a Pathname to a Restricted Directory (Path Traversal)

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| C | ❌ Silent | - | `snprintf` + `fopen` follow `..` with no validation |
| Go | ❌ Silent | - | `filepath.Join` resolves `..`; no taint tracking |
| Rust | ❌ Silent | - | `Path::join` resolves `..`; no taint tracking |
| **MVL** | ✅ Compile | IFC/Type | `Tainted[String]` cannot flow to file ops without explicit relabel |

## Analysis

**C**: `fopen` and `snprintf`-built paths have no built-in validation. Concatenating user input with a base directory is the standard pattern and is always vulnerable unless the developer manually checks for `..`.

**Go**: `filepath.Join` *resolves* `..` components — it does not strip them. `filepath.Join("/var/www/files", "../../etc/passwd")` returns `/etc/passwd`. Even `filepath.Clean` cannot help if the path is absolute after joining; a prefix check on the canonical path is required — and easy to forget.

**Rust**: `Path::join` behaves the same way. If the user-supplied component contains `..`, the joined path escapes the base directory. Safe file access requires `canonicalize()` + prefix checking — no language-level enforcement.

**MVL**: User input arrives as `Tainted[String]`. File operations accept `String`, not `Tainted[String]`. The only bridge is `relabel trust(x, "tag")`, which is explicit, named, and grep-auditable. After relabeling, validation is the developer's responsibility — but the structure forces the question at the exact boundary where it matters.

## Key Insight

All three other languages have path APIs that silently follow `..`. The developer must remember to validate every time. MVL's IFC labels make the trust boundary a type-level fact: you cannot accidentally pass user input to a file operation — you must consciously cross the boundary with `relabel`, and that crossing is visible in every code review.
