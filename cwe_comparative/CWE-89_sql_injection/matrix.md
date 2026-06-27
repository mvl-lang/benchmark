# CWE-89: SQL Injection

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| C | ❌ Silent | - | sprintf into query string |
| Go | ❌ Silent* | - | fmt.Sprintf vulnerable, but safe APIs exist |
| Rust | ❌ Silent* | - | format! vulnerable, but safe APIs exist |
| TypeScript | ❌ Silent* | - | Template literals vulnerable, but ORMs help |
| **MVL** | ✅ Compile | IFC/Type | No string interpolation, parameterized by design |

*These languages have safe APIs available, but don't prevent the unsafe pattern.

## Analysis

**C**: No protection. `sprintf` and string concatenation are the default way to build queries.

**Go**: `database/sql` provides parameterized queries, but `fmt.Sprintf` is still available and commonly misused.

**Rust**: `sqlx` and `diesel` provide safe query builders, but nothing stops you from using `format!` with raw SQL.

**TypeScript**: ORMs like Prisma enforce safe patterns, but template literals can still be misused with raw SQL.

**MVL**: 
1. **Type-safe query builders**: The only way to construct queries is through parameterized builders.
2. **IFC labels**: User input is labeled `Untrusted` and cannot flow into query structures without explicit sanitization.
3. **No unsafe alternative**: There's no raw SQL string execution in the standard library.

## Key Insight

Most languages provide safe APIs but also allow unsafe patterns. Developers must choose correctly every time.

MVL makes the safe pattern the **only** pattern. Injection is prevented by construction, not discipline.
