// CWE-190: Integer Overflow (Go: uint32 wraps silently)
package main

import "fmt"

func allocSize(rows, cols, itemSize uint32) uint32 {
	// BUG: multiplication wraps silently for uint32
	// rows=65537, cols=65537: product wraps to 131,073 (mod 2^32)
	return rows * cols * itemSize
}

func main() {
	rows := uint32(65537)
	cols := uint32(65537)
	total := allocSize(rows, cols, 1)
	// Expected ~4 GB, got ~128 KB — allocator uses the wrong size
	fmt.Printf("Computed size: %d bytes (expected ~4294967296)\n", total)
}
