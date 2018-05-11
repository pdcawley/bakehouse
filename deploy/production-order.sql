-- Deploy bakehouse:production-order to pg
-- requires: basic-data-tables

BEGIN;

CREATE TABLE bakehouse.production_order (
  product text NOT NULL REFERENCES bakehouse.product
                         ON DELETE CASCADE
                         ON UPDATE CASCADE
, quantity INTEGER default 0
);

COMMIT;
