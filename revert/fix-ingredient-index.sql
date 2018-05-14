-- Revert bakehouse:fix-ingredient-index from pg

BEGIN;

ALTER TABLE IF EXISTS bakehouse.ingredient
      DROP CONSTRAINT IF EXISTS ingredient_pkey;

COMMIT;
