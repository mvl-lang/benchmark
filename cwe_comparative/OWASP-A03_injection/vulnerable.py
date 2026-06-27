# OWASP A03: Injection
# https://owasp.org/Top10/A03_2021-Injection/
#
# Covers SQL, NoSQL, OS command, LDAP injection etc.
# This example shows OS command injection.

import subprocess
import os

def get_file_info(filename: str) -> str:
    """VULNERABLE: User input directly in shell command"""
    # BUG: filename is user-controlled, not sanitized
    result = subprocess.run(
        f"ls -la {filename}",  # Shell injection!
        shell=True,
        capture_output=True,
        text=True
    )
    return result.stdout

def main():
    # Normal usage
    print(get_file_info("myfile.txt"))

    # Attack: command injection
    malicious_input = "myfile.txt; cat /etc/passwd"
    print(get_file_info(malicious_input))
    # Executes: ls -la myfile.txt; cat /etc/passwd
    # Attacker gets /etc/passwd contents!

    # Even worse:
    # get_file_info("; rm -rf /")

if __name__ == "__main__":
    main()
