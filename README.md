# MVL Benchmark Suites

Empirical evaluation of MVL's security and correctness guarantees.

## Suites

### 1. CVE Replication (`cve_replication/`)

Reproduce real CVEs in MVL and demonstrate compile-time or design-level rejection.

**Structure:** Each CVE gets a directory with:
- `vulnerable.c` / `vulnerable.go` / etc. — original vulnerable pattern
- `attempt.mvl` — MVL equivalent showing how the language prevents the bug
- `expected_error.txt` — which mechanism prevents it (compiler, design, or runtime)
- `analysis.md` — CVE details, root cause, why MVL prevents it
- `Makefile` — `make run_original` (vulnerable) and `make run_mvl` (safe)

**Test runner:**
```bash
./run_tests.sh           # MVL only
./run_tests.sh -c        # Compare: run vulnerable + MVL versions
./run_tests.sh -e        # Show vulnerability explanations
./run_tests.sh -c -e -v  # Full comparison with explanations
```

**Current CVEs:**

| CVE | Name | Vulnerability Class | MVL Prevention |
|-----|------|---------------------|----------------|
| CVE-2014-0160 | Heartbleed | Buffer over-read | Bounds-checked slices (R3) |
| CVE-2021-44228 | Log4Shell | Injection/JNDI | No implicit string interpolation (R4) |
| CVE-2022-0847 | Dirty Pipe | Uninitialized memory | Mandatory struct initialization (R3) |
| CVE-2023-44487 | Rapid Reset | Resource exhaustion | Bounded resource pools, rate limiting |
| CVE-2024-3402 | LangChain | Prompt injection | IFC labels on untrusted data (R4) |
| CVE-2025-68260 | Rust Binder | Race condition | Actor model, no shared mutable state (R1) |

**Goal:** "MVL would have prevented CVE-XXXX-YYYY"

#### What This Proves

The CVE replication suite demonstrates that MVL's security guarantees are not theoretical — they prevent **real vulnerabilities that cost billions** in damages:

1. **Compile-time rejection**: Heartbleed, Log4Shell, and Dirty Pipe patterns are rejected by the MVL compiler. The vulnerable code cannot be written.

2. **Design-level prevention**: Rapid Reset and the Rust Binder race condition are prevented by MVL's actor model. The architecture makes these bug classes impossible.

3. **Runtime-aided safety**: Where compile-time checks aren't sufficient, MVL's runtime provides bounds checking and resource limits.

**Key insight from CVE-2025-68260**: Even Rust, with its borrow checker, allowed a race condition because the kernel uses `unsafe` extensively. MVL has no `unsafe` escape hatch — the safety guarantees apply to ALL code.

The suite covers multiple vulnerability classes:
- Memory safety (Heartbleed, Dirty Pipe)
- Injection (Log4Shell, LangChain)
- Concurrency (Rust Binder)
- Resource exhaustion (Rapid Reset)

Each class maps to specific MVL requirements (R1-R11), showing the language's security properties are comprehensive, not ad-hoc.

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
