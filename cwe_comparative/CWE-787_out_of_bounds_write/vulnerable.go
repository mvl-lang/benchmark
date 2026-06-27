// CWE-787: Out-of-bounds Write
// Go version - runtime panic on out-of-bounds

package main

import "fmt"

func vulnerableCopy(input []byte) {
	buffer := make([]byte, 10)
	// Go will panic at runtime if input > 10
	copy(buffer, input) // Actually safe - copy truncates

	// This would panic:
	for i, b := range input {
		buffer[i] = b // PANIC if i >= 10
	}
	fmt.Printf("Copied: %s\n", buffer)
}

func main() {
	vulnerableCopy([]byte("This is too long!"))
}
