-- Deploy bakehouse:allergen-tracking to pg

BEGIN;

CREATE OR REPLACE FUNCTION bakehouse.is_raw_ingredient(text) RETURNS BOOLEAN AS $$
    SELECT EXISTS (
           SELECT 1
             FROM bakehouse.ingredient
            WHERE $1 = ingredient
    );
$$ language SQL;

CREATE TABLE IF NOT EXISTS allergens (
       ingredient text CHECK (bakehouse.is_raw_ingredient(ingredient)),
       allergen text
       );

COMMIT;
