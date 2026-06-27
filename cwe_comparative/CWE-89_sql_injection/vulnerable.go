// CWE-89: SQL Injection
// Go version - vulnerable if using string formatting

package main

import (
	"database/sql"
	"fmt"
)

// VULNERABLE: String formatting with user input
func getUserVulnerable(db *sql.DB, username string) {
	// BUG: Direct string interpolation
	query := fmt.Sprintf("SELECT * FROM users WHERE username = '%s'", username)
	rows, _ := db.Query(query)
	defer rows.Close()
}

// SAFE: Using parameterized queries
func getUserSafe(db *sql.DB, username string) {
	// Parameterized query - database driver escapes the input
	rows, _ := db.Query("SELECT * FROM users WHERE username = ?", username)
	defer rows.Close()
}

func main() {
	// Demonstration only - no actual DB connection
	fmt.Println("Vulnerable query:")
	fmt.Printf("SELECT * FROM users WHERE username = '%s'\n", "'; DROP TABLE users; --")

	fmt.Println("\nSafe query (parameterized):")
	fmt.Println("SELECT * FROM users WHERE username = ?")
	fmt.Println("Parameter: '; DROP TABLE users; --")
}
