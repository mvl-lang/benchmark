// CWE-22: Path Traversal (Go)
// filepath.Join resolves ".." — it does NOT strip traversal sequences
package main

import (
	"fmt"
	"os"
	"path/filepath"
)

const baseDir = "/var/www/files"

func readFile(userFilename string) {
	// BUG: filepath.Join resolves ".." components
	// filepath.Join("/var/www/files", "../../etc/passwd") = "/etc/passwd"
	fullPath := filepath.Join(baseDir, userFilename)

	data, err := os.ReadFile(fullPath)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	fmt.Println(string(data))
}

func main() {
	readFile("../../etc/passwd")
}
