-- Deploy bakehouse:unit_cost to pg
-- requires: basic-data-tables
-- requires: ingredient

BEGIN;

CREATE VIEW bakehouse.unit_cost AS WITH RECURSIVE i AS (
  SELECT ingredient AS name,
         pack_size AS amount,
         ingredient AS ingredient,
         pack_size AS total_amount,
         price / pack_size AS cost
    FROM bakehouse.ingredient
),
recipe_size AS (
  SELECT recipe,
         sum(amount) as total_amount
    FROM bakehouse.recipe_item
GROUP BY recipe
),
ri AS (
  SELECT recipe_item.recipe AS name,
         amount,
         ingredient,
         recipe_size.total_amount AS total_amount
    FROM bakehouse.recipe_item AS recipe_item
    JOIN recipe_size ON recipe_size.recipe = recipe_item.recipe
),
reduced AS (
  SELECT name,
         amount AS amount,
         ingredient,
         amount AS total_amount
    FROM i
UNION ALL
  SELECT ri.name,
         (ri.amount * (i.amount / i.total_amount)),
         i.ingredient,
            ri.total_amount
    FROM ri
    JOIN reduced i ON ri.ingredient = i.name
)
SELECT name,
       SUM(cost / total_amount)
     * COALESCE((SELECT scale_weight * pieces
                 FROM bakehouse.recipe
                 WHERE recipe.recipe = blah.name)
               , 1) AS cost
  FROM (SELECT r.name,
               sum(r.amount) * max(i.cost) AS cost,
               r.total_amount
          FROM reduced r
          JOIN i ON i.name = r.ingredient
      GROUP BY r.name, r.ingredient, r.total_amount) AS blah
GROUP BY name, total_amount;

COMMIT;
