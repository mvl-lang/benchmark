# Actor Message Passing Benchmark
# Go: Goroutines with channels (1M round-trips = 2M messages)
# MVL: Actor method calls (10 workers × 100K = 1M messages)

GO ?= go
MVL ?= mvl

.PHONY: all bench bench-go bench-mvl clean

all: bench

bench: bench-go bench-mvl

bench-go:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Go Goroutines (1M round-trips = 2M messages)"
	@echo "═══════════════════════════════════════════════════════════════"
	@if command -v $(GO) >/dev/null 2>&1; then \
		$(GO) run bench.go; \
	else \
		echo "  [SKIP] Go not installed"; \
	fi

bench-mvl:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  MVL Actors (10 workers × 100K = 1M messages)"
	@echo "═══════════════════════════════════════════════════════════════"
	@# Pre-compile to warm cache, then time the run
	@$(MVL) check bench.mvl >/dev/null 2>&1
	@start=$$(python3 -c "import time; print(int(time.time()*1000))"); \
	$(MVL) run bench.mvl 2>&1 | grep -v "^Transpiled\|^Running:\|^Compiling\|^Finished\|^Downloading\|^Locking\|^Adding"; \
	end=$$(python3 -c "import time; print(int(time.time()*1000))"); \
	elapsed=$$((end - start)); \
	msgs=1000000; \
	if [ $$elapsed -gt 0 ]; then \
		throughput=$$((msgs * 1000 / elapsed)); \
		latency_ns=$$((elapsed * 1000000 / msgs)); \
		echo "Time: $${elapsed}ms"; \
		echo "Throughput: $${throughput} msgs/sec"; \
		echo "Latency: $${latency_ns} ns/msg"; \
	fi

clean:
	@echo "Clean complete"
