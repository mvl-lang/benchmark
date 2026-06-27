# OWASP A06: Vulnerable and Outdated Components

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| All | ❌ Silent | - | Supply chain is external |
| **MVL** | ⚠️ Partial | Tooling | Dependency auditing, not language-level |

## Analysis

This OWASP category is about **supply chain security**, not language design:
- Using libraries with known CVEs
- Not updating dependencies
- Not verifying package integrity

## MVL's Role

MVL can help at the **tooling** level, not language level:

1. **Dependency manifest**: Lockfile with hashes
2. **Audit command**: `mvl audit` checks dependencies against CVE databases
3. **Minimal stdlib**: Fewer dependencies = smaller attack surface
4. **Effect system**: Limits what dependencies can do (network, filesystem)

## Out of Scope

This is fundamentally a supply chain / ecosystem problem:
- SBOMs (Software Bill of Materials)
- Dependency scanning (Snyk, Dependabot)
- Container scanning
- Package signing

MVL follows the same patterns as Rust (cargo audit) and Go (govulncheck).

## No Code Sample

No vulnerable/safe code comparison because this isn't about code patterns.
