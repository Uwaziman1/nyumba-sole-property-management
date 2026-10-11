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

-- Follow-up integrity migration (private schema dependencies required).
BEGIN;
-- Serialize reservations before inserting; the old shared AFTER lock allowed races.
DROP TRIGGER allocation_updates_invoice ON payment_allocations;
CREATE OR REPLACE FUNCTION validate_payment_allocation() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE p payment_ledger%ROWTYPE; i rent_invoices%ROWTYPE; total numeric;
BEGIN
  SELECT * INTO p FROM payment_ledger WHERE id=NEW.payment_id FOR NO KEY UPDATE;
  SELECT * INTO i FROM rent_invoices WHERE id=NEW.invoice_id FOR NO KEY UPDATE;
  IF p.id IS NULL OR i.id IS NULL OR p.unit_id<>i.unit_id OR NOT EXISTS (
    SELECT 1 FROM units u JOIN properties pr ON pr.id=u.property_id
    WHERE u.id=p.unit_id AND pr.id=p.property_id AND pr.holding_id=p.holding_id) THEN
    RAISE EXCEPTION 'payment and invoice must belong to the same unit' USING ERRCODE='23514';
  END IF;
  SELECT COALESCE(sum(amount),0) INTO total FROM payment_allocations WHERE payment_id=p.id;
  IF total+NEW.amount>p.amount THEN
    RAISE EXCEPTION 'allocation exceeds received payment' USING ERRCODE='23514';
  END IF;
  IF i.amount_paid+NEW.amount>i.amount_due THEN
    RAISE EXCEPTION 'allocation exceeds invoice capacity' USING ERRCODE='23514';
  END IF;
  RETURN NEW;
END; $$;
CREATE TRIGGER allocation_validates BEFORE INSERT ON payment_allocations FOR EACH ROW EXECUTE FUNCTION validate_payment_allocation();
CREATE OR REPLACE FUNCTION validate_and_apply_payment_allocation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  UPDATE rent_invoices SET amount_paid=amount_paid+NEW.amount,
    status=(CASE WHEN amount_paid+NEW.amount>=amount_due THEN 'PAID'
                 ELSE 'PARTIALLY_PAID' END)::invoice_status,updated_at=now()
    WHERE id=NEW.invoice_id;
  RETURN NEW;
END; $$;
CREATE TRIGGER allocation_updates_invoice AFTER INSERT ON payment_allocations FOR EACH ROW EXECUTE FUNCTION validate_and_apply_payment_allocation();
ALTER TABLE payment_allocations ENABLE ROW LEVEL SECURITY;
CREATE POLICY allocations_holding ON payment_allocations USING (
  EXISTS(SELECT 1 FROM payment_ledger p WHERE p.id=payment_id AND p.holding_id=nullif(current_setting('app.holding_id',true),'')::uuid));

COMMIT;
