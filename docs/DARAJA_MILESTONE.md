# Daraja milestone — prepared locally, provider run pending

On 13 October 2026 the complete private application suite passed **63 tests, 0 failed, 0 skipped, in 20.48 seconds** against a newly created `nyumba_sole_test` on an independent loopback PostgreSQL 18 instance. Migrations 001–011 applied and repeat migration execution was safe. The runner removed the test database, and the disposable instance was stopped and removed afterwards. Existing dependency warnings remain documented; no clean installation or provider connection is claimed.

## What the additional checks prove

- Registration constructs the correct unit Paybill payload and authenticated neutral callback routes. An offline preflight reports missing configuration without displaying credentials.
- A local provider substitute exercises OAuth, registration and sandbox simulation transport. Client requests cannot switch silently to a different host/environment or follow a redirect. Missing credentials and mock mode fail before any network request.
- Non-success provider codes, missing tokens, redirects, malformed responses and timeouts produce safe errors. POSTs are not retried automatically because a lost response can leave the remote result uncertain.
- Simulation and validation acceptance alone do not create received money. Authenticated confirmation does: 12,000 + 8,000 against a 20,000 invoice leaves zero balance and two distinct receipts.
- Repeated confirmations create no additional payment or receipt. A conflicting amount under the same transaction ID is rejected. An unknown reference is retained once for review, without being allocated to another tenant.
- The prior allocation, delivery retry, signing, reports, property access and Owner’s Corner tests continue to pass. The earlier browser evidence is retained; the browser tour was not rerun during this transport increment.

## Decisions and exception

The manual problem is matching payment messages to unit debts reliably. We preserve received money separately from invoice allocations and message delivery. Validation remains permissive for an unfamiliar reference; confirmation stores it in a durable review queue. If a provider request times out, the operator checks its status before trying again. This protects against treating a lost response as proof that nothing happened.

The callback token is a shared ingress secret, not a Safaricom signature. Full registered URLs must remain private and their query strings must be excluded from access logs. Deployment ingress restrictions and rotation remain unfinished.

## Exact boundary

**Safaricom acceptance and internet callback delivery have not been verified.** The owner confirmed that neither a sandbox app nor a public callback address is ready. Tests used a local transport substitute, fictional tenants and non-routable contacts. No real payment, external message, account registration or deployment occurred.

The next step is to create a sandbox C2B app in the [Safaricom developer portal](https://developer.safaricom.co.ke/), provide an owned public HTTPS callback address and run the private setup guide. The [official C2B documentation](https://developer.safaricom.co.ke/apis/CustomerToBusiness) distinguishes request acceptance, optional validation and payment confirmation. Keys, registered secret-bearing URLs, raw callbacks and operational evidence stay outside this public showcase.

Only this summary is public. The transport implementation, sandbox tool and detailed handover remain in the private app repository.
