-- Deploy bakehouse:add_cost_breakdown to pg
-- requires: basic-data-tables
-- requires: unit_cost

BEGIN;

SET search_path = bakehouse, pg_catalog;

-- Set up some constants

CREATE OR REPLACE FUNCTION hourly_rate() RETURNS numeric
  AS $$ SELECT 15.00::numeric; $$
  LANGUAGE SQL
  IMMUTABLE;

CREATE OR REPLACE FUNCTION transport_allowance_rate() RETURNS numeric
  AS $$ SELECT 0.1::numeric; $$
  LANGUAGE SQL
  IMMUTABLE;

CREATE OR REPLACE VIEW cost_breakdown AS
WITH basic_cost AS (
 SELECT product.product AS product
      , pu.cost * r.scale_weight * r.pieces AS ingredient
      , ROUND(
          COALESCE( product.packaging_cost
                  , 0::numeric
                 )
        , 2
        ) AS packaging
      , ROUND(
          COALESCE( product.labour_cost
                  , hourly_rate() / product.piece_rate
                  )
        , 2
        ) AS labour
      , ROUND(
          COALESCE( product.gross_margin / 100.0
                  , 0.25
                  )
        , 2
        ) AS margin
   FROM product
     JOIN unit_cost pu ON pu.name = product.product
     JOIN recipe r    ON pu.name = r.recipe
),
wholesale AS (
SELECT bc_1.product
     , (bc_1.ingredient + bc_1.packaging + bc_1.labour)
       / (1::numeric - transport_allowance_rate() - bc_1.margin)
       AS price
   FROM basic_cost bc_1
),
price AS (
SELECT bc_1.product
     , bc_1.ingredient + bc_1.packaging AS materials
     , bc_1.ingredient + bc_1.packaging + bc_1.labour
       + wholesale.price * transport_allowance_rate()
       AS cost
     , wholesale.price * transport_allowance_rate() AS transport
     , wholesale.price AS wholesale
     , 1.33::numeric * wholesale.price AS retail
   FROM basic_cost bc_1
     JOIN wholesale ON wholesale.product = bc_1.product
)
SELECT price.product
     , ROUND(price.materials, 2) AS materials
     , ROUND(bc.labour, 2)       AS labour
     , ROUND(price.transport, 2) AS transport
     , ROUND(price.wholesale, 2) AS wholesale
     , ROUND(bc.margin * 100::numeric, 2) || '%' AS "margin (%age)"
     , ROUND(price.retail, 2)    AS retail
     , ROUND(price.wholesale - price.cost, 2) AS profit
     , ROUND((100.0::numeric * (price.retail - price.wholesale)) / price.retail, 2)
       AS retail_margin
     , ROUND((100.0::numeric * price.materials) / price.wholesale, 2) AS "Materials %age of wholesale"
     , ROUND((100.0::numeric * price.materials) / price.retail, 2)    AS "Materials %age of retail"
  FROM price
    JOIN basic_cost bc ON price.product = bc.product;

COMMIT;
