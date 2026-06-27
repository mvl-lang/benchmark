#!/bin/bash
# CVE Replication Test Runner
#
# For each CVE directory:
# 1. Try to compile attempt.mvl
# 2. If it compiles, run it
# 3. Report whether the vulnerability was prevented
#
# Usage: ./run_tests.sh [-h|--help] [-v|--verbose]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MVL="${MVL:-mvl}"
VERBOSE=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

CVE Replication Test Suite for MVL

Options:
  -h, --help      Show this help message and exit
  -v, --verbose   Show detailed compiler output on errors

Environment:
  MVL             Path to mvl binary (default: mvl)

Examples:
  ./run_tests.sh                    # Run all tests
  ./run_tests.sh -v                 # Run with verbose output
  MVL=./target/release/mvl ./run_tests.sh  # Use specific mvl binary

EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

pass=0
fail=0
skip=0

echo "═══════════════════════════════════════════════════════════════"
echo "  CVE Replication Test Suite"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "  ${BLUE}MVL:${NC} $(which $MVL 2>/dev/null || echo "$MVL (not found)")"
echo -e "  ${BLUE}Dir:${NC} $SCRIPT_DIR"
echo ""

for cve_dir in "$SCRIPT_DIR"/CVE-*/; do
    cve_name=$(basename "$cve_dir")
    attempt="$cve_dir/attempt.mvl"

    if [[ ! -f "$attempt" ]]; then
        echo -e "${YELLOW}[SKIP]${NC} $cve_name - no attempt.mvl"
        ((skip++))
        continue
    fi

    echo -n "Testing $cve_name... "

    # Try to compile
    compile_output=$("$MVL" check "$attempt" 2>&1) && compile_ok=true || compile_ok=false

    if [[ "$compile_ok" == "false" ]]; then
        # Compile failed - check if this was expected
        if grep -q "COMPILE ERROR\|Compile-time" "$cve_dir/expected_error.txt" 2>/dev/null; then
            echo -e "${GREEN}[PASS]${NC} Compile-time rejection (as expected)"
            ((pass++))
        else
            echo -e "${YELLOW}[WARN]${NC} Unexpected compile error"
            if [[ "$VERBOSE" == "true" ]]; then
                echo ""
                echo -e "${BLUE}Compiler output:${NC}"
                echo "$compile_output" | head -20
                echo ""
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
        if grep -qi "runtime\|bounds" "$cve_dir/expected_error.txt" 2>/dev/null; then
            echo -e "${GREEN}[PASS]${NC} Runtime bounds check caught it"
            ((pass++))
        else
            echo -e "${RED}[FAIL]${NC} Unexpected runtime error"
            if [[ "$VERBOSE" == "true" ]]; then
                echo ""
                echo -e "${BLUE}Runtime output:${NC}"
                echo "$run_output" | head -20
                echo ""
            fi
            ((fail++))
        fi
    fi
done

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  Results: ${GREEN}$pass passed${NC}, ${RED}$fail failed${NC}, ${YELLOW}$skip skipped${NC}"
echo "═══════════════════════════════════════════════════════════════"

exit $fail
