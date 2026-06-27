# JSON Parse Benchmark

MVL ?= mvl

.PHONY: all bench bench-mvl clean

all: bench

bench: bench-mvl

bench-mvl:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  MVL JSON Parse"
	@echo "═══════════════════════════════════════════════════════════════"
	$(MVL) check bench.mvl
	@echo "  (Full benchmark requires complete parser implementation)"

clean:
	@echo "Nothing to clean"
