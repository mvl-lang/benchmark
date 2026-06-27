# MVL Benchmark Suite
#
# Usage:
#   make test-cve      Run CVE replication tests
#   make test-cwe      Run CWE comparative matrix
#   make test-all      Run all benchmark suites
#   make report        Generate metrics report

.PHONY: all test-cve test-cve-compare test-cwe test-rosetta test-llm test-all report clean help

all: help

help:
	@echo "MVL Benchmark Suite"
	@echo ""
	@echo "Usage:"
	@echo "  make test-cve          Run CVE replication tests (MVL only)"
	@echo "  make test-cve-compare  Run CVE tests with vulnerable versions"
	@echo "  make test-cve-explain  Run CVE tests with explanations"
	@echo "  make test-cwe          Run CWE comparative matrix"
	@echo "  make test-rosetta      Run Rosetta translation tests"
	@echo "  make test-llm          Run adversarial LLM tests"
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

# CWE Comparative Matrix (placeholder)
test-cwe:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  CWE Comparative Matrix"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Status: Not yet implemented"
	@echo "  TODO: Create vulnerability snippets for CWE Top 25"
	@test -d cwe_comparative && ls cwe_comparative/ || echo "  Directory empty"

# Rosetta Translation (placeholder)
test-rosetta:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Rosetta Translation Tests"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Status: Not yet implemented"
	@echo "  TODO: Port standard tasks from Rosetta Code"
	@test -d rosetta && ls rosetta/ || echo "  Directory empty"

# Adversarial LLM (placeholder)
test-llm:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Adversarial LLM Tests"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "  Status: Not yet implemented"
	@echo "  TODO: Generate and test LLM-written MVL programs"
	@test -d adversarial_llm && ls adversarial_llm/ || echo "  Directory empty"

# Run all tests
test-all: test-cve test-cwe test-rosetta test-llm

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
	@echo "CWE Comparative:"
	@echo "  Cases: $$(ls cwe_comparative/*.mvl 2>/dev/null | wc -l | tr -d ' ') (TODO)"
	@echo ""
	@echo "Rosetta:"
	@echo "  Tasks: $$(ls rosetta/*.mvl 2>/dev/null | wc -l | tr -d ' ') (TODO)"
	@echo ""
	@echo "Adversarial LLM:"
	@echo "  Programs: $$(ls adversarial_llm/*.mvl 2>/dev/null | wc -l | tr -d ' ') (TODO)"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	find cve_replication -name "*.o" -delete 2>/dev/null || true
	find cve_replication -name "*_demo" -delete 2>/dev/null || true
	find cve_replication -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "Done."
