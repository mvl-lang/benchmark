// OWASP A09: Security Logging and Monitoring Failures
// https://owasp.org/Top10/A09_2021-Security_Logging_and_Monitoring_Failures/
//
// Missing audit logs, logging sensitive data, no alerting

package main

import (
	"fmt"
	"log"
)

// VULNERABLE: Logs contain sensitive data
func loginAttempt(username, password string, success bool) {
	// BUG: Logging the password!
	log.Printf("Login attempt: user=%s password=%s success=%v", username, password, success)
}

// VULNERABLE: No audit logging
func transferFunds(from, to string, amount float64) error {
	// BUG: No audit trail for financial transaction
	fmt.Printf("Transferring %.2f from %s to %s\n", amount, from, to)
	return nil
}

// VULNERABLE: Logging without context
func deleteUser(userID string) {
	// BUG: Who deleted? When? Why?
	log.Printf("User deleted: %s", userID)
}

// VULNERABLE: Log injection possible
func logUserAction(userInput string) {
	// BUG: User input goes directly to log
	// Attacker can inject: "action\nAdmin logged in successfully"
	log.Printf("User action: %s", userInput)
}

func main() {
	// Logs password (BAD!)
	loginAttempt("admin", "super_secret_password", true)

	// No audit trail
	transferFunds("account1", "attacker", 10000.00)

	// Missing context
	deleteUser("user123")

	// Log injection
	logUserAction("action\nAdmin logged in successfully")
}
