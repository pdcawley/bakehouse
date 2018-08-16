-- Deploy bakehouse:production-order to pg
-- requires: basic-data-tables

BEGIN;

ALTER TABLE bakehouse.production_order
     DROP CONSTRAINT IF EXISTS production_order_pkey
   , DROP COLUMN IF EXISTS customer_tag
   , DROP COLUMN IF EXISTS due_date
   , ADD PRIMARY KEY (product, quantity)
   ;

COMMIT;
