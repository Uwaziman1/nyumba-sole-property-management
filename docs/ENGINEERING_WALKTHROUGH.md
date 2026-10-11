# Engineering review walkthrough

Use this five-minute tour to connect the public samples to the product journey. The eight images in [the recruiter tour](RECRUITER_WALKTHROUGH.md) are sanitized browser captures. They use a fixed September 2026 scenario and have no database/provider connection. The full backend, UI and capture harness are intentionally not distributed.

## 1. Accounting model — 90 seconds

Start with the overview and payment-ledger screenshots. Nine KSh 20,000 rent obligations total KSh 180,000. Seven full payments and one KSh 10,000 partial payment total KSh 150,000; remaining balances total KSh 30,000.

Open [payment_allocations.sql](../samples/payment_allocations.sql). Received money and invoice obligations are separate, connected by allocation records. The excerpt uses PostgreSQL `numeric(14,2)`, foreign keys, indexes and mutation-blocking triggers. One receipt in the full project represents received money rather than each allocation fragment.

The follow-up excerpt adds exclusive reservation locks, invoice capacity and unit-relationship checks. The private app’s disposable PostgreSQL tests exercised these constraints under concurrent transactions, while the public Python suite does not execute SQL. Schema dependencies remain outside this repository. The screenshots do not prove SQL behavior.

## 2. Validation and provider boundaries — 60 seconds

Open [tenancy_validation.py](../samples/tenancy_validation.py). Rent/deposit use Decimal; rent must be positive, deposits nonnegative and a lease must end after it starts.

Open [c2b_event.py](../samples/c2b_event.py). It accepts both `BillRefNo` and `BillRefNumber`, requires a positive amount and exposes typed fields for incoming C2B data. Parsing does not authenticate a callback or prove provider confirmation. Provider transport, credentials and callback handlers are excluded from this repository.

Run `python -m pytest -q` after installing the minimal dependencies. The nine focused tests exercise these validation boundaries without contacting services or opening a database.

## 3. Lifecycle and operational automation — 60 seconds

Review the property, onboarding and messages screenshots. The wizard demonstrates selection of a vacant unit and separation of recurring rent from move-in deposit. Two “Continue” interactions were exercised to reach tenant details and rent/lease terms. No tenant was persisted, invitation sent or save operation completed.

The full project's scheduled worker and communication records support reminders and renewal prompts. These implementations are summarized in the README, not published here. The messages screenshot contains static fixture states, not delivery receipts.

## 4. Signing and reports — 60 seconds

Review the two unsigned agreement screenshots. They demonstrate the review and consent interfaces only. The full source now has one persisted document-version/OTP/evidence workflow. Disposable PostgreSQL tests exercised OTP lockout, tenant replay rejection, authenticated owner countersigning and the final PDF download under a restricted runtime role; provider delivery and browser usability remain separate production checks.

Report generators exist in the full project for receipts, tenant statements, payment history, monthly/annual property reports and occupancy. No report screenshot or PDF is included because a fresh database-backed reconciliation and visual QA have not been performed. Do not describe a report as verified from this gallery.

## 5. Deployment boundary — 30 seconds

End with the README's mocked/production-dependent table. M-Pesa, SMS/email and KRA integration foundations need provisioned accounts, validated provider schemas and delivery tests. Production also needs properly separated database roles, secured callbacks, backup/restore checks, monitoring and approved signing/retention practices.

Read the [brief case study](CASE_STUDY.md) for the manual problem, the choices made and the callback-plus-SMS-failure exception scenario.

This is a selected systems-engineering showcase. It does not claim an AI agent, provider certification, a live deployment or exhaustive test coverage.
