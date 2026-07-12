# MVL Benchmark Suite
#
# Usage:
#   make test-cve      Run CVE replication tests
#   make test-cwe      Run CWE comparative matrix
#   make test-all      Run all benchmark suites
#   make report        Generate metrics report

.PHONY: all test-cve test-cve-compare test-cwe test-requirements test-rosetta test-llm test-perf test-all report clean help

# ANSI colors (used via printf in recipes; use $$'\033' if invoking as raw shell)
GREEN := \033[0;32m
RED   := \033[0;31m
DIM   := \033[2m
NC    := \033[0m

all: help

help:
	@echo "MVL Benchmark Suite"
	@echo ""
	@echo "Usage:"
	@echo "  make test-cve          Run CVE replication tests (MVL only)"
	@echo "  make test-cve-compare  Run CVE tests with vulnerable versions"
	@echo "  make test-cve-explain  Run CVE tests with explanations"
	@echo "  make test-requirements Run all 11 MVL requirements showcase"
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

# Requirements Showcase
test-requirements:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  MVL Requirements Showcase (all 11 requirements)"
	@echo "═══════════════════════════════════════════════════════════════"
	requirements/run_tests.sh

# CWE Comparative Matrix
test-cwe:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  CWE / OWASP Comparative Matrix"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo ""
	@pass=0; fail=0; \
	for dir in cwe_comparative/CWE-*/ cwe_comparative/OWASP-*/; do \
		if [ -d "$$dir" ]; then \
			name=$$(basename "$$dir"); \
			mvl_file="$$dir/attempt.mvl"; \
			if [ -f "$$mvl_file" ]; then \
				result=$$(mvl check "$$mvl_file" 2>&1); \
				if echo "$$result" | grep -q "OK"; then \
					printf "  $(GREEN)✓$(NC)  %s\n" "$$name"; \
					pass=$$((pass + 1)); \
				else \
					printf "  $(RED)✗$(NC)  %s $(DIM)(compile error)$(NC)\n" "$$name"; \
					fail=$$((fail + 1)); \
				fi; \
			else \
				printf "  $(DIM)⚠  %s (no attempt.mvl)$(NC)\n" "$$name"; \
			fi; \
		fi; \
	done; \
	echo ""; \
	if [ $$fail -eq 0 ]; then \
		printf "  $(GREEN)✓  All $$pass cases passed$(NC)\n"; \
	else \
		printf "  $(RED)✗  $$fail of $$((pass + fail)) cases failed$(NC)\n"; \
	fi

# Rosetta Translation
test-rosetta:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Rosetta Translation Tests"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo ""
	@pass=0; fail=0; \
	for f in rosetta/*.mvl; do \
		if [ -f "$$f" ]; then \
			name=$$(basename "$$f" .mvl); \
			result=$$(mvl check "$$f" 2>&1); \
			if echo "$$result" | grep -q "OK"; then \
				printf "  $(GREEN)✓$(NC)  %s\n" "$$name"; \
				pass=$$((pass + 1)); \
			else \
				printf "  $(RED)✗$(NC)  %s\n" "$$name"; \
				fail=$$((fail + 1)); \
			fi; \
		fi; \
	done; \
	echo ""; \
	if [ $$fail -eq 0 ]; then \
		printf "  $(GREEN)✓  All $$pass tasks passed$(NC)\n"; \
	else \
		printf "  $(RED)✗  $$fail of $$((pass + fail)) tasks failed$(NC)\n"; \
	fi

# Adversarial LLM
test-llm:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Adversarial LLM Tests"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo ""
	@pass=0; fail=0; \
	for f in adversarial_llm/*.mvl; do \
		if [ -f "$$f" ]; then \
			name=$$(basename "$$f" .mvl); \
			result=$$(mvl check "$$f" 2>&1); \
			if echo "$$result" | grep -q "OK"; then \
				printf "  $(GREEN)✓$(NC)  %s\n" "$$name"; \
				pass=$$((pass + 1)); \
			else \
				printf "  $(RED)✗$(NC)  %s\n" "$$name"; \
				fail=$$((fail + 1)); \
			fi; \
		fi; \
	done; \
	echo ""; \
	if [ $$fail -eq 0 ]; then \
		printf "  $(GREEN)✓  All $$pass programs passed$(NC)\n"; \
	else \
		printf "  $(RED)✗  $$fail of $$((pass + fail)) programs failed$(NC)\n"; \
	fi

# Performance benchmarks
test-perf:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Performance Benchmarks"
	@echo "═══════════════════════════════════════════════════════════════"
	@pass=0; fail=0; \
	for group in actors strings; do \
		printf "\n$(DIM)── %s ──$(NC)\n" "$$group"; \
		for dir in performance/$$group/*/; do \
			[ -d "$$dir" ] || continue; \
			name=$$(basename "$$dir"); \
			tmp=$$(mktemp); \
			if $(MAKE) --no-print-directory -C "$$dir" bench > "$$tmp" 2>&1; then \
				grep -Ei '(bench|ns/op|ms|ops/sec|elapsed|time|iterations)' "$$tmp" | head -6 | sed 's/^/       /'; \
				printf "  $(GREEN)✓$(NC)  %s\n" "$$name"; \
				pass=$$((pass + 1)); \
			else \
				sed 's/^/       /' "$$tmp"; \
				printf "  $(RED)✗$(NC)  %s\n" "$$name"; \
				fail=$$((fail + 1)); \
			fi; \
			rm -f "$$tmp"; \
		done; \
	done; \
	echo ""; \
	if [ $$fail -eq 0 ]; then \
		printf "  $(GREEN)✓  All $$pass benchmarks passed$(NC)\n"; \
	else \
		printf "  $(RED)✗  $$fail of $$((pass + fail)) benchmarks failed$(NC)\n"; \
	fi

# Run all tests
test-all: test-cve test-requirements test-cwe test-rosetta test-llm test-perf

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
