# MVL Benchmark Suite
#
# Usage:
#   make test-cve      Run CVE replication tests
#   make test-cwe      Run CWE comparative matrix
#   make test-all      Run all benchmark suites
#   make report        Generate metrics report

.PHONY: all test-cve test-cve-compare test-cwe test-rosetta test-llm test-perf test-all report clean help

all: help

help:
	@echo "MVL Benchmark Suite"
	@echo ""
	@echo "Usage:"
	@echo "  make test-cve          Run CVE replication tests (MVL only)"
	@echo "  make test-cve-compare  Run CVE tests with vulnerable versions"
	@echo "  make test-cve-explain  Run CVE tests with explanations"
	@echo "  make test-cwe          Run CWE/OWASP comparative matrix"
	@echo "  make test-rosetta      Run Rosetta translation tests"
	@echo "  make test-llm          Run adversarial LLM tests"
	@echo "  make test-perf         Run performance benchmarks"
	@echo "  make test-all          Run all benchmark suites"
	@echo "  make report            Generate metrics report"
	@echo "  make clean             Clean build artifacts"

# CVE Replication Tests
test-cve:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Running CVE Replication Tests (MVL only)"
	@echo "═══════════════════════════════════════════════════════════════"
	cd cve_replication && ./run_tests.sh

test-cve-compare:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Running CVE Replication Tests (vulnerable + MVL comparison)"
	@echo "═══════════════════════════════════════════════════════════════"
	cd cve_replication && ./run_tests.sh --compare --verbose

test-cve-explain:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Running CVE Replication Tests (with explanations)"
	@echo "═══════════════════════════════════════════════════════════════"
	cd cve_replication && ./run_tests.sh --explain

# CWE Comparative Matrix
test-cwe:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  CWE / OWASP Comparative Matrix"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo ""
	@for dir in cwe_comparative/CWE-*/ cwe_comparative/OWASP-*/; do \
		if [ -d "$$dir" ]; then \
			name=$$(basename "$$dir"); \
			mvl_file="$$dir/attempt.mvl"; \
			if [ -f "$$mvl_file" ]; then \
				result=$$(mvl check "$$mvl_file" 2>&1); \
				if echo "$$result" | grep -q "OK"; then \
					echo "  ✅ $$name"; \
				else \
					echo "  ❌ $$name (compile error)"; \
				fi; \
			else \
				echo "  ⚠️  $$name (no attempt.mvl)"; \
			fi; \
		fi; \
	done
	@echo ""
	@echo "  Cases: $$(ls -d cwe_comparative/CWE-*/ cwe_comparative/OWASP-*/ 2>/dev/null | wc -l | tr -d ' ')"

# Rosetta Translation
test-rosetta:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Rosetta Translation Tests"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo ""
	@for f in rosetta/*.mvl; do \
		if [ -f "$$f" ]; then \
			name=$$(basename "$$f" .mvl); \
			result=$$(mvl check "$$f" 2>&1); \
			if echo "$$result" | grep -q "OK"; then \
				echo "  ✅ $$name"; \
			else \
				echo "  ❌ $$name"; \
			fi; \
		fi; \
	done
	@echo ""
	@echo "  Tasks: $$(ls rosetta/*.mvl 2>/dev/null | wc -l | tr -d ' ')"

# Adversarial LLM
test-llm:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Adversarial LLM Tests"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo ""
	@for f in adversarial_llm/*.mvl; do \
		if [ -f "$$f" ]; then \
			name=$$(basename "$$f" .mvl); \
			result=$$(mvl check "$$f" 2>&1); \
			if echo "$$result" | grep -q "OK"; then \
				echo "  ✅ $$name"; \
			else \
				echo "  ❌ $$name"; \
			fi; \
		fi; \
	done
	@echo ""
	@echo "  Programs: $$(ls adversarial_llm/*.mvl 2>/dev/null | wc -l | tr -d ' ')"

# Performance benchmarks
test-perf:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Performance Benchmarks"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo ""
	@echo "Actors:"
	@for dir in performance/actors/*/; do \
		if [ -d "$$dir" ]; then \
			name=$$(basename "$$dir"); \
			echo "  - $$name"; \
		fi; \
	done
	@echo ""
	@echo "Strings:"
	@for dir in performance/strings/*/; do \
		if [ -d "$$dir" ]; then \
			name=$$(basename "$$dir"); \
			echo "  - $$name"; \
		fi; \
	done
	@echo ""
	@echo "Run individual benchmarks:"
	@echo "  cd performance/actors/ping_pong && make bench"
	@echo "  cd performance/actors/ring && make bench"

# Run all tests
test-all: test-cve test-cwe test-rosetta test-llm test-perf

# Generate report
report:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Benchmark Report"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo ""
	@echo "CVE Replication:"
	@echo "  Cases: $$(ls -d cve_replication/CVE-*/ 2>/dev/null | wc -l | tr -d ' ')"
	@echo "  Languages: C, Go, Java, Python, Rust, MVL"
	@echo ""
	@echo "CWE / OWASP Comparative:"
	@echo "  CWE cases: $$(ls -d cwe_comparative/CWE-*/ 2>/dev/null | wc -l | tr -d ' ')"
	@echo "  OWASP cases: $$(ls -d cwe_comparative/OWASP-*/ 2>/dev/null | wc -l | tr -d ' ')"
	@echo "  Languages: C, Go, Rust, TypeScript, Python, MVL"
	@echo ""
	@echo "Rosetta:"
	@echo "  Tasks: $$(ls rosetta/*.mvl 2>/dev/null | wc -l | tr -d ' ')"
	@echo ""
	@echo "Adversarial LLM:"
	@echo "  Programs: $$(ls adversarial_llm/*.mvl 2>/dev/null | wc -l | tr -d ' ')"
	@echo ""
	@echo "Performance:"
	@echo "  Actor benchmarks: $$(ls -d performance/actors/*/ 2>/dev/null | wc -l | tr -d ' ')"
	@echo "  String benchmarks: $$(ls -d performance/strings/*/ 2>/dev/null | wc -l | tr -d ' ')"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	find cve_replication -name "*.o" -delete 2>/dev/null || true
	find cve_replication -name "*_demo" -delete 2>/dev/null || true
	find cve_replication -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "Done."
