# Verification — 15 October 2026

The current private application suite passed **118 tests, 0 failed, 0 skipped, in
38.26 seconds** on a fresh loopback PostgreSQL 18 instance. All **15 migrations**
applied; the runner removed `nyumba_sole_test` and stopped and removed its cluster.
One Authlib HTTP-client deprecation warning remains. These are executed results,
not the historical 16- or 100-test totals.

## Accounting and workflow checks

- 12,000 + 8,000 clears a 20,000 invoice; two 10,000 payments keep separate receipts.
- A 25,000 catch-up payment pays 5,000 old debt before 20,000 current rent.
- Monthly billing catches up after downtime, uses effective rent terms and applies
  advance credit. Duplicate billing and excess allocations are rejected safely.
- Invoice and payment obligations belong to a tenancy. A reused unit reference
  after turnover enters owner review instead of paying the next tenant's debt.
  Scoped, audited resolution is idempotent and preserves the original callback.
- Recorded external refunds, deposit returns and reversals use separate immutable
  entries. They preserve original payments/receipts, reopen debt when appropriate,
  and reconcile net balances. They **do not initiate money transfers**.
- Concurrent callback replay, conflicting transaction IDs, a lost cloud
  acknowledgement and competing workers cannot duplicate received rent.
- Delivery failures and retries preserve accounting. Mock jobs show SIMULATED;
  transport acceptance is distinguished from verified delivery. A crash after
  remote acceptance can still repeat a notification (at-least-once sending).
- OTP attempts, expiry, consent, document versions, owner countersigning,
  content-addressed final PDFs and tamper rejection run against PostgreSQL.
- Actual restricted database groups process callbacks and worker jobs; the API
  cannot inspect the raw callback inbox, change identity bindings, own tables,
  bypass RLS or inherit another service group's global privileges.
- OIDC Authorization Code/PKCE verifies signed identity tokens, issuer, audience,
  state, nonce, MFA and fresh authentication. Valid and rejected flows use real
  RSA/JWKS signatures with a fictional provider. Browser sessions are opaque,
  revocable, HttpOnly/Secure cookies with CSRF and idle/absolute expiry.

An additional browser run against a separate disposable PostgreSQL database passed
all five Owner's Corner attention destinations and resolution, onboarding,
countersigning and final download, delivery retry, four-area navigation, report
downloads, former-tenant history, unmatched-payment resolution and a recorded
reversal. Only fictional records and mock delivery were used. The API, database
and browser services were stopped afterwards.

## Dependencies, migration and recovery

A new Python environment installed the patched requirements and passed `pip check`.
Its exact reachable versions are recorded in private `constraints.txt`; Linux-only
dependencies still need the configured Linux CI/image checks.
An OSV scan of 15 direct and 47 reachable installed packages returned zero known
findings on this check. This is a time-bounded advisory result, not a guarantee of
absence of vulnerabilities.

A private, read-only snapshot of the original database was restored to a separate
disposable instance: all 26 table fingerprints matched. The verified legacy
upgrade then applied migrations 010–015 without rewriting original payment,
allocation, receipt or signing evidence. A fictional restricted-role 12,000 +
8,000 callback check reconciled on the upgraded clone. Original files and database
were left unchanged. Historical attribution and missing-document recovery still
require review before any operational cutover; database restoration alone does
not establish complete document recovery.

## Online and provider limits

The hosted receiver is a **fictional sandbox transit queue**, not the full app.
Its durable quota, bounded body parsing, separate ingress/pull secrets, payload
minimization, authenticated operations view and retention checks pass 11 tests.
Acknowledged payloads are stripped after 30 days while deduplication tombstones
remain; unacknowledged money events are retained. Sanitized diagnostic status is
removed after 90 days. Maintenance runs on authenticated polls/operations calls;
an unattended schedule and external alert notification are not configured.

Live health/readiness and anonymous-denial probes pass. The authenticated queue
was empty when checked. Synthetic intake/collection proves our path; **actual
Safaricom C2B confirmation delivery remains unverified**. Accepted registration
or simulation responses do not prove payment confirmation. Separate real status
callbacks previously returned error 8006 (locked sandbox API user); no verified
unlock or successful replacement result is available. That does not establish
why C2B confirmation was absent. No blind resubmission or support email was sent.

Real SMS/email delivery, a configured live identity provider, production Paybill,
provider permissions, full-app hosting and monitored recovery are outstanding.
KRA transport is deliberately disabled: startup rejects enabling it until a
provisioned adapter and business-result validation exist. Disabling an unsafe
placeholder closes false-success behavior; it does not complete KRA integration.

The non-root container, supervised worker composition and PostgreSQL CI workflow
are prepared. Docker's daemon was unavailable locally, so an image build is not
claimed. Selected receipt/statement/turnover layouts and a synthetic 80-row, three-page monthly report were rendered and inspected. Long unit references now fit their columns and monthly headings repeat. Full-template visual QA, production legal/retention review and load testing
remain open. The migration chain includes fictional seed SQL and is not a clean
production bootstrap.

## Reproduce safely

From the private app, set `POSTGRES_TEST_ADMIN_URL` only in the process environment
to the `postgres` database on a new disposable loopback PostgreSQL server, then
run `python -m scripts.validate_postgres`. It refuses an existing test database,
creates only `nyumba_sole_test`, runs the suite, and removes it in `finally`.
Direct pytest without `TEST_DATABASE_URL` skips database cases; that is not the
118-test verification above. Never supply an everyday development/production DB.

The public sample suite was rerun: **9 passed in 2.02 seconds**.
The public repository contains nine executable sample tests only; its SQL excerpt
requires the private schema and is not a standalone migration or integration test.

## Primary implementation references

Role separation follows [PostgreSQL row-security behavior](https://www.postgresql.org/docs/18/ddl-rowsecurity.html),
including owner/superuser bypass. Backup verification follows
[pg_dump](https://www.postgresql.org/docs/18/app-pgdump.html) and
[pg_restore](https://www.postgresql.org/docs/18/app-pgrestore.html).
Identity follows [OpenID Connect Core](https://openid.net/specs/openid-connect-core-1_0.html),
[Authlib web clients](https://docs.authlib.org/en/latest/oauth2/client/web/) and
[OWASP session guidance](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html).
Provider gates reflect [Daraja C2B](https://developer.safaricom.co.ke/apis/CustomerToBusiness),
[Daraja API-user errors](https://developer.safaricom.co.ke/apis/BusinessToCustomer), and
[KRA's provisioned system-to-system route](https://www.kra.go.ke/business/etims-electronic-tax-invoice-management-system/learn-about-etims/etims-system-to-system-integration).


## Receiver dependency/deployment follow-up

Receiver **version 4** was built and published on 15 October 2026. Eleven
protocol/storage tests and TypeScript checking passed. Live readiness returned
200, anonymous operations access 401, authenticated operations 200, and the queue
contained zero pending events. The probe sent no payment request and acknowledged
no events. Its poll verifies access, not unattended collector supervision.

The refreshed dependency graph has zero flagged production dependency nodes.
One unpatched `braces` development parser advisory, GHSA-vfj7-8cjw-p6xm, remains
through eight ancestor/package entries. Those build tools use repository-controlled
patterns; no occurrence of their package paths/names was found in emitted worker
JavaScript/source maps. This is bounded dependency/bundle evidence, not a
penetration test or a claim that every security gap is closed. Build warnings
concern sourcemaps, timing and future configuration compatibility.
