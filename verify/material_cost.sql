-- Verify bakehouse:material_cost on pg

BEGIN;

SET search_path = bakehouse, pg_catalog;

SELECT product, materials_cost FROM material_cost;

ROLLBACK;
