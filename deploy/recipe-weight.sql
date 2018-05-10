-- Deploy bakehouse:recipe-weight to pg

BEGIN;

CREATE OR REPLACE VIEW bakehouse.recipe_weight AS
  SELECT recipe, sum(amount) AS total
    FROM bakehouse.recipe_item
   GROUP BY recipe;

-- XXX Add DDLs here.

COMMIT;
