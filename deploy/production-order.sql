-- Deploy bakehouse:production-order to pg
-- requires: basic-data-tables

BEGIN;

ALTER TABLE bakehouse.production_order
    DROP CONSTRAINT IF EXISTS production_order_pkey
  , ADD COLUMN IF NOT EXISTS customer_tag text
  , ADD COLUMN IF NOT EXISTS due_date date NOT NULL
  , ADD PRIMARY KEY (product, quantity, customer_tag, due_date)
  ;

COMMIT;
