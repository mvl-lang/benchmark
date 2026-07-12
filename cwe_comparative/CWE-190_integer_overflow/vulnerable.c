// CWE-190: Integer Overflow or Wraparound
// https://cwe.mitre.org/data/definitions/190.html
// Rank #3 in CWE Top 25 (2023)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Allocate a 2D grid; rows * cols * item_size can wrap
void *alloc_grid(unsigned int rows, unsigned int cols, unsigned int item_size) {
    // BUG: unsigned multiplication silently wraps mod 2^32
    // rows=65537, cols=65537 → 65537*65537 = 4,295,098,369 wraps to 131,073
    // total is far smaller than the grid actually needs
    unsigned int total = rows * cols * item_size;
    printf("Allocating %u bytes (expected ~%llu)\n",
           total, (unsigned long long)rows * cols * item_size);
    return malloc(total);
}

int main() {
    unsigned int rows = 65537;
    unsigned int cols = 65537;
    void *grid = alloc_grid(rows, cols, 1);
    // Writing rows*cols bytes into grid is a heap overflow
    if (grid) {
        memset(grid, 0, 1024); // corrupts memory past the tiny allocation
        free(grid);
    }
    return 0;
}
