# Nyumba Sole — engineering showcase

**Property management and rent-record workflows for a Kenyan rental portfolio.**

Nyumba Sole addresses a practical internal-tool problem: rent payments, tenant records, agreements and follow-ups spread across spreadsheets and messages are difficult to reconcile and audit. The application brings these workflows into an owner workspace backed by PostgreSQL.

This repository is a **selected public showcase**, not the full application. The complete backend, UI, provider adapters, operational configuration and private records remain outside this repository. It shares enough code to inspect concrete design choices while limiting exposure of the implementation.

The full application is maintained separately in a private repository. This public repository is the portfolio link intended for application reviewers.

Latest verification: **15 October 2026 — 118 private application tests passed,
0 failed, 0 skipped**, with all 15 migrations on disposable PostgreSQL 18.
Browser checks also passed for Owner's Corner, onboarding, signing, retries,
reports, former tenancies and payment review. Monthly billing, tenancy-scoped
allocation, immutable corrections and production session/role guards are now
implemented and tested. Actual Daraja confirmation and production provider
acceptance remain open. [Evidence and limits](docs/VALIDATION.md).

## Screenshots and demo tours

![Owner overview with synthetic rent totals](assets/screenshots/01-owner-overview.jpg)

Read the [brief case study](docs/CASE_STUDY.md) for the manual problem, implementation decisions and a tested exception.

See the [two-minute recruiter walkthrough](docs/RECRUITER_WALKTHROUGH.md) and [engineering walkthrough](docs/ENGINEERING_WALKTHROUGH.md). The first eight screenshots show the sanitized application screens with synthetic fixtures. Each carries a visible preview banner. These are browser captures of a local UI harness, not evidence of a live database, provider delivery or completed signatures. Full UI source and the capture harness remain outside this repository.

A ninth capture shows the owner workspace during the **executed disposable
PostgreSQL browser check**, using fictional records and mocked delivery:

![Owner workflow checked against disposable PostgreSQL](assets/screenshots/09-owner-corner-postgres.png)

It demonstrates local database-backed UI verification, not live provider acceptance.

## Engineering evidence you can inspect

| Sample | What it demonstrates |
|---|---|
| [Tenant validation](samples/tenancy_validation.py) | Typed onboarding data, exact decimal rent/deposit values and lease-date validation |
| [M-Pesa event model](samples/c2b_event.py) | C2B payment parsing, provider reference aliases and positive received amounts |
| [Allocation migration excerpt](samples/payment_allocations.sql) | Separate payment/invoice allocation records, append-only triggers and numeric accounting |
| [Executable sample tests](tests/test_samples.py) | Accepted/rejected financial terms, date boundaries and provider field variants |

The Python samples were extracted from the project and stripped of application configuration and transport dependencies. Tests use synthetic fixtures. The SQL combines sanitized allocation-schema and follow-up integrity excerpts, dependent on the full application schema; it cannot be applied as a standalone migration.

## Full-project architecture

```mermaid
flowchart LR
    UI[Owner workspace: HTML and JavaScript] --> API[Python / FastAPI]
    API --> DB[(PostgreSQL / asyncpg)]
    Callbacks[M-Pesa C2B callbacks] --> API
    Jobs[Scheduled reminder and renewal worker] --> DB
    Jobs --> Delivery[SMS and email adapters]
    API --> Reports[ReportLab PDF reports]
    API --> Signing[Versioned agreement workflow / pypdf]
    Signing --> Evidence[Document hashes and audit evidence]
    DB --> Outbox[eTIMS historical records - transport disabled]
```

The full project includes fifteen PostgreSQL migrations. Its records separate holdings, properties, units, tenants, leases, rent terms, invoices, received payments, allocations, receipts, communications and agreement evidence. Authentication, roles, property membership and PostgreSQL row-level security define access boundaries; startup now enforces separate non-owner runtime roles and narrow service groups.

## Workflows represented in the project

- **Rent accounting:** shared Paybill unit references, unique transaction identifiers, unmatched-reference review, distinct received money and invoice allocations, receipts and outstanding balances.
- **Tenant lifecycle:** onboarding, rent and refundable deposit, vacancy handling, former tenancies and historical rent terms.
- **Reports:** PDF receipts, tenant statements, M-Pesa history, monthly property reports, annual reports and occupancy history.
- **Signing:** upload a final PDF → create an agreement version → send a time-limited link → verify OTP and consent → tenant signs → authenticated owner countersigns → final PDF certificate and retained document hashes/audit events.
- **Automation:** scheduled rent reminders, renewal prompts and persisted delivery attempts.

These descriptions come from inspecting the full source. They are not claims of production deployment, live provider certification or an end-to-end test of every workflow. There is no AI agent or LLM feature in the inspected code.

## Mocked versus production-dependent

| Area | Local/project implementation | Still requires production work |
|---|---|---|
| PostgreSQL | Migrations, accounting queries, lifecycle history | Operational history review, deploy runtime logins and monitored recovery |
| M-Pesa | Event parsing, allocations, substituted workflow checks and verified sandbox request acceptance | Approved Paybill, credentials, secured callbacks, sandbox validation |
| SMS/email | Mock delivery and adapter implementations | Approved senders, credentials, actual delivery reports and consent review |
| Signing | Single versioned route; OTP lockout, consent and finalization tested on PostgreSQL | Live identity/delivery, legal wording and retention |
| KRA/eTIMS | Transport disabled; historical records preserved | Provisioned adapter, applicable tax treatment and provider approval |
| Reports | PDF generators and database queries | Full visual output verification and operational reconciliation |

No adapters or credentials are included here. The full sanitized local copy uses mock mode; publishing this showcase does not expose a working service.

## Run the public samples

Use Python 3.11+ from this repository directory:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python -m pytest -q
```

No database, environment file, cloud account or provider credentials are needed. These tests validate the Python samples only. They do not execute SQL, exercise concurrent payment allocation or verify full reports/signing.

The follow-up allocation excerpt uses exclusive reservation locks and checks payment limits, invoice capacity and unit relationships. These behaviors were exercised by the private application’s disposable PostgreSQL concurrency tests. The public sample suite itself does not execute SQL. See [validation and limits](docs/VALIDATION.md).

## Source protection and privacy

Only selected samples, documentation and sanitized screenshots are public. No full application, Git history, private identity, real tenant data, uploaded document, signature evidence, environment file or credential is included. Original screenshots and reports were excluded; new images were captured from a synthetic local preview.

No open-source license is granted for the original sample code. See [rights notice](NOTICE.md). Public files can still be viewed and forked under GitHub's terms; this notice does not prevent copying technically. Third-party dependencies retain their own licenses.

Prepared for the GitHub profile [Uwaziman1](https://github.com/Uwaziman1). The showcase presents inspected project work and current validation limits without inventing authorship metrics or live integration claims.
