// CWE-476: NULL Pointer Dereference (Go: nil pointer panic)
package main

import "fmt"

type User struct {
	ID   int
	Name string
}

func findUser(id int) *User {
	if id == 42 {
		return &User{ID: 42, Name: "alice"}
	}
	return nil // user not found
}

func main() {
	u := findUser(99)      // not found → nil
	fmt.Println(u.Name)   // PANIC: nil pointer dereference
}
