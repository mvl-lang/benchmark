# MVL Benchmark Suites

Empirical evaluation of MVL's security and correctness guarantees.

## Suites

### 1. CVE Replication (`cve_replication/`)

Reproduce real CVEs in MVL and demonstrate compile-time rejection.

**Structure:** Each CVE gets a directory with:
- `vulnerable.c` / `vulnerable.go` / etc. — original vulnerable pattern
- `attempt.mvl` — MVL equivalent that MUST fail to compile
- `expected_error.txt` — which compiler stage rejects it and why
- `analysis.md` — CVE details, root cause, why MVL prevents it

**Goal:** "MVL would have prevented CVE-XXXX-YYYY at compile time"

### 2. CWE Comparative (`cwe_comparative/`)

CWE Top 25 / OWASP Top 10 matrix across languages.

**Structure:** Each weakness gets:
- Deliberately vulnerable snippets in C, Go, Rust, TypeScript, MVL
- Score: compile-time reject / runtime reject / undetected

**Goal:** Defendable matrix showing rejection rates per language

### 3. Rosetta Translation (`rosetta/`)

Port standard programming tasks to MVL.

**Metrics:**
- Lines of code
- Annotation density (types, effects, refinements)
- Build time
- Features other languages can't express

**Goal:** Demonstrate expressiveness empirically

### 4. Adversarial LLM (`adversarial_llm/`)

LLM-generated MVL programs across domains.

**Metrics:**
- % compile clean
- % needed human fixes
- Classes of compile errors

**Goal:** Validate "Req 8-11 are free for LLMs" claim

## Running

```bash
# Run all CVE tests (expect failures = success)
make test-cve

# Run comparative matrix
make test-cwe

# Generate metrics report
make report
```

## Evidence Axes

Each suite maps to Paper 3's 11 requirements:

| Suite | Primary Requirements Tested |
|-------|----------------------------|
| CVE Replication | R3 (memory), R4 (IFC), R6 (effects), R11 (OWASP) |
| CWE Comparative | R11 (OWASP), R3-R10 (type system features) |
| Rosetta | R1 (minimal), R2 (LLM-friendly), R8 (inference) |
| Adversarial LLM | R2 (LLM-friendly), R8 (inference), R9 (errors) |
