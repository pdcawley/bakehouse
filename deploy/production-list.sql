-- Deploy bakehouse:production-list to pg
-- requires: recipe-weight
-- requires: production-order

BEGIN;

SET search_path = bakehouse, pg_catalog;

CREATE OR REPLACE VIEW production_list AS
WITH RECURSIVE
    po(product, quantity, due_date) AS
      ( SELECT product, sum(quantity), due_date
          FROM production_order
          GROUP BY product, due_date )
  , r(recipe, "type", pieces, rest_days) AS
    ( SELECT recipe
           , "type"
           , pieces
           , date_trunc('day', justify_interval(upper(rest)))
       FROM recipe )
  , job(rank, recipe, ingredient, quantity, work_date) AS
       ( SELECT 0,
                r.recipe,
                ri.ingredient,
                (po.quantity / r.pieces)::numeric * ri.amount,
                po.due_date
          FROM r
            JOIN recipe_item ri ON r.recipe::text = ri.recipe::text
            JOIN po ON r.recipe::text = po.product::text
         WHERE r.type::text = 'product'::text AND po.quantity > 0
        UNION
         SELECT job_1.rank + 1,
                job_1.ingredient,
                ri.ingredient,
                job_1.quantity / rw.total * ri.amount,
                (job_1.work_date - r.rest_days)::date
           FROM job job_1
             JOIN recipe_item ri ON job_1.ingredient::text = ri.recipe::text
             JOIN recipe_weight rw ON job_1.ingredient::text = rw.recipe::text
             JOIN r ON job_1.ingredient::text = r.recipe::text)
 SELECT job.recipe,
        job.ingredient,
        sum(job.quantity)::numeric(6,3) AS quantity,
        job.work_date
   FROM job
  GROUP BY job.recipe, job.ingredient, job.work_date;

COMMIT;
