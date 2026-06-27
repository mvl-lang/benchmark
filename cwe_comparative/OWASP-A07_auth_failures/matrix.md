# OWASP A07: Identification and Authentication Failures

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| Go | ❌ Silent | - | Session expiry is optional |
| Python | ❌ Silent | - | Session expiry is optional |
| Rust | ❌ Silent | - | Session expiry is optional |
| **MVL** | ✅ Compile | Types | Expiry is required field |

## Auth Failures Addressed

| Issue | Traditional Fix | MVL Prevention |
|-------|-----------------|----------------|
| No session expiry | Developer discipline | Required field in Session type |
| Weak session IDs | Use crypto lib | Crypto effect for ID generation |
| No rate limiting | Middleware | Required LoginState parameter |
| Missing MFA | Feature flag | MfaRequired in LoginResult enum |
| Session fixation | Rotate on login | Type system tracks session state |

## Key Insight

Auth failures happen when security features are optional. MVL makes them required through the type system - you can't create a Session without an expiry.
