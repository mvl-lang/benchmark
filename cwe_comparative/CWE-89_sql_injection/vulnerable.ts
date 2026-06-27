// CWE-89: SQL Injection
// TypeScript version - vulnerable with string interpolation

// VULNERABLE: Template literal with user input
function getUserVulnerable(username: string): string {
    // BUG: Direct string interpolation
    const query = `SELECT * FROM users WHERE username = '${username}'`;
    return query;
}

// SAFE: Using parameterized queries (pseudo-code)
function getUserSafe(username: string): { query: string; params: string[] } {
    return {
        query: "SELECT * FROM users WHERE username = ?",
        params: [username]
    };
}

// Demonstration
const maliciousInput = "'; DROP TABLE users; --";

console.log("Vulnerable query:");
console.log(getUserVulnerable(maliciousInput));
// Output: SELECT * FROM users WHERE username = ''; DROP TABLE users; --'

console.log("\nSafe query (parameterized):");
const safe = getUserSafe(maliciousInput);
console.log(safe.query);
console.log("Parameters:", safe.params);
