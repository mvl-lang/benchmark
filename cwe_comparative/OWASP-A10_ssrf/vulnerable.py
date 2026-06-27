# OWASP A10: Server-Side Request Forgery (SSRF)
# https://owasp.org/Top10/A10_2021-Server-Side_Request_Forgery_%28SSRF%29/
#
# Server makes requests to attacker-controlled URLs

import urllib.request
import socket

# VULNERABLE: No URL validation
def fetch_url(url: str) -> str:
    """Fetches any URL - including internal services"""
    # BUG: Attacker can request internal resources:
    #   - http://localhost/admin
    #   - http://169.254.169.254/metadata (AWS metadata)
    #   - http://internal-db:5432/
    #   - file:///etc/passwd
    return urllib.request.urlopen(url).read().decode()

# VULNERABLE: DNS rebinding possible
def fetch_if_safe(url: str) -> str:
    """Tries to check if URL is safe, but fails"""
    from urllib.parse import urlparse
    parsed = urlparse(url)

    # BUG: Check hostname THEN fetch - DNS can change between
    hostname = parsed.hostname
    ip = socket.gethostbyname(hostname)

    # Check if IP is internal
    if ip.startswith("10.") or ip.startswith("192.168.") or ip == "127.0.0.1":
        raise ValueError("Internal IP not allowed")

    # BUG: DNS rebinding - hostname resolves to different IP now!
    return urllib.request.urlopen(url).read().decode()

def main():
    # Attack 1: Access internal service
    try:
        internal = fetch_url("http://localhost:8080/admin")
        print(f"Internal data: {internal}")
    except Exception as e:
        print(f"Blocked: {e}")

    # Attack 2: AWS metadata
    try:
        metadata = fetch_url("http://169.254.169.254/latest/meta-data/")
        print(f"AWS metadata: {metadata}")
    except Exception as e:
        print(f"Blocked: {e}")

    # Attack 3: Local file
    try:
        passwd = fetch_url("file:///etc/passwd")
        print(f"File content: {passwd}")
    except Exception as e:
        print(f"Blocked: {e}")

if __name__ == "__main__":
    main()
