-- Revert bakehouse:allergen-tracking from pg

BEGIN;

DROP TABLE IF EXISTS allergens;
DROP FUNCTION IF EXISTS bakehouse.is_raw_ingredient(TEXT);

COMMIT;
