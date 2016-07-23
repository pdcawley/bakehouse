-- Revert bakehouse:ingredient from pg

BEGIN;

DROP TABLE ingredient;

COMMIT;
