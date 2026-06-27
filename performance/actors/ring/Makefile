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
	$(GO) run bench.go

bench-mvl:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  MVL Actors Ring"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  (Not yet runnable - actor spawn syntax pending)"
	$(MVL) check bench.mvl

clean:
	rm -f bench_go
