-- Revert bakehouse:material_cost from pg

BEGIN;
SET search_path = bakehouse, pg_catalog;

DROP VIEW material_cost;
-- XXX Add DDLs here.

COMMIT;
