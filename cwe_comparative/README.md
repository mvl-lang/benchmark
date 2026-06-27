# CWE Comparative Matrix

Compare how different languages handle common weakness enumerations (CWEs).

## Structure

Each CWE gets a directory with:
- `vulnerable.c` / `vulnerable.go` / `vulnerable.rs` / `vulnerable.ts` — vulnerable patterns
- `attempt.mvl` — MVL version (should fail to compile or be safe by design)
- `matrix.md` — comparison table showing detection at each stage

## Scoring

| Score | Meaning |
|-------|---------|
| ✅ Compile | Rejected at compile time |
| ⚠️ Runtime | Caught at runtime (panic, exception) |
| ❌ Silent | Vulnerability executes without detection |

## Current CWEs

| CWE | Name | C | Go | Rust | TS | MVL |
|-----|------|---|----|----|----|----|
| CWE-787 | Out-of-bounds Write | ❌ | ⚠️ | ✅ | ⚠️ | ✅ |
| CWE-89 | SQL Injection | ❌ | ❌ | ❌ | ❌ | ✅ |

## Running

```bash
# From benchmark root
make test-cwe

# Or directly
./run_matrix.sh
```
