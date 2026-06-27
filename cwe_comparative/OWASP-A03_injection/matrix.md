# OWASP A03: Injection

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| C | ❌ Silent | - | system() takes any string |
| Python | ❌ Silent | - | subprocess with shell=True |
| Go | ❌ Silent | - | os/exec available everywhere |
| Rust | ❌ Silent | - | std::process available everywhere |
| **MVL** | ✅ Compile | Effects | Shell access requires effect declaration |

## Analysis

**The Problem**: In most languages, any function can execute shell commands. There's no compile-time visibility into which code paths touch the shell.

```python
# Python - any function can do this
def innocent_looking_function(user_input):
    subprocess.run(f"echo {user_input}", shell=True)  # Hidden shell access
```

**MVL's Approach**:

1. **Effect declaration**: Shell access requires `! Shell` effect. It's visible in the function signature.

2. **Effect propagation**: If `foo` calls `bar` and `bar` has `! Shell`, then `foo` must also declare `! Shell` or handle it.

3. **IFC labels**: User input is `Untrusted`. Shell commands require `Trusted`. The boundary is explicit.

## Injection Types Covered

| Type | Traditional Fix | MVL Prevention |
|------|-----------------|----------------|
| SQL | Parameterized queries | IFC + type-safe builders |
| Command | Input validation | Effect system blocks shell access |
| LDAP | Escape special chars | IFC labels on queries |
| XPath | Parameterized XPath | Type-safe query builders |

## Key Insight

Injection requires two things: (1) reaching a dangerous sink (shell, DB, etc.) and (2) flowing untrusted data to it. MVL blocks both:
- Effects control which code can reach dangerous sinks
- IFC controls which data can flow to dangerous sinks
