# Rosetta Translation

Port standard programming tasks to MVL to demonstrate expressiveness.

Tasks are selected from [Rosetta Code](https://rosettacode.org/).

## Metrics

For each task, we measure:
- **Lines of code**: Total lines (excluding comments)
- **Annotation density**: Type annotations / total tokens
- **Build time**: Time to compile
- **Unique features**: MVL features not available in other languages

## Current Tasks

| Task | Lines | Annotations | Notes |
|------|-------|-------------|-------|
| FizzBuzz | 18 | Low | Basic control flow |
| Fibonacci | 25 | Medium | Recursion + memoization |

## Running

```bash
# From benchmark root
make test-rosetta

# Or compile individual tasks
mvl check rosetta/fizzbuzz.mvl
mvl run rosetta/fizzbuzz.mvl
```
