-- Deploy bakehouse:production-order to pg
-- requires: basic-data-tables

BEGIN;

ALTER TABLE bakehouse.production_order
    DROP CONSTRAINT IF EXISTS production_order_pkey
  , ADD COLUMN IF NOT EXISTS customer_tag text
  , ADD COLUMN IF NOT EXISTS due_date date
  , ALTER COLUMN due_date SET DEFAULT bakehouse.next_bake_date()
  , ALTER COLUMN customer_tag SET DEFAULT 'retail'
  , ADD PRIMARY KEY (product, quantity, customer_tag, due_date)
  ;

UPDATE bakehouse.production_order SET due_date = bakehouse.next_bake_date();

COMMIT;
