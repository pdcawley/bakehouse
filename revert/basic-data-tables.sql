-- Revert bakehouse:basic-data-tables from pg

BEGIN;

ALTER TABLE IF EXISTS bakehouse.product
  DROP CONSTRAINT IF EXISTS product_product_fkey;
ALTER TABLE IF EXISTS bakehouse.recipe_item
  DROP CONSTRAINT IF EXISTS ri_recipe_fkey;



DROP TABLE IF EXISTS bakehouse.recipe_item;
DROP TABLE IF EXISTS bakehouse.recipe;
DROP TABLE IF EXISTS bakehouse.product;

COMMIT;
