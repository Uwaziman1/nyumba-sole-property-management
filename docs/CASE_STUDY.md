# Case study: rent that belongs to the right tenancy

**Manual problem.** Payment messages, spreadsheets and separate lease files make
partial rent, old arrears and tenant turnover difficult to reconcile. A unit can
keep its payment reference after its occupant changes. The project addresses
this operational problem; measured savings or production adoption are not claimed.

**Decisions.** Keep received money, invoices, allocations and receipts distinct
and immutable. Attribute obligations to a tenancy, apply money to its oldest debt
first and keep excess as visible credit. Retain unmatched callbacks for scoped
owner review. Put notifications in a durable outbox so a failed SMS cannot undo
rent. Use versioned PDF hashes, OTP/consent evidence and an authenticated owner
countersignature for agreements. Record corrections as additional entries rather
than editing history.

**Exception, proved with fictional records.** A former tenant pays using the
unit's unchanged reference after a new lease starts. The callback is retained for
review, without clearing the new tenant's invoice. The owner assigns it to the
former tenancy with an audit reason; replay cannot create another payment or
receipt. A separate concurrent-replay scenario sends the same callback five
times while SMS fails: one payment and one receipt survive, then the worker
retries the notification. A lost cloud acknowledgement is also replayed safely.

**Evidence.** On 15 October 2026, 118 private application tests passed with zero
skips on disposable PostgreSQL 18; a separate browser run exercised Owner's
Corner, review, signing, reports and retry actions. Nine public sample tests are
independent of that suite. SMS/email and OIDC transport are substituted in tests;
actual Daraja confirmation, production identity/delivery and KRA acceptance remain
unproved. [Exact verification and limits](VALIDATION.md).
