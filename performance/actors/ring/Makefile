# Actor Chain Benchmark
# Go: 100-node goroutine ring (1M hops)
# MVL: 10-node actor chain (100K hops × 10 = 1M messages)

GO ?= go
MVL ?= mvl

.PHONY: all bench bench-go bench-mvl clean

all: bench

bench: bench-go bench-mvl

bench-go:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Go Goroutines Ring (100 nodes, 1M hops)"
	@echo "═══════════════════════════════════════════════════════════════"
	@if command -v $(GO) >/dev/null 2>&1; then \
		$(GO) run bench.go; \
	else \
		echo "  [SKIP] Go not installed"; \
	fi

bench-mvl:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  MVL Actor Chain (10 nodes, 100K hops = 1M messages)"
	@echo "═══════════════════════════════════════════════════════════════"
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
