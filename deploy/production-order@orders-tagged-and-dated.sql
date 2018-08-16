-- Deploy bakehouse:production-order to pg
-- requires: basic-data-tables

BEGIN;

ALTER TABLE bakehouse.production_order
    DROP CONSTRAINT IF EXISTS production_order_pkey
  , ADD COLUMN IF NOT EXISTS customer_tag text DEFAULT 'retail'
  , ADD COLUMN IF NOT EXISTS due_date date DEFAULT current_date
  ;

UPDATE bakehouse.production_order SET customer_tag = 'retail' WHERE customer_tag IS NULL;
UPDATE bakehouse.production_order SET due_date = current_date WHERE due_date IS NULL;

ALTER TABLE bakehouse.production_order
    ADD PRIMARY KEY (product, quantity, customer_tag, due_date)
  ;

COMMIT;
