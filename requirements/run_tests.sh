#!/usr/bin/env bash
# Requirements showcase test runner
# Verifies that each REQ-N showcase.mvl passes `mvl check`

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MVL="${MVL:-mvl}"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;34m'
NC='\033[0m'

echo "═══════════════════════════════════════════════════════════════"
echo "  MVL Requirements Showcase"
echo "═══════════════════════════════════════════════════════════════"
echo ""

pass=0
fail=0

for req_dir in "$SCRIPT_DIR"/REQ-*/; do
    req_name=$(basename "$req_dir")
    showcase="$req_dir/showcase.mvl"

    if [[ ! -f "$showcase" ]]; then
        continue
    fi

    output=$("$MVL" check "$showcase" 2>&1)
    if echo "$output" | grep -q ": OK"; then
        proven=$(echo "$output" | grep -oE '[0-9]+/11 requirements proven' || echo "")
        printf "  ${GREEN}✓${NC}  %-40s %s\n" "$req_name" "$proven"
        pass=$((pass + 1))
    else
        printf "  ${RED}✗${NC}  %-40s FAIL\n" "$req_name"
        if [[ "${VERBOSE:-}" == "true" ]]; then
            echo ""
            echo -e "${CYAN}--- Compiler output ---${NC}"
            echo "$output"
            echo -e "${CYAN}-----------------------${NC}"
            echo ""
        fi
        fail=$((fail + 1))
    fi
done

echo ""
if [[ $fail -eq 0 ]]; then
    echo -e "  ${GREEN}✓  All $((pass)) showcases passed${NC}"
else
    echo -e "  ${RED}✗  $fail of $((pass + fail)) showcases failed${NC}"
    exit 1
fi
