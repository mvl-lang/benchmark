# Ping-Pong Actor Benchmark

GO ?= go
MVL ?= mvl
RUSTC ?= rustc

.PHONY: all bench bench-go bench-mvl bench-rust clean

all: bench

bench: bench-go bench-mvl

bench-go:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Go Goroutines Ping-Pong"
	@echo "═══════════════════════════════════════════════════════════════"
	@if command -v $(GO) >/dev/null 2>&1; then \
		$(GO) run bench.go; \
	else \
		echo "  [SKIP] Go not installed"; \
	fi

bench-mvl:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  MVL Actors Ping-Pong"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  (Not yet runnable - actor spawn syntax pending)"
	$(MVL) check bench.mvl

bench-rust:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Rust Channels Ping-Pong"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  (TODO: Add bench.rs)"

clean:
	rm -f bench_go bench_rust
