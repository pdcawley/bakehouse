-- Revert bakehouse:initial from pg

BEGIN;

-- XXX Add DDLs here.
SET search_path = bakehouse, pg_catalog;

DROP VIEW production_list;
DROP VIEW recipe_weight;
DROP TABLE production_order;
DROP VIEW cost_breakdown;
DROP TABLE recipe;
DROP TABLE product;
DROP MATERIALIZED VIEW per_unit;
DROP TABLE recipe_item;
DROP TABLE ingredient;
DROP FUNCTION transport_allowance_rate;
DROP FUNCTION hourly_rate;

COMMIT;
