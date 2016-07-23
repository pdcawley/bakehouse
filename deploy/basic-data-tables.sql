-- Deploy bakehouse:basic-data-tables to pg
-- requires: ingredient

BEGIN;

CREATE TABLE bakehouse.product (
  product text NOT NULL,
  packaging_cost numeric,
  labour_cost numeric,
  delivery_cost numeric,
  gross_margin integer default 25,
  piece_rate numeric, -- Pieces per hour
  PRIMARY KEY (product)
);

CREATE TABLE bakehouse.recipe (
  recipe text NOT NULL,
  type text,
  pieces integer,
  scale_weight numeric,
  PRIMARY KEY (recipe)
);

CREATE TABLE bakehouse.recipe_item (
  recipe text NOT NULL,
  ingredient text NOT NULL,
  amount numeric,
  PRIMARY KEY (recipe, ingredient)
);


ALTER TABLE ONLY bakehouse.product
  ADD CONSTRAINT product_product_fkey FOREIGN KEY (product)
  REFERENCES bakehouse.recipe(recipe) ON UPDATE CASCADE;

ALTER TABLE ONLY bakehouse.recipe_item
  ADD CONSTRAINT ri_recipe_fkey FOREIGN KEY (recipe)
  REFERENCES bakehouse.recipe(recipe) ON UPDATE CASCADE;


COMMIT;
