#!/bin/bash
# Performance Benchmark Test Runner
#
# Runs all performance benchmarks and summarizes results.
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

# Actor benchmarks
echo "── Actor Benchmarks ──"
echo ""

for dir in "$SCRIPT_DIR"/actors/*/; do
    name=$(basename "$dir")
    echo "[$name]"

    if [[ "$MVL_ONLY" != "true" ]]; then
        if [[ -f "$dir/bench.go" ]] && command -v go &>/dev/null; then
            echo -n "  Go:  "
            cd "$dir"
            result=$(go run bench.go 2>&1)
            throughput=$(echo "$result" | grep -i "throughput" | head -1)
            echo "$throughput"
            cd - >/dev/null
        else
            echo "  Go:  [SKIP] go not installed or no bench.go"
        fi
    fi

    if [[ "$GO_ONLY" != "true" ]]; then
        if [[ -f "$dir/bench.mvl" ]]; then
            echo -n "  MVL: "
            cd "$dir"
            if mvl check bench.mvl &>/dev/null; then
                result=$(mvl run bench.mvl 2>&1)
                if echo "$result" | grep -qi "error\|fail"; then
                    echo "[FAIL] Transpile/runtime error"
                else
                    echo "$(echo "$result" | tail -1)"
                fi
            else
                echo "[FAIL] Check failed"
            fi
            cd - >/dev/null
        fi
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
echo "Go baseline benchmarks show raw channel performance."
echo "MVL actor benchmarks demonstrate patterns but need:"
echo "  - Circular reference support for ping-pong/ring"
echo "  - Timing APIs for proper measurement"
echo ""
echo "See README.md for target performance goals."
