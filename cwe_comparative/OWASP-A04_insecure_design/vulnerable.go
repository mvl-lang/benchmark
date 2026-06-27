// OWASP A04: Insecure Design
// https://owasp.org/Top10/A04_2021-Insecure_Design/
//
// Missing rate limiting, no abuse case consideration

package main

import (
	"fmt"
	"time"
)

// VULNERABLE: No rate limiting on password reset
type PasswordResetService struct {
	// No tracking of reset attempts!
}

func (s *PasswordResetService) RequestReset(email string) bool {
	// BUG: No rate limiting
	// BUG: No verification email is valid
	// BUG: No tracking of attempts
	fmt.Printf("Password reset requested for: %s\n", email)

	// Always succeeds - can be abused to:
	// 1. Enumerate valid emails (timing attack)
	// 2. Flood user's inbox
	// 3. Brute force reset tokens
	return true
}

// VULNERABLE: No purchase limit
type Store struct{}

func (s *Store) Purchase(userID string, itemID string, quantity int) bool {
	// BUG: No limit on quantity
	// BUG: No velocity check
	// BUG: No fraud detection
	fmt.Printf("User %s purchased %d of item %s\n", userID, quantity, itemID)
	return true
}

func main() {
	reset := &PasswordResetService{}

	// Attack: enumerate emails
	emails := []string{"admin@example.com", "user@example.com", "test@example.com"}
	for _, email := range emails {
		start := time.Now()
		reset.RequestReset(email)
		elapsed := time.Since(start)
		fmt.Printf("  Time: %v (timing attack possible)\n", elapsed)
	}

	store := &Store{}
	// Attack: buy entire inventory
	store.Purchase("attacker", "limited-edition-item", 999999)
}
