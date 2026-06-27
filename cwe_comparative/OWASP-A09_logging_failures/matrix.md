# OWASP A09: Security Logging and Monitoring Failures

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| Go | ❌ Silent | - | log.Printf takes any string |
| Python | ❌ Silent | - | logging.info takes any string |
| Rust | ❌ Silent | - | log! macro takes any string |
| **MVL** | ✅ Compile | Effects + IFC | Structured logging, sensitive data blocked |

## Logging Failures Addressed

| Issue | Traditional Fix | MVL Prevention |
|-------|-----------------|----------------|
| Logging passwords | Code review | IFC blocks Sensitive → Log |
| Missing audit fields | Conventions | Required fields in AuditEvent |
| Log injection | Sanitization | Type-safe structured logging |
| No actor tracking | Developer discipline | Required actor_id field |

## Key Insight

Logging failures happen because logging APIs accept arbitrary strings. MVL uses:
1. **Effect system**: All logging through structured API
2. **IFC labels**: Sensitive data can't flow to logs
3. **Typed events**: Required fields enforced by compiler
