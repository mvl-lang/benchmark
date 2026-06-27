# OWASP A10: Server-Side Request Forgery (SSRF)

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| Python | ❌ Silent | - | urllib fetches any URL |
| Go | ❌ Silent | - | net/http fetches any URL |
| Rust | ❌ Silent | - | reqwest fetches any URL |
| **MVL** | ✅ Compile | Types + Capabilities | ValidatedUrl required |

## SSRF Attacks Prevented

| Attack | Traditional Fix | MVL Prevention |
|--------|-----------------|----------------|
| Internal service access | Blocklist | No Internal host type |
| Cloud metadata | IP filtering | Allowlist in capability |
| File access | Protocol filtering | Only Https scheme |
| DNS rebinding | Resolve-then-fetch | Validated at type level |

## Key Insight

SSRF happens because HTTP clients accept any URL string. MVL requires:
1. **ValidatedUrl type**: Must pass validation
2. **Allowlist capability**: Explicit list of allowed domains
3. **No internal hosts**: AllowedHost enum excludes internal
4. **HTTPS only**: Scheme enum excludes dangerous protocols
