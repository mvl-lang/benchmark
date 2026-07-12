#!/bin/bash
# Performance Benchmark Test Runner
#
# Runs all performance benchmarks with side-by-side comparison.
#
# Usage: ./test-all.sh [--go-only] [--mvl-only]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GO_ONLY=false
MVL_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --go-only)
            GO_ONLY=true
            shift
            ;;
        --mvl-only)
            MVL_ONLY=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "═══════════════════════════════════════════════════════════════"
echo "  Performance Benchmark Suite"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Actor benchmarks - use makefiles for proper timing
echo "── Actor Benchmarks ──"
echo ""

for dir in "$SCRIPT_DIR"/actors/*/; do
    name=$(basename "$dir")
    echo "[$name]"

    if [[ "$MVL_ONLY" != "true" ]] && [[ -f "$dir/Makefile" ]]; then
        cd "$dir"
        make bench-go 2>&1 | grep -E "Throughput|Latency|Time:" | head -3 | sed 's/^/  Go:  /'
        cd - >/dev/null
    fi

    if [[ "$GO_ONLY" != "true" ]] && [[ -f "$dir/Makefile" ]]; then
        cd "$dir"
        make bench-mvl 2>&1 | grep -E "Throughput|Latency|Time:|Note:" | head -4 | sed 's/^/  MVL: /'
        cd - >/dev/null
    fi

    echo ""
done

# String benchmarks
echo "── String Benchmarks ──"
echo ""

for dir in "$SCRIPT_DIR"/strings/*/; do
    name=$(basename "$dir")
    echo "[$name]"

    if [[ "$GO_ONLY" != "true" ]]; then
        if [[ -f "$dir/bench.mvl" ]]; then
            echo -n "  MVL: "
            cd "$dir"
            if mvl check bench.mvl &>/dev/null; then
                result=$(timeout 10 mvl run bench.mvl 2>&1) || result="[TIMEOUT]"
                if echo "$result" | grep -qi "error\|fail\|timeout"; then
                    echo "[FAIL] $result"
                else
                    echo "[PASS] Compiles and runs"
                fi
            else
                echo "[FAIL] Check failed"
            fi
            cd - >/dev/null
        fi
    fi

    echo ""
done

echo "═══════════════════════════════════════════════════════════════"
echo "  Summary"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Go benchmarks test true async channel/goroutine communication."
echo "MVL benchmarks test iterative loops (actors use sync dispatch)."
echo ""
echo "Run individual benchmarks for full output: cd actors/ping_pong && make bench"
