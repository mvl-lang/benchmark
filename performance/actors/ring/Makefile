# Ring Actor Benchmark

GO ?= go
MVL ?= mvl

.PHONY: all bench bench-go bench-mvl clean

all: bench

bench: bench-go bench-mvl

bench-go:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Go Goroutines Ring"
	@echo "═══════════════════════════════════════════════════════════════"
	@if command -v $(GO) >/dev/null 2>&1; then \
		$(GO) run bench.go; \
	else \
		echo "  [SKIP] Go not installed"; \
	fi

bench-mvl:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  MVL Actors Ring"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Note: Ring topology requires circular refs"
	@echo "  MVL actors use one-way ownership; would need supervisor pattern"
	$(MVL) run bench.mvl

clean:
	rm -f bench_go
