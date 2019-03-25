-- Verify bakehouse:allergen-tracking on pg

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgtap;

INSERT INTO bakehouse.ingredient (ingredient, type, pack_size, unit, price)
       VALUES ('flour', 'flour', 1, 'kg', 1.00);

SELECT no_plan();

SELECT has_table('bakehouse.allergens');
SELECT has_column('bakehouse.allergens', 'ingredient');
SELECT has_column('bakehouse.allergens', 'allergen');

SELECT ok (
  bakehouse.is_raw_ingredient('flour'),
  'Flour is an ingredient'
);

SELECT ok (
  NOT bakehouse.is_raw_ingredient('water'),
  'Water is not an ingredient!'
);


ROLLBACK;
