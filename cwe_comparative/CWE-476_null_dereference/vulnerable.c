// CWE-476: NULL Pointer Dereference
// https://cwe.mitre.org/data/definitions/476.html
// Rank #12 in CWE Top 25 (2023)

#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int id;
    const char *name;
} User;

// Returns NULL if user not found
User *find_user(int id) {
    if (id == 42) {
        User *u = malloc(sizeof(User));
        u->id = 42;
        u->name = "alice";
        return u;
    }
    return NULL;
}

int main() {
    User *u = find_user(99); // not found → NULL
    // BUG: no NULL check before dereference
    printf("User: %s\n", u->name); // CRASH: segfault
    free(u);
    return 0;
}
