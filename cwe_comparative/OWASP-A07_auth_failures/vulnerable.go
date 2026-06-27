// OWASP A07: Identification and Authentication Failures
// https://owasp.org/Top10/A07_2021-Identification_and_Authentication_Failures/
//
// Weak session management, credential stuffing, no MFA

package main

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"time"
)

// VULNERABLE: Session never expires
type Session struct {
	ID        string
	UserID    string
	CreatedAt time.Time
	// NO ExpiresAt!
}

// VULNERABLE: Sessions stored in memory (lost on restart)
var sessions = make(map[string]*Session)

// VULNERABLE: Predictable session ID generation
func createSessionWeak(userID string) *Session {
	// BUG: Timestamp-based IDs are predictable
	id := fmt.Sprintf("%s-%d", userID, time.Now().UnixNano())
	session := &Session{
		ID:        id,
		UserID:    userID,
		CreatedAt: time.Now(),
	}
	sessions[id] = session
	return session
}

// VULNERABLE: No brute force protection
func login(username, password string) (*Session, error) {
	// BUG: No rate limiting
	// BUG: No account lockout
	// BUG: No MFA

	// Simulate password check
	if password == "correct" {
		return createSessionWeak(username), nil
	}
	return nil, fmt.Errorf("invalid credentials")
}

// VULNERABLE: Session fixation possible
func validateSession(sessionID string) *Session {
	// BUG: Doesn't check expiry (no expiry exists!)
	// BUG: Doesn't rotate session ID on privilege change
	return sessions[sessionID]
}

func main() {
	// Attack 1: Brute force (no rate limiting)
	passwords := []string{"password", "123456", "admin", "correct"}
	for _, pw := range passwords {
		session, err := login("admin", pw)
		if err == nil {
			fmt.Printf("Logged in with: %s, Session: %s\n", pw, session.ID)
		}
	}

	// Attack 2: Session prediction
	session1 := createSessionWeak("user1")
	session2 := createSessionWeak("user1")
	fmt.Printf("Session 1: %s\n", session1.ID)
	fmt.Printf("Session 2: %s\n", session2.ID)
	// IDs are sequential/predictable!
}
