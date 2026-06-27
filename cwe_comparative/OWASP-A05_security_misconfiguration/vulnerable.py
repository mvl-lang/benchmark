# OWASP A05: Security Misconfiguration
# https://owasp.org/Top10/A05_2021-Security_Misconfiguration/
#
# Debug mode in production, default credentials, verbose errors

import os

# VULNERABLE: Debug mode check is runtime
DEBUG = os.environ.get("DEBUG", "true").lower() == "true"

# VULNERABLE: Default credentials
DEFAULT_ADMIN_PASSWORD = "admin123"

class Config:
    def __init__(self):
        # BUG: Debug defaults to True
        self.debug = DEBUG

        # BUG: Uses default password if not set
        self.admin_password = os.environ.get("ADMIN_PASSWORD", DEFAULT_ADMIN_PASSWORD)

        # BUG: Verbose errors in production
        self.show_stack_traces = True

        # BUG: All origins allowed
        self.cors_origins = ["*"]

def handle_error(e: Exception, config: Config):
    """VULNERABLE: Leaks internal details"""
    if config.show_stack_traces:
        # Attacker sees full stack trace, file paths, etc.
        import traceback
        return {
            "error": str(e),
            "type": type(e).__name__,
            "traceback": traceback.format_exc(),  # NEVER in production!
        }
    return {"error": "Internal error"}

def main():
    config = Config()

    print(f"Debug mode: {config.debug}")
    print(f"Admin password: {config.admin_password}")
    print(f"CORS origins: {config.cors_origins}")

    # Simulate error
    try:
        raise ValueError("Database connection failed to db.internal.corp:5432")
    except Exception as e:
        error_response = handle_error(e, config)
        print(f"Error response: {error_response}")

if __name__ == "__main__":
    main()
