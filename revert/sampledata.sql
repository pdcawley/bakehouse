-- Revert bakehouse:sampledata from pg

BEGIN;

SET search_path = bakehouse, pg_catalog;

DELETE FROM recipe_item;
DELETE FROM production_order;
DELETE FROM product;
DELETE FROM recipe;
DELETE FROM ingredient;

REFRESH MATERIALIZED VIEW per_unit;

COMMIT;
