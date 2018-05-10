-- Revert bakehouse:recipe-weight from pg

BEGIN;

DROP VIEW bakehouse.recipe_weight;

-- XXX Add DDLs here.

COMMIT;
