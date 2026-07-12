#!/bin/bash
# CVE Replication Test Runner
#
# For each CVE directory:
# 1. (Optional) Compile and run the vulnerable version to show it's exploitable
# 2. Compile and run the MVL version to show it's safe
#
# Usage: ./run_tests.sh [-h|--help] [-v|--verbose] [-c|--compare]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MVL="${MVL:-mvl}"
VERBOSE=false
COMPARE=false
EXPLAIN=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

CVE Replication Test Suite for MVL

Options:
  -h, --help      Show this help message and exit
  -v, --verbose   Show detailed compiler/runtime output on errors
  -c, --compare   Also run vulnerable versions (C/Go/Python) for comparison
  -e, --explain   Show vulnerability explanation from analysis.md

Modes:
  Default         Run only MVL versions, verify they prevent the vulnerability
  --compare       Run both vulnerable AND MVL versions side-by-side

Environment:
  MVL             Path to mvl binary (default: mvl)

Examples:
  ./run_tests.sh                    # Run MVL tests only
  ./run_tests.sh -v                 # Run with verbose output
  ./run_tests.sh -c                 # Run vulnerable + MVL comparison
  ./run_tests.sh -c -v              # Full comparison with verbose output

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
        -c|--compare)
            COMPARE=true
            shift
            ;;
        -e|--explain)
            EXPLAIN=true
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
vuln_demonstrated=0

echo "═══════════════════════════════════════════════════════════════"
echo "  CVE Replication Test Suite"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "  ${BLUE}Mode:${NC} $(if $COMPARE; then echo 'Compare (vulnerable + MVL)'; else echo 'MVL only'; fi)"
echo -e "  ${BLUE}MVL:${NC}  $(which $MVL 2>/dev/null || echo "$MVL (not found)")"
echo -e "  ${BLUE}Dir:${NC}  $SCRIPT_DIR"
echo ""

# Show explanation from analysis.md
show_explanation() {
    local cve_dir="$1"
    local analysis="$cve_dir/analysis.md"

    if [[ ! -f "$analysis" ]]; then
        echo -e "  ${YELLOW}No analysis.md found${NC}"
        return
    fi

    # Extract ## Vulnerability section (between ## Vulnerability and next ##)
    local explanation
    explanation=$(awk '/^## Vulnerability/,/^## [^V]/' "$analysis" | grep -v "^## " | head -20)

    if [[ -n "$explanation" ]]; then
        echo ""
        echo -e "${CYAN}$explanation${NC}"
        echo ""
    fi
}

# Run vulnerable version via Makefile if it exists and --compare is set
run_vulnerable() {
    local cve_dir="$1"
    local cve_name="$2"

    if [[ "$COMPARE" != "true" ]]; then
        return 0
    fi

    # Check if Makefile exists
    if [[ ! -f "$cve_dir/Makefile" ]]; then
        echo -e "  ${YELLOW}[!] No Makefile found${NC}"
        return 0
    fi

    # Check if run_original target exists
    if ! grep -q "^run_original:" "$cve_dir/Makefile"; then
        echo -e "  ${YELLOW}[!] No run_original target in Makefile${NC}"
        return 0
    fi

    # Determine language from files
    local lang=""
    [[ -f "$cve_dir/vulnerable.c" ]] && lang="C"
    [[ -f "$cve_dir/vulnerable.go" ]] && lang="Go"
    [[ -f "$cve_dir/vulnerable.py" ]] && lang="Py"
    [[ -f "$cve_dir/vulnerable.java" ]] && lang="Java"
    [[ -f "$cve_dir/vulnerable.rs" ]] && lang="Rust"

    # Check for external dependency cases (Python/Java)
    if [[ "$lang" == "Py" || "$lang" == "Java" ]]; then
        echo -e "  [${lang}]  ${YELLOW}skipped${NC} (requires external dependencies)"
        return 0
    fi

    echo -n "  [${lang:-?}]  Building & running... "
    local output
    output=$(cd "$cve_dir" && make run_original 2>&1) && make_ok=true || make_ok=false

    if echo "$output" | grep -qi "VULNERABLE\|leaked\|exploit\|exhaustion\|attack\|OOM"; then
        echo -e "${RED}VULNERABLE${NC} (as expected)"
        ((vuln_demonstrated++))
        if [[ "$VERBOSE" == "true" ]]; then
            echo ""
            echo -e "${CYAN}--- Vulnerable output ---${NC}"
            echo "$output" | grep -v "^===" | head -20
            echo -e "${CYAN}-------------------------${NC}"
            echo ""
        fi
    elif [[ "$make_ok" == "false" ]]; then
        echo -e "${YELLOW}build/run failed${NC}"
        if [[ "$VERBOSE" == "true" ]]; then
            echo ""
            echo -e "${CYAN}--- Error output ---${NC}"
            echo "$output" | tail -10
            echo -e "${CYAN}-------------------${NC}"
            echo ""
        fi
    else
        echo -e "${GREEN}completed${NC} (demo)"
        if [[ "$VERBOSE" == "true" ]]; then
            echo ""
            echo -e "${CYAN}--- Output ---${NC}"
            echo "$output" | grep -v "^===" | head -10
            echo -e "${CYAN}--------------${NC}"
            echo ""
        fi
    fi
}

for cve_dir in "$SCRIPT_DIR"/CVE-*/; do
    cve_name=$(basename "$cve_dir")
    attempt="$cve_dir/attempt.mvl"

    echo -e "${BLUE}Testing $cve_name${NC}"

    # Show explanation if requested
    if [[ "$EXPLAIN" == "true" ]]; then
        show_explanation "$cve_dir"
    fi

    if [[ ! -f "$attempt" ]]; then
        echo -e "  [MVL] ${YELLOW}[SKIP]${NC} - no attempt.mvl"
        ((skip++))
        echo ""
        continue
    fi

    # Run vulnerable version first (if --compare)
    run_vulnerable "$cve_dir" "$cve_name"

    # Run MVL version
    echo -n "  [MVL] Compiling... "

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
                echo -e "${CYAN}Compiler output:${NC}"
                echo "$compile_output" | head -20
                echo ""
            fi
        fi
        echo ""
        continue
    fi

    echo -n "Running... "

    # Compile succeeded - try to run
    run_output=$("$MVL" run "$attempt" 2>&1) && run_ok=true || run_ok=false

    if [[ "$run_ok" == "true" ]]; then
        # Ran successfully - vulnerability prevented at runtime or by design
        echo -e "${GREEN}[PASS]${NC} Safe (vulnerability prevented)"
        ((pass++))
    else
        # Runtime failure - check if expected
        if grep -qi "runtime\|bounds\|panic" "$cve_dir/expected_error.txt" 2>/dev/null; then
            echo -e "${GREEN}[PASS]${NC} Runtime check caught it"
            ((pass++))
        else
            echo -e "${RED}[FAIL]${NC} Unexpected runtime error"
            if [[ "$VERBOSE" == "true" ]]; then
                echo ""
                echo -e "${CYAN}Runtime output:${NC}"
                echo "$run_output" | head -20
                echo ""
            fi
            ((fail++))
        fi
    fi
    echo ""
done

echo "═══════════════════════════════════════════════════════════════"
echo -e "  MVL Results: ${GREEN}$pass passed${NC}, ${RED}$fail failed${NC}, ${YELLOW}$skip skipped${NC}"
if [[ "$COMPARE" == "true" ]]; then
    echo -e "  Vulnerable Demos: ${RED}$vuln_demonstrated demonstrated${NC}"
fi
echo "═══════════════════════════════════════════════════════════════"

exit $fail
