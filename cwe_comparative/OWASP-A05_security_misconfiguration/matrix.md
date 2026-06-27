# OWASP A05: Security Misconfiguration

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| Python | ❌ Silent | - | Any config is valid |
| Go | ❌ Silent | - | Any config is valid |
| Rust | ❌ Silent | - | Any config is valid |
| **MVL** | ✅ Compile | Types | Smart constructors validate |

## Common Misconfigurations

| Issue | Traditional Fix | MVL Prevention |
|-------|-----------------|----------------|
| Debug in prod | Env var check | Environment enum + smart constructor |
| Default creds | Policy | Validation in constructor |
| Verbose errors | Code review | No stack trace field in response type |
| Wildcard CORS | Config review | Validation rejects "*" in production |

## Key Insight

Misconfiguration happens because bad configs are representable. MVL makes invalid configs unrepresentable (return None).
