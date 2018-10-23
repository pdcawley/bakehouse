-- Revert bakehouse:constrain-recipe-ingredients from pg

BEGIN;

  ALTER TABLE ONLY bakehouse.recipe_item
    DROP CONSTRAINT recipe_item_ingredient_check;

COMMIT;
