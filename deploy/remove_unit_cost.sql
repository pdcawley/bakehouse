-- Deploy bakehouse:unit_cost to pg
-- requires: basic-data-tables
-- requires: ingredient

BEGIN;

DROP VIEW bakehouse.unit_cost;

COMMIT;
