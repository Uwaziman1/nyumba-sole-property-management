# Workflow validation

Checked on **13 October 2026**: **79 passed, 0 failed, 0 skipped, in 21.05 seconds**, against a new `nyumba_sole_test` on a separate loopback PostgreSQL 18 instance. All eleven migrations applied and repeated migration execution was safe. The runner removed the database; its instance was stopped and removed. The 62 existing dependency warnings concern FastAPI coroutine inspection and Pydantic alias metadata.

**Daraja status: provider requests accepted; payment callback delivery unresolved.** Safaricom accepted both C2B v1/v2 registration checks (ResponseCode `00000000`) and their separately identified 12,000 sandbox simulations (ResponseCode `0`). No provider confirmation reached the receiver during either three-minute diagnostic wait. Our separate fictional HTTPS confirmation did reach the receiver and was stored once in the durable unmatched-payment queue. The receiver status log contained only our requests. Provider callback delivery and the 12,000 + 8,000 provider scenario remain unverified; the second provider payment was not requested in either diagnostic.

An independent check through the real public HTTPS tunnel used our own fictional callback payloads: 12,000 left an 8,000 invoice balance, then 8,000 cleared it. Two distinct payments/receipts and 20,000 of allocations reconciled. Replaying the first callback created no extra payment, receipt or automatic delivery job. Both receipt PDF amounts/credit and the tenant statement were checked; two notification jobs used mocked transport. This proves the public receiver-to-PostgreSQL path, not Safaricom callback delivery.

The temporary HTTPS receiver exposed only two authenticated callback POST routes. Six owner/admin/report/documentation paths returned 404; unauthenticated intake returned 401. The owner app and database stayed on loopback. Credentials, secret-bearing URLs, raw callbacks, logs, provider identifiers and generated evidence stay outside both repositories. Temporary services were stopped after each bounded check. No real payment or external tenant message was sent.

The integration run demonstrated a client defect: C2B v2's padded-zero registration success was initially rejected. Registration now accepts exactly `0` and `00000000`; other codes remain failures and payment simulation remains strict. An offline check rejects the STK sandbox shortcode for this C2B flow. Callback diagnostics record only fixed route names, response status and permitted schema field names, with no token, query, contact or payload output.

## Behavior checked on PostgreSQL

- Partial payments of 12,000 + 8,000 against 20,000; separate 10,000 receipts; catch-up allocation of 5,000 old debt then 20,000 current rent; oldest-debt-first handling and visible unapplied credit.
- Concurrent callbacks, conflicting transaction IDs, unmatched replays and competing allocations. Rejected allocations leave balances unchanged; financial and signing evidence remains append-only.
- Callback intake and its receipt outbox commit together. Message failure, later retry, worker competition, stale leases and exhausted attempts do not change received rent.
- Persisted document versions, OTP delivery activation, failed-attempt lockout, resend/cancellation, PDF tamper checks, tenant replay rejection, authenticated owner countersigning and final PDF hashes under a NOSUPERUSER/NOBYPASSRLS role.
- Reports and workspace totals reconcile for tested scenarios. Owner's Corner destination and derived-state checks continue to pass. Earlier real local browser verification remains recorded in [weekly milestones](WEEKLY_MILESTONES.md); it was not repeated for this transport change.
- Local credential setup preserves literal values, applies owner-only file permissions and refuses overwriting settings or saving them in the source repository. Authentication-only mode needs no callback/database and returns no access token.
- The callback-only gateway restricts routes, validates credentials/shortcodes/bodies, refuses production and non-loopback upstreams, redacts acknowledgements and omits secrets from diagnostics.

## Earlier results

Earlier workflow/weekly increments passed 29, 33 and 35 tests. Daraja preparation then passed 63 tests in 20.48 seconds; local authentication setup passed 72 in 47.01 seconds. Five gateway tests initially ran separately in 1.59 seconds. A subsequent combined run passed 77 in 48.93 seconds before the latest two regression cases. These counts describe historical checks, not additional tests to add to 79. The public sample suite's earlier result remains **9 passed in 0.56 seconds**; it was not rerun for documentation-only public changes.

## Reproduce

Supply `POSTGRES_TEST_ADMIN_URL` locally for the `postgres` database on a disposable loopback instance, using an account with CREATEDB/CREATEROLE there only. Run `python -m scripts.validate_postgres` from the private app root. It refuses an existing `nyumba_sole_test`, creates only that test database and removes it in `finally`. Tests refuse populated/non-loopback/development targets. Direct pytest execution without `TEST_DATABASE_URL` skips database cases.

## Remaining production dependencies

The callback token is a shared ingress secret, not a Safaricom signature. Production needs an approved Paybill/Till, provisioned provider settings, stable controlled HTTPS, query redaction, secret rotation, appropriate ingress restrictions and monitored reconciliation. Temporary Quick Tunnels have no uptime guarantee. Callback non-arrival alone does not establish its cause.

SMS/email transport acceptance does not prove handset/inbox delivery. The worker provides at-least-once sending; a crash after remote acceptance may repeat a notification, although it cannot duplicate rent. OTP payloads in pending jobs require private/encrypted storage and access/retention controls. API roles must not own tables or bypass row security; callback/worker roles need a separate least-privilege grant review.

The sanitized migration chain seeds fictional data and is for a new demo database. It must not replace migrations in an operational installation. KRA schemas/tax treatment/provider acceptance, backup/restore, full report visual QA, signing browser usability and production deployment remain separate checks. No legal signature certification, clean dependency installation or container build is claimed.

References: [PostgreSQL locking](https://www.postgresql.org/docs/18/explicit-locking.html), [row security](https://www.postgresql.org/docs/18/ddl-rowsecurity.html), [Safaricom C2B](https://developer.safaricom.co.ke/apis/CustomerToBusiness), [Cloudflare Quick Tunnels](https://developers.cloudflare.com/tunnel/get-started/quick-tunnels/).
