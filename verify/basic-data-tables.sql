-- Verify bakehouse:basic-data-tables on pg

BEGIN;

SELECT product, packaging_cost, labour_cost, delivery_cost,
  gross_margin, piece_rate
FROM bakehouse.product
WHERE FALSE;

SELECT recipe, type, pieces, scale_weight
FROM bakehouse.recipe
WHERE FALSE;

SELECT recipe, ingredient, amount
FROM bakehouse.recipe_item
WHERE FALSE;

ROLLBACK;
