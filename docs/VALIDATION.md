# Validation and publication scope

Checked on 11 October 2026.

Public sample suite: **9 passed in 0.42 seconds**. Tests ran against the existing local Python environment; fresh dependency installation was not performed. The samples require no environment file, database connection, external account or provider transport.

Tests cover decimal rent/deposit values, rejected nonpositive rent and negative deposit, lease end-date boundaries, both provider reference spellings and rejected nonpositive payment amounts. They do not validate the full application.

The earlier full sanitized copy passed 15 tests with one PostgreSQL test skipped. Those results belong to that separate copy and are not a full-system validation claim for this repository.

The SQL excerpt requires private schema dependencies and was not executed here. Its shared payment-row lock is insufficient evidence of serialized concurrent allocation; invoice capacity and payment/invoice relationship checks need further review. It is engineering evidence with disclosed limitations, not a production-ready standalone accounting library.

The sanitized browser preview was exercised for Home, Payments, Owner's Corner, property selection, onboarding through the rent/lease step, Messages and the two unsigned agreement screens. Eight screenshots were captured and visually reviewed. A local-only harness served sanitized source pages and fixed synthetic JSON fixtures; it did not load the database workspace extension or provider adapters. Capture-only adjustments quoted renamed property keys and generalized additional wizard fixtures. No email, signature or tenant-save action occurred.

No report visual QA, database migration/seed run, end-to-end signing test, provider sandbox validation or production deployment was performed for this package. The full source includes overlapping legacy/new signing handlers and provisional eTIMS transport shapes.

## Included public files

- README, rights notice, this validation record and contents manifest.
- Two selected Python validation models and an empty package initializer.
- One payment-allocation SQL excerpt.
- Focused synthetic-data tests, minimal dependency pins and exclusion rules.
- Eight safe browser screenshots and two illustrated walkthroughs.

Excluded: full backend, UI, authentication and signing implementation, report generators, worker, provider adapters, complete schema, deployment configuration, all environment files, credentials, tenant records, signing evidence, generated PDFs/screenshots, local paths and original Git history.

The full sanitized application remains local. Only this smaller folder is designated for public publication. Public availability permits viewing/downloading; the rights notice does not prevent technical copying.
