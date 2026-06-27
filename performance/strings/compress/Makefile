# Compression Benchmark

MVL ?= mvl

.PHONY: all bench bench-mvl clean

all: bench

bench: bench-mvl

bench-mvl:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  MVL RLE Compression"
	@echo "═══════════════════════════════════════════════════════════════"
	$(MVL) check bench.mvl
	$(MVL) run bench.mvl

clean:
	@echo "Nothing to clean"
