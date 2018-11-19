-- Verify bakehouse:production-list on pg
CREATE EXTENSION IF NOT EXISTS pgtap;

BEGIN;


  -- Fixture

  INSERT INTO bakehouse.ingredient (ingredient, type, pack_size, unit, price)
  VALUES                 ('flour', 'flour', 1, 'kg', 1.00);

  INSERT INTO bakehouse.recipe (recipe, type, pieces, scale_weight)
  VALUES ('p1', 'product', 1, 1),
         ('p2', 'product', 1, 1),
         ('dough', 'dough', 1, 1);


  INSERT INTO bakehouse.recipe_item (recipe, ingredient, amount)
  VALUES ('p1', 'dough', 1),
         ('p2', 'dough', 1),
         ('dough', 'flour', 1);

  INSERT INTO bakehouse.product (product) VALUES ('p1'), ('p2');

  INSERT INTO bakehouse.production_order (product, quantity)
  VALUES ('p1', 1),
         ('p2', 1);

  SELECT no_plan();

  SELECT is (
    ARRAY(
      SELECT sum(quantity)
        FROM bakehouse.production_list
       WHERE recipe = 'dough'
    ),
    ARRAY[2.000],
    'We need 2kg of flour'
  );


ROLLBACK;
