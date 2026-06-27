# OWASP A08: Software and Data Integrity Failures
# https://owasp.org/Top10/A08_2021-Software_and_Data_Integrity_Failures/
#
# Insecure deserialization, unsigned updates, CI/CD compromise

import pickle
import json

# VULNERABLE: Deserialize untrusted pickle data
def load_user_data_pickle(data: bytes) -> dict:
    """DANGEROUS: pickle.loads executes arbitrary code"""
    # BUG: Attacker can craft pickle that runs code on deserialization
    return pickle.loads(data)

# VULNERABLE: Deserialize without validation
def load_config(json_data: str) -> dict:
    """No schema validation - accepts anything"""
    config = json.loads(json_data)
    # BUG: No validation that required fields exist
    # BUG: No type checking
    # BUG: No bounds checking
    return config

# VULNERABLE: No signature verification on updates
def apply_update(update_data: bytes):
    """Applies update without verifying source"""
    # BUG: No signature check
    # BUG: No hash verification
    # BUG: No version validation
    print(f"Applying update: {len(update_data)} bytes")

def main():
    # Attack 1: Malicious pickle
    # This would execute arbitrary code:
    # malicious = b"cos\nsystem\n(S'rm -rf /'\ntR."
    # load_user_data_pickle(malicious)

    # Attack 2: Invalid config
    bad_config = '{"admin": true, "permissions": "all"}'
    config = load_config(bad_config)
    print(f"Config: {config}")  # No validation!

    # Attack 3: Unsigned update
    apply_update(b"malicious update payload")

if __name__ == "__main__":
    main()
