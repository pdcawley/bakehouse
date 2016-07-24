-- Revert bakehouse:unit_cost from pg

BEGIN;

DROP VIEW IF EXISTS bakehouse.unit_cost;

COMMIT;
