# Weekly milestones — 13 October 2026

All checks used fictional records. PostgreSQL 18 ran in a new loopback-only instance, independently of the development installation. Tests targeted **only `nyumba_sole_test`**, refused an existing populated database and removed the newly created database after each run. No operational configuration or passwords were reused or published.

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

## Next unfinished milestone

The owner reports a Daraja sandbox C2B app has been created. The owner has entered the keys privately and supplied the successful sanitized sandbox authentication result. The app can remain local; provide an internet-accessible callback address later, then execute and verify Safaricom registration and callback receipt. Local preparation and transport-substitute checks are complete; OAuth authentication is verified through the owner’s local result; provider registration, callback delivery and payment simulation remain unverified. Production SMS/email delivery reports follow separately. KRA acceptance, backup/restore, full report visual QA and deployment remain separate unfinished work. Do not rework completed allocation/actions without a demonstrated defect or integration need.


## Callback receiver preparation

Owner-run provider check, 13 October 2026: the local launcher returned `authenticated: true`, `environment: sandbox`, `callback_verified: false`. Safaricom issued an access token; no token or credentials were shared or stored in these repositories. This verifies sandbox authentication in the owner's reported run, not C2B callbacks or payments. The application remains local. A callback-only receiver is now prepared and its five focused tests passed in 1.59 seconds, with two existing FastAPI dependency warnings. No public tunnel was started. The prior 72-test PostgreSQL result is unchanged; the receiver tests ran separately, not as a combined 77-test database suite.
