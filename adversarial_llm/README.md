# Adversarial LLM Tests

LLM-generated MVL programs to test compiler ergonomics and error messages.

## Purpose

Test the claim: "MVL requirements R8-R11 are free for LLMs" — meaning an LLM can generate correct MVL code without explicit prompting for safety features.

## Methodology

1. Prompt an LLM with a task description (no MVL-specific guidance)
2. Record whether the generated code compiles
3. If not, categorize the error
4. Track how many iterations to fix

## Metrics

- **% compile clean**: First-attempt success rate
- **% fixable in 1 iteration**: After seeing error message
- **Error categories**: Syntax, type, ownership, termination, etc.

## Current Programs

| Program | Domain | First Compile | Iterations | Notes |
|---------|--------|---------------|------------|-------|
| url_parser | Web | ❌ | 2 | Missing type annotation |
| json_validator | Data | ❌ | 1 | Termination clause |

## Running

```bash
# From benchmark root
make test-llm

# Or check individual programs
mvl check adversarial_llm/url_parser.mvl
```
