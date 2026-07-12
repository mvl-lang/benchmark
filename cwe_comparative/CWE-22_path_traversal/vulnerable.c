// CWE-22: Improper Limitation of a Pathname to a Restricted Directory
// https://cwe.mitre.org/data/definitions/22.html
// Rank #8 in CWE Top 25 (2023)

#include <stdio.h>
#include <string.h>

#define BASE_DIR "/var/www/files/"
#define PATH_BUF 256

void read_file(const char *user_filename) {
    char full_path[PATH_BUF];
    // BUG: user_filename is concatenated without validation
    // "../../etc/passwd" → "/var/www/files/../../etc/passwd" → "/etc/passwd"
    snprintf(full_path, sizeof(full_path), "%s%s", BASE_DIR, user_filename);

    FILE *f = fopen(full_path, "r");
    if (f) {
        char line[256];
        while (fgets(line, sizeof(line), f))
            printf("%s", line);
        fclose(f);
    } else {
        printf("Could not open: %s\n", full_path);
    }
}

int main() {
    read_file("../../etc/passwd");
    return 0;
}
