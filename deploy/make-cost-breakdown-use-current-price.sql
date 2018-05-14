-- Deploy bakehouse:make-cost-breakdown-use-current-price to pg

BEGIN;

SET search_path = bakehouse, pg_catalog;

CREATE OR REPLACE VIEW material_cost AS
WITH current_ingredient ( ingredient
                        , type
                        , pack_size
                        , unit, price
                        , datestamp
                        ) AS (
     SELECT a.ingredient
          , a.type
          , a.pack_size
          , a.unit
          , a.price
          , a.datestamp
       FROM bakehouse.ingredient a
       JOIN (SELECT ingredient , max(datestamp) AS datestamp
               FROM bakehouse.ingredient i
               GROUP BY i.ingredient) b
         ON a.ingredient = b.ingredient
      WHERE a.datestamp = b.datestamp)
, bi AS (
  WITH RECURSIVE basic_ingredient(recipe, ingredient, weight) AS (
       SELECT r.recipe
            , ri.ingredient
            , ri.amount / r.pieces::numeric
         FROM bakehouse.recipe r
         JOIN bakehouse.recipe_item ri
           ON r.recipe::text = ri.recipe::text
        WHERE r.type::text = 'product'::text
     UNION
       SELECT bi_2.recipe
            , ri.ingredient
            , bi_2.weight / rw.total * ri.amount
         FROM basic_ingredient bi_2
         JOIN recipe_item ri ON bi_2.ingredient::text = ri.recipe::text
         JOIN recipe_weight rw ON bi_2.ingredient::text = rw.recipe::text)
    SELECT bi_1.recipe
         , bi_1.ingredient
         , sum(bi_1.weight) weight
      FROM current_ingredient i_1
      JOIN basic_ingredient bi_1
        ON bi_1.ingredient::text = i_1.ingredient::text
      GROUP BY bi_1.recipe, bi_1.ingredient
      ORDER BY bi_1.recipe
  )
SELECT bi.recipe AS product,
    sum(bi.weight::double precision * i.price / i.pack_size::double precision) AS materials_cost
   FROM bi
   JOIN current_ingredient i ON i.ingredient::text = bi.ingredient::text
  GROUP BY bi.recipe;

COMMIT;
