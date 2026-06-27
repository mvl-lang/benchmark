# OWASP A08: Software and Data Integrity Failures

## Summary

| Language | Detection | Stage | Notes |
|----------|-----------|-------|-------|
| Python | ❌ Silent | - | pickle executes arbitrary code |
| Java | ❌ Silent | - | ObjectInputStream is dangerous |
| Go | ⚠️ Partial | - | encoding/gob safer but not type-checked |
| **MVL** | ✅ Compile | Types | Typed deserialization only |

## Integrity Failures Addressed

| Issue | Traditional Fix | MVL Prevention |
|-------|-----------------|----------------|
| Insecure deserialization | Avoid pickle | No arbitrary deserialize |
| Schema violations | Runtime validation | Type-enforced parsing |
| Unsigned updates | Policy | SignedData wrapper type |
| Data provenance | Manual tracking | IFC labels |

## Key Insight

Integrity failures happen when data flows from untrusted sources without validation. MVL's type system and IFC labels make the data's origin and validation state explicit.
