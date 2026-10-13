# Weekly milestones — 13 October 2026

All checks used fictional records. PostgreSQL 18 ran in a new loopback-only instance, independently of the development installation. Tests targeted **only `nyumba_sole_test`**, refused an existing populated database and removed the newly created database after each run. No development records were accessed. Real sandbox credentials were used only for the provider checks and remain private.

| Milestone | Status | Evidence |
|---|---|---|
| Baseline, before implementation changes | Complete | **29 passed, 0 failed, 0 skipped**. Migrations 001–010 applied; the real runner safely skipped them on repeat execution. |
| Exact approved allocation scenarios | Complete | **33 passed, 0 failed, 0 skipped**. No accounting implementation defect found. |
| Owner’s Corner actions | Complete | **35 passed, 0 failed, 0 skipped**, plus the local browser check described below. Migrations 001–011 applied. |
| Daraja sandbox preparation | Local preparation complete; provider run pending | **63 passed, 0 failed, 0 skipped**, including locally substituted OAuth/register/simulate transport and real API/PostgreSQL callback reconciliation. No Safaricom connection occurred. |
| Local sandbox connection setup | Complete; owner-run sandbox authentication succeeded | **72 passed, 0 failed, 0 skipped**. Authentication-only mode needs no callback or database, omits access tokens and preserves registration/simulation checks. Credentials remain outside Git. |

The historical 16-test count is superseded by these fresh results. The four work areas remain **Tenants, Owner’s Corner, Payments and Messages**, with Home as the existing overview. The stack remains Python/FastAPI, PostgreSQL/asyncpg and the existing HTML/JavaScript interface. Existing colours and CSS were preserved.

## Allocation evidence

- **12,000 + 8,000** against a 20,000 invoice: first balance 8,000 and PARTIALLY_PAID; final balance zero and PAID; two distinct receipts.
- **25,000 catch-up**: exactly 5,000 to the older outstanding invoice, then 20,000 to current rent; both balances zero.
- **10,000 + 10,000**: distinct received-payment rows and receipt numbers; total received and allocated 20,000.
- Excess credit remains outside settled invoices. Existing tests reconcile 75,000 received, 72,000 allocated and 3,000 credit.
- Rejected allocations leave invoice balances unchanged. Payment edits/deletions and allocation/evidence deletion are rejected.
- Statement, monthly report, receipt text and database/workspace totals reconcile for the tested scenarios. This is content verification, not complete visual QA of every report template.

## Owner’s Corner evidence

The unchanged interface previously rendered alert text without its actions; the agreement target had no GET destination. Renewal alerts persisted after responses, messages showed static fixtures and Add Tenant did not save connected records. The real onboarding request also demonstrated an ambiguous SQL rent-plus-deposit expression; explicit numeric casts corrected it.

The local Chrome check used the real FastAPI service, the disposable database and a NOSUPERUSER/NOBYPASSRLS login. It clicked the exact rent, renewal, agreement, vacancy and failed-message alerts, checked each destination and then resolved its underlying condition. It completed a saved onboarding, authenticated owner countersignature and queued delivery retry. It checked the four navigation areas, tenant statement and occupancy-report buttons, former-tenancy history and Messages. No page JavaScript errors occurred. Other API checks verified all five existing report downloads and denied an unassigned agent access.

Alert state is read from invoice balances, agreement status, pending renewal choice, unit occupancy and delivery job status. Refresh occurs after actions, navigation, window focus and a 15-second visible-page poll. Retrying creates a new delivery job; the earlier failure remains in history. Worker acceptance and actual handset delivery remain distinct. The test used local delivery substitutes only.

Migration 011 adds property attribution and retry relationships to delivery jobs so record destinations and membership checks are precise. Migration 009 remains present; migration 010 supplies the tested allocation integrity checks. Original payment and agreement evidence was not rewritten.

## Test isolation and rerunning

The reusable private runner now creates only `nyumba_sole_test` on a disposable loopback server and refuses an existing database. With its administration URL supplied locally through `POSTGRES_TEST_ADMIN_URL`, run `python scripts/validate_postgres.py`. Tests refuse development names and non-loopback targets. Supply an account with CREATEDB/CREATEROLE on that disposable server only.

The browser test remains in the private application. It requires Playwright, an installed Chrome browser (or a selected browser channel), a loopback fixture app and the synthetic IDs supplied through `NYUMBA_BROWSER_CONTEXT`. The local orchestration harness and runtime records remain outside both published packages. No environment file, uploaded PDF, generated evidence, database file or credential is included in either repository.

## Current callback milestone

Checked on **13 October 2026**: **79 passed, 0 failed, 0 skipped, in 21.05 seconds**, against a new `nyumba_sole_test` on a separate loopback PostgreSQL 18 instance. All eleven migrations applied and repeated migration execution was safe. The runner removed the database; its instance was stopped and removed. The 62 existing dependency warnings concern FastAPI coroutine inspection and Pydantic alias metadata.

**Daraja status: provider requests accepted; payment callback delivery unresolved.** Safaricom accepted both C2B v1/v2 registration checks (ResponseCode `00000000`) and their separately identified 12,000 sandbox simulations (ResponseCode `0`). No provider confirmation reached the receiver during either three-minute diagnostic wait. Our separate fictional HTTPS confirmation did reach the receiver and was stored once in the durable unmatched-payment queue. The receiver status log contained only our requests. Provider callback delivery and the 12,000 + 8,000 provider scenario remain unverified; the second provider payment was not requested in either diagnostic.

An independent check through the real public HTTPS tunnel used our own fictional callback payloads: 12,000 left an 8,000 invoice balance, then 8,000 cleared it. Two distinct payments/receipts and 20,000 of allocations reconciled. Replaying the first callback created no extra payment, receipt or automatic delivery job. Both receipt PDF amounts/credit and the tenant statement were checked; two notification jobs used mocked transport. This proves the public receiver-to-PostgreSQL path, not Safaricom callback delivery.

The temporary HTTPS receiver exposed only two authenticated callback POST routes. Six owner/admin/report/documentation paths returned 404; unauthenticated intake returned 401. The owner app and database stayed on loopback. Credentials, secret-bearing URLs, raw callbacks, logs, provider identifiers and generated evidence stay outside both repositories. Temporary services were stopped after each bounded check. No real payment or external tenant message was sent.

The integration run demonstrated a client defect: C2B v2's padded-zero registration success was initially rejected. Registration now accepts exactly `0` and `00000000`; other codes remain failures and payment simulation remains strict. An offline check rejects the STK sandbox shortcode for this C2B flow. Callback diagnostics record only fixed route names, response status and permitted schema field names, with no token, query, contact or payload output.

## Next unfinished milestone

Resolve Safaricom sandbox callback non-arrival. Registration/request acceptance and our HTTPS/database diagnostic are verified; provider delivery is not. Use a controlled session so another portal registration does not change its callback destination. Keep timeout outcomes explicit and do not blindly resubmit a prior transaction. If temporary hosting remains unreliable, provision a stable callback address before a new controlled provider check.
