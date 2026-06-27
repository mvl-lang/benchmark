# OWASP A04: Insecure Design

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| Go | ❌ Silent | - | Rate limiting is optional |
| Python | ❌ Silent | - | Rate limiting is optional |
| Rust | ❌ Silent | - | Rate limiting is optional |
| **MVL** | ✅ Compile | Types | Required parameters enforce design |

## Design Patterns

| Pattern | Traditional | MVL Approach |
|---------|-------------|--------------|
| Rate limiting | Middleware (optional) | Required type parameter |
| Quantity limits | Runtime validation | Refinement types |
| Fraud detection | External service | Effect system makes it visible |

## Key Insight

Insecure design happens when security controls are optional. MVL makes them required through the type system.
