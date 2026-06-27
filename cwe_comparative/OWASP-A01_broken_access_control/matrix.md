# OWASP A01: Broken Access Control

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| C | ❌ Silent | - | No auth framework |
| Go | ❌ Silent | - | Auth checks optional |
| Rust | ❌ Silent | - | Auth checks optional |
| TypeScript | ❌ Silent* | - | Decorators help but not enforced |
| **MVL** | ✅ Compile | IFC | Labels enforce authorization |

*TypeScript with NestJS guards can help, but nothing prevents bypassing them.

## Analysis

**The Problem**: Most languages let you access data without any authorization check. The check is a convention, not a requirement.

```go
// Go - nothing forces you to check
func getUser(targetID int) *User {
    return users[targetID]  // Oops, forgot auth check
}
```

**MVL's Approach**: 

1. **IFC Labels**: Data is labeled with required access level. Accessing Private data from Public context is a compile error.

2. **Type-enforced checks**: Functions that access protected data require an `AuthContext` parameter. Can't call without it.

3. **Effect system (future)**: `! AuthRequired` effect makes authorization visible in function signatures.

## Key Insight

Authorization failures are the #1 OWASP risk because they're easy to forget. MVL makes forgetting a compile error.
