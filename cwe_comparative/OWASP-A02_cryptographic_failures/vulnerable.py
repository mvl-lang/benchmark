# OWASP A02: Cryptographic Failures
# https://owasp.org/Top10/A02_2021-Cryptographic_Failures/
#
# Weak cryptography, hardcoded keys, plaintext transmission

import hashlib
import base64

# VULNERABLE: Hardcoded encryption key
SECRET_KEY = "my-secret-key-123"  # Never do this!

# VULNERABLE: Weak hashing algorithm
def hash_password_weak(password: str) -> str:
    """MD5 is cryptographically broken"""
    return hashlib.md5(password.encode()).hexdigest()

# VULNERABLE: No salt
def hash_password_no_salt(password: str) -> str:
    """Same password = same hash (rainbow table attack)"""
    return hashlib.sha256(password.encode()).hexdigest()

# VULNERABLE: Homegrown "encryption"
def encrypt_data(data: str) -> str:
    """XOR with key - trivially broken"""
    key = SECRET_KEY
    encrypted = []
    for i, char in enumerate(data):
        encrypted.append(chr(ord(char) ^ ord(key[i % len(key)])))
    return base64.b64encode(''.join(encrypted).encode()).decode()

def main():
    password = "hunter2"

    # Weak hash
    print(f"MD5: {hash_password_weak(password)}")

    # No salt - same input = same output
    print(f"SHA256 (no salt): {hash_password_no_salt(password)}")
    print(f"SHA256 (no salt): {hash_password_no_salt(password)}")  # Same!

    # Homegrown crypto
    secret = "credit_card=4111111111111111"
    print(f"Encrypted: {encrypt_data(secret)}")

if __name__ == "__main__":
    main()
