-- Deploy bakehouse:constrain-recipe-ingredients to pg

BEGIN;

  CREATE OR REPLACE FUNCTION bakehouse.is_valid_ingredient(text) RETURNS boolean AS $$
    SELECT EXISTS (
      SELECT 1
       WHERE $1 IN (
         SELECT i.ingredient
           FROM bakehouse.ingredient i
          UNION
         SELECT r.recipe AS ingredient
           FROM bakehouse.recipe AS r
       )
    );
  $$ language SQL;

  ALTER TABLE ONLY bakehouse.recipe_item
    ADD CONSTRAINT recipe_item_ingredient_check
    CHECK (bakehouse.is_valid_ingredient(ingredient));

COMMIT;
