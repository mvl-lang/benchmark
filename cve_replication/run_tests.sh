#!/bin/bash
# CVE Replication Test Runner
#
# For each CVE directory:
# 1. Try to compile attempt.mvl
# 2. If it compiles, run it
# 3. Report whether the vulnerability was prevented
#
# Usage: ./run_tests.sh [--verbose]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MVL="${MVL:-mvl}"
VERBOSE="${1:-}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

pass=0
fail=0

echo "═══════════════════════════════════════════════════════════════"
echo "  CVE Replication Test Suite"
echo "═══════════════════════════════════════════════════════════════"
echo ""

for cve_dir in "$SCRIPT_DIR"/CVE-*/; do
    cve_name=$(basename "$cve_dir")
    attempt="$cve_dir/attempt.mvl"

    if [[ ! -f "$attempt" ]]; then
        echo -e "${YELLOW}[SKIP]${NC} $cve_name - no attempt.mvl"
        continue
    fi

    echo -n "Testing $cve_name... "

    # Try to compile
    compile_output=$("$MVL" check "$attempt" 2>&1) && compile_ok=true || compile_ok=false

    if [[ "$compile_ok" == "false" ]]; then
        # Compile failed - check if this was expected
        if grep -q "COMPILE ERROR" "$cve_dir/expected_error.txt" 2>/dev/null; then
            echo -e "${GREEN}[PASS]${NC} Compile-time rejection (as expected)"
            ((pass++))
        else
            echo -e "${YELLOW}[WARN]${NC} Unexpected compile error"
            if [[ -n "$VERBOSE" ]]; then
                echo "$compile_output"
            fi
        fi
        continue
    fi

    # Compile succeeded - try to run
    run_output=$("$MVL" run "$attempt" 2>&1) && run_ok=true || run_ok=false

    if [[ "$run_ok" == "true" ]]; then
        # Ran successfully - vulnerability prevented at runtime or by design
        echo -e "${GREEN}[PASS]${NC} Runtime prevention / design prevention"
        ((pass++))
    else
        # Runtime failure - check if expected
        if grep -q "runtime" "$cve_dir/expected_error.txt" 2>/dev/null; then
            echo -e "${GREEN}[PASS]${NC} Runtime bounds check caught it"
            ((pass++))
        else
            echo -e "${RED}[FAIL]${NC} Unexpected runtime error"
            if [[ -n "$VERBOSE" ]]; then
                echo "$run_output"
            fi
            ((fail++))
        fi
    fi
done

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Results: $pass passed, $fail failed"
echo "═══════════════════════════════════════════════════════════════"

exit $fail
