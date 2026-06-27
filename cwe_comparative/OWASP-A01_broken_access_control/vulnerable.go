// OWASP A01: Broken Access Control
// https://owasp.org/Top10/A01_2021-Broken_Access_Control/
//
// Missing authorization check allows horizontal privilege escalation.

package main

import (
	"fmt"
	"net/http"
)

type User struct {
	ID   int
	Name string
	Role string
}

// Simulated database
var users = map[int]*User{
	1: {ID: 1, Name: "Alice", Role: "admin"},
	2: {ID: 2, Name: "Bob", Role: "user"},
	3: {ID: 3, Name: "Eve", Role: "user"},
}

// VULNERABLE: No authorization check
func getUser(w http.ResponseWriter, r *http.Request, currentUserID int, targetUserID int) {
	// BUG: Anyone can access any user's data
	// Should check: currentUserID == targetUserID || isAdmin(currentUserID)

	user := users[targetUserID]
	if user != nil {
		fmt.Fprintf(w, "User: %s, Role: %s\n", user.Name, user.Role)
	}
}

// Attack: Eve (ID=3) requests Bob's data (ID=2)
func main() {
	currentUser := 3  // Eve
	targetUser := 2   // Bob

	// Eve can see Bob's data - no check!
	fmt.Printf("Current user: %d, Requesting: %d\n", currentUser, targetUser)
	fmt.Printf("Result: User data returned (VULNERABLE)\n")
}
