-- Revert bakehouse:initial from pg

BEGIN;

-- XXX Add DDLs here.
SET search_path = bakehouse, pg_catalog;

DROP VIEW production_list CASCADE;
DROP VIEW recipe_weight CASCADE;
DROP TABLE production_order CASCADE;
DROP VIEW cost_breakdown CASCADE;
DROP TABLE recipe CASCADE;
DROP TABLE product CASCADE;
DROP MATERIALIZED VIEW per_unit CASCADE;
DROP TABLE recipe_item CASCADE;
DROP TABLE ingredient CASCADE;
DROP FUNCTION transport_allowance_rate() CASCADE;
DROP FUNCTION hourly_rate() CASCADE;

COMMIT;
