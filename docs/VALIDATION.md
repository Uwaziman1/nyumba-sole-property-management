# Validation and publication scope

Latest full-app check: **13 October 2026 — 35 passed, 0 failed, 0 skipped**, migrations 001–011, only isolated `nyumba_sole_test`. All five Owner’s Corner alert destinations and resolved conditions passed a real local-browser check. See [weekly milestones](WEEKLY_MILESTONES.md).

The public sample suite was checked on 11 October 2026; the results below remain historical evidence for that unchanged Python sample surface.

Public samples: **9 passed in 0.56 seconds**. These validate decimal rent/deposit values, date boundaries, provider reference aliases and positive amounts; they need no database or credentials.

Private application: **29 passed, none skipped** on disposable PostgreSQL 18. The real migration runner applied all ten migrations and safely skipped them on repeat execution. Tests exercised partial/split/catch-up payments and unapplied credit, concurrent allocation limits, duplicate and conflicting callbacks, unmatched replay, callback token/shortcode validation, receipt and renewal retries, worker concurrency and exhaustion, persistent OTP lockout, tenant/owner signing under a non-superuser role, replay rejection, document tamper checks and final PDF hash/download. Temporary databases were removed. Transport was mocked; no live provider delivery occurred.

The SQL sample combines allocation schema and its subsequent integrity migration. It still requires the full private schema and cannot run standalone. The public tests do not execute that SQL; the PostgreSQL results belong to the private app.

The eight screenshots remain synthetic browser-preview captures. They were visually reviewed and exercise navigation, onboarding through rent terms, messages and unsigned agreement screens. They do not demonstrate live providers or persisted signatures. The new API/database evidence is separate from those images.

## Limits

Messages have bounded, at-least-once retries; provider acceptance is distinct from handset delivery. A crash between remote acceptance and local confirmation may repeat a notification, while financial callback processing remains deduplicated. Callback registration/network restrictions and live sandbox behavior, KRA shapes/tax applicability, report visual QA, backup/restore, broader signing/browser usability and legal/identity assurance remain production-dependent. The single signing workflow was tested through the API, not claimed as a certified signature.

## Public scope

Included: README, rights notice, validation, one brief case study, two illustrated tours, eight synthetic screenshots, two selected Python models, the allocation excerpt and focused sample tests.

Excluded: full app, UI, authentication/signing implementation, report generators, workers, provider adapters, complete schema, deployment configuration, environment files, credentials, real tenant records, PDF/signature evidence, local paths and original Git history. The complete sanitized app is maintained privately.
