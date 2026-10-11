-- Source excerpt for review only. Requires the private application schema.
BEGIN;
CREATE TABLE payment_allocations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  payment_id uuid NOT NULL REFERENCES payment_ledger(id),
  invoice_id uuid NOT NULL REFERENCES rent_invoices(id),
  amount numeric(14,2) NOT NULL CHECK(amount > 0),
  allocated_at timestamptz NOT NULL DEFAULT now(), created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(payment_id, invoice_id)
);
CREATE INDEX payment_allocations_payment_idx ON payment_allocations(payment_id);
CREATE INDEX payment_allocations_invoice_idx ON payment_allocations(invoice_id);

-- Allocation records are accounting evidence, not editable spreadsheet cells.
CREATE OR REPLACE FUNCTION prevent_payment_allocation_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN RAISE EXCEPTION 'payment_allocations are append-only: % is forbidden', TG_OP USING ERRCODE='55000'; END; $$;
CREATE TRIGGER no_payment_allocation_update BEFORE UPDATE ON payment_allocations FOR EACH ROW EXECUTE FUNCTION prevent_payment_allocation_mutation();
CREATE TRIGGER no_payment_allocation_delete BEFORE DELETE ON payment_allocations FOR EACH ROW EXECUTE FUNCTION prevent_payment_allocation_mutation();

CREATE OR REPLACE FUNCTION validate_and_apply_payment_allocation() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE received numeric(14,2); allocated numeric(14,2);
BEGIN
  SELECT amount INTO received FROM payment_ledger WHERE id=NEW.payment_id FOR SHARE;
  SELECT COALESCE(sum(amount),0) INTO allocated FROM payment_allocations WHERE payment_id=NEW.payment_id;
  IF allocated > received THEN RAISE EXCEPTION 'allocation exceeds received payment' USING ERRCODE='23514'; END IF;
  UPDATE rent_invoices SET amount_paid=(SELECT COALESCE(sum(amount),0) FROM payment_allocations WHERE invoice_id=NEW.invoice_id), updated_at=now() WHERE id=NEW.invoice_id;
  RETURN NEW;
END; $$;
CREATE TRIGGER allocation_updates_invoice AFTER INSERT ON payment_allocations FOR EACH ROW EXECUTE FUNCTION validate_and_apply_payment_allocation();

-- Existing development and future production records retain their original payment/invoice relationship.
DROP TRIGGER IF EXISTS ledger_settles_invoice ON payment_ledger;
INSERT INTO payment_allocations(payment_id,invoice_id,amount,allocated_at)
 SELECT id,invoice_id,amount,created_at FROM payment_ledger WHERE invoice_id IS NOT NULL
 ON CONFLICT(payment_id,invoice_id) DO NOTHING;
UPDATE rent_invoices i SET amount_paid=COALESCE((SELECT sum(a.amount) FROM payment_allocations a WHERE a.invoice_id=i.id),0),updated_at=now();
COMMIT;
