-- Deploy bakehouse:fix-ingredient-index to pg
-- requires: ingredient

BEGIN;

ALTER TABLE IF EXISTS bakehouse.ingredient
    DROP CONSTRAINT IF EXISTS ingredient_pkey,
    ADD CONSTRAINT ingredient_pkey PRIMARY KEY (ingredient, datestamp);

COMMIT;
