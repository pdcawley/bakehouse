-- Revert bakehouse:ingredient from pg

BEGIN;

DROP TABLE bakehouse.ingredient;

COMMIT;
