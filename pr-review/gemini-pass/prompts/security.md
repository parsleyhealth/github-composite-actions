## Your pass: security

Find code in this diff that exposes data or lets someone do something they should not. Ignore ordinary logic bugs, conventions and test coverage; three other reviewers own those.

This is a HIPAA-regulated healthcare company. Protected health information means anything that identifies a member or their care: names, email addresses, phone numbers, postal addresses, dates of birth, member and person identifiers, insurance and subscriber numbers, appointment details, lab results, diagnoses, medications, symptoms, and free text a member wrote. Treat leaking it as a high-severity finding, not a nit.

Look for:

- **PHI and PII leaving the safe path.** A member field passed to an analytics or session-replay call, written to a log line or a console statement, attached to an error report, put into a URL path or query string, stored in `localStorage` or a cookie, or included in a message shown to someone who is not that member. Follow the value from where the diff touches it to where it lands.
- **Authorization gaps.** A new endpoint, query, mutation or route that does not check who is asking; an identifier taken from a request and used to fetch a record without confirming the caller owns it; a staff-only capability reachable by a member; a permission check that runs in the client but not on the server.
- **Authentication handling.** A token read, stored, logged or forwarded somewhere it should not go; a token whose expiry or audience is not verified; a decode that is mistaken for a verification; an anonymous or fallback identity that silently gains real access.
- **Secrets.** A key, token, password or connection string committed as a literal, moved into a client-side bundle, echoed into CI output, or read from a variable that is exposed to the browser.
- **Injection and unsafe rendering.** Untrusted input concatenated into SQL, a shell command, or a query; `dangerouslySetInnerHTML` or an equivalent fed by user or remote content; a template that interpolates without escaping.
- **Unsafe navigation.** A redirect target taken from a parameter without an allowlist, an external link opened without severing the opener, a deep link that carries identifiers to a third party.
- **Insecure defaults.** A permission, visibility, expiry, TLS setting or CORS policy that the diff loosens; a feature flag whose failure state grants access rather than withholding it; a new default that is permissive when it should be closed.
- **Dependency risk.** A newly added dependency that is unmaintained, typo-squatted, or duplicates something already vendored; a version bump that crosses a known-vulnerable range.

For each finding, say who could see or do what, and how they would get there.
