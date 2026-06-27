// CWE-89: SQL Injection
// https://cwe.mitre.org/data/definitions/89.html
//
// Improper neutralization of special elements used in SQL command.
// Rank #3 in CWE Top 25 (2023)

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Simulated database query function
void execute_query(const char *query) {
    printf("Executing: %s\n", query);
    // In real code, this would execute against a database
}

void get_user(const char *username) {
    char query[256];
    // BUG: Direct string concatenation with user input
    sprintf(query, "SELECT * FROM users WHERE username = '%s'", username);
    execute_query(query);
}

int main() {
    // Normal input
    get_user("alice");

    // SQL injection attack
    get_user("'; DROP TABLE users; --");
    // Results in: SELECT * FROM users WHERE username = ''; DROP TABLE users; --'

    return 0;
}
