# OWASP A02: Cryptographic Failures

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| Python | ❌ Silent | - | hashlib.md5() available |
| Go | ❌ Silent | - | crypto/md5 available |
| Rust | ❌ Silent | - | Any crate can be used |
| **MVL** | ✅ Compile | Effects + Types | Weak algos not in stdlib |

## Common Failures

| Failure | Traditional Fix | MVL Prevention |
|---------|-----------------|----------------|
| Weak hash (MD5/SHA1) | Code review | Not in HashAlgo enum |
| Hardcoded keys | Secrets scanning | KeySource requires env/vault |
| Missing salt | Developer discipline | Required parameter |
| Homegrown crypto | Policy | Only stdlib Crypto effect |

## Key Insight

Cryptographic failures happen because the dangerous options are available. MVL removes them from the API surface.
