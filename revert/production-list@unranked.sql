-- Deploy bakehouse:production-list to pg
-- requires: recipe-weight
-- requires: production-order

BEGIN;

SET search_path = bakehouse, pg_catalog;

DROP VIEW production_list;


CREATE VIEW production_list AS
WITH RECURSIVE
    po(product, quantity) AS
      ( SELECT product, sum(quantity)
          FROM production_order
          GROUP BY product )
  , job(rank, recipe, ingredient, quantity) AS
       ( SELECT ''::text AS text,
                r.recipe,
                ri.ingredient,
                (po.quantity / r.pieces)::numeric * ri.amount
          FROM recipe r
            JOIN recipe_item ri ON r.recipe::text = ri.recipe::text
            JOIN po ON r.recipe::text = po.product::text
         WHERE r.type::text = 'product'::text AND po.quantity > 0
        UNION
         SELECT job_1.recipe,
                job_1.ingredient,
                ri.ingredient,
                job_1.quantity / rw.total * ri.amount
           FROM job job_1
             JOIN recipe_item ri ON job_1.ingredient::text = ri.recipe::text
             JOIN recipe_weight rw ON job_1.ingredient::text = rw.recipe::text )
 SELECT job.recipe
      , job.ingredient
      , sum(job.quantity)::numeric(6,3) AS quantity
   FROM job
  GROUP BY job.recipe, job.ingredient;

COMMIT;
