-- Revert bakehouse:make-cost-breakdown-use-current-price from pg

BEGIN;

SET search_path = bakehouse, pg_catalog;

CREATE OR REPLACE VIEW material_cost AS WITH bi AS (
         WITH RECURSIVE basic_ingredient(recipe, ingredient, weight) AS (
                 SELECT r.recipe,
                    ri.ingredient,
                    ri.amount / r.pieces::numeric
                   FROM recipe r
                     JOIN recipe_item ri ON r.recipe::text = ri.recipe::text
                  WHERE r.type::text = 'product'::text
                UNION
                 SELECT bi_2.recipe,
                    ri.ingredient,
                    bi_2.weight / rw.total * ri.amount
                   FROM basic_ingredient bi_2
                     JOIN recipe_item ri ON bi_2.ingredient::text = ri.recipe::text
                     JOIN recipe_weight rw ON bi_2.ingredient::text = rw.recipe::text
                )
         SELECT bi_1.recipe,
            bi_1.ingredient,
            sum(bi_1.weight) AS weight
           FROM ingredient i_1
             JOIN basic_ingredient bi_1 ON bi_1.ingredient::text = i_1.ingredient::text
          GROUP BY bi_1.recipe, bi_1.ingredient
          ORDER BY bi_1.recipe
        )
 SELECT bi.recipe AS product,
    sum(bi.weight::double precision * i.price / i.pack_size::double precision) AS materials_cost
   FROM bi
     JOIN ingredient i ON i.ingredient::text = bi.ingredient::text
  GROUP BY bi.recipe;

COMMIT;
