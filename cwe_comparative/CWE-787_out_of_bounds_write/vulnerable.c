// CWE-787: Out-of-bounds Write
// https://cwe.mitre.org/data/definitions/787.html
//
// Writing data past the end of the intended buffer.
// Rank #1 in CWE Top 25 (2023)

#include <stdio.h>
#include <string.h>

void vulnerable_copy(char *input) {
    char buffer[10];
    // BUG: No bounds check - input could be longer than 10
    strcpy(buffer, input);  // Classic buffer overflow
    printf("Copied: %s\n", buffer);
}

int main() {
    // This will overflow the buffer
    vulnerable_copy("This string is way too long for the buffer!");
    return 0;
}
