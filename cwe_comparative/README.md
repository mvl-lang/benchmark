# CWE Comparative Matrix

Compare how different languages handle common weakness enumerations (CWEs) and OWASP Top 10.

## Structure

Each weakness gets a directory with:
- `vulnerable.c` / `vulnerable.go` / `vulnerable.py` / etc. — vulnerable patterns
- `attempt.mvl` — MVL version (should fail to compile or be safe by design)
- `matrix.md` — comparison table showing detection at each stage

## Scoring

| Score | Meaning |
|-------|---------|
| ✅ Compile | Rejected at compile time |
| ⚠️ Runtime | Caught at runtime (panic, exception) |
| ❌ Silent | Vulnerability executes without detection |

## Current Cases

### CWE Top 25

| CWE | Name | C | Go | Rust | TS | MVL |
|-----|------|---|----|----|----|----|
| CWE-787 | Out-of-bounds Write | ❌ | ⚠️ | ✅ | ⚠️ | ✅ |
| CWE-89 | SQL Injection | ❌ | ❌ | ❌ | ❌ | ✅ |

### OWASP Top 10 (2021)

| OWASP | Name | Status | MVL Prevention |
|-------|------|--------|----------------|
| A01 | Broken Access Control | ✅ | IFC labels enforce authorization |
| A03 | Injection | ✅ | Effects block shell/DB; IFC blocks untrusted data |

## OWASP ↔ CWE Mapping

| OWASP | Related CWEs | MVL Feature |
|-------|--------------|-------------|
| A01 Broken Access Control | CWE-284, CWE-285, CWE-639 | IFC labels |
| A02 Cryptographic Failures | CWE-259, CWE-327, CWE-331 | Effect system (Crypto effect) |
| A03 Injection | CWE-79, CWE-89, CWE-94 | IFC + Effects |
| A04 Insecure Design | — | Type-driven development |
| A05 Security Misconfiguration | CWE-16, CWE-611 | Compile-time config validation |
| A06 Vulnerable Components | — | (Out of scope - supply chain) |
| A07 Auth Failures | CWE-287, CWE-384 | IFC + session types |
| A08 Integrity Failures | CWE-502, CWE-829 | IFC labels on deserialized data |
| A09 Logging Failures | CWE-778 | Effect system (Log effect) |
| A10 SSRF | CWE-918 | IFC + network effects |

## Running

```bash
# From benchmark root
make test-cwe

# Or directly
./run_matrix.sh
```
