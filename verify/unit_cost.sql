-- Verify bakehouse:unit_cost on pg

BEGIN;

SET search_path = bakehouse, pg_catalog;

SELECT name, cost FROM bakehouse.unit_cost WHERE FALSE;

COPY ingredient (ingredient, type, pack_size, unit, price) FROM stdin;
Test Flour	basic-ingredient	1	kg	2.00
Test Water	basic-ingredient	1	kg	0.00
Test Yeast	basic-ingredient	1	kg	6.00
Test Salt	basic-ingredient	1	kg	6.00
\.

COPY recipe (recipe, type, pieces, scale_weight) FROM stdin;
Test Straight Dough	dough	1	\N
Test Straight White	product	1	0.800
\.

INSERT INTO product(product, piece_rate) VALUES ('Test Straight White', 16);
-- INSERT INTO product(product, piece_rate) VALUES ('Test Sponge White', 16);

COPY recipe_item(recipe, ingredient, amount) FROM stdin;
Test Straight Dough	Test Flour	1
Test Straight Dough	Test Water	.660
Test Straight Dough	Test Yeast	.010
Test Straight Dough	Test Salt	.020
Test Straight White	Test Straight Dough	.800
\.

SELECT 1/COUNT(*) FROM unit_cost
WHERE name = 'Test Straight Dough'
  AND round(cost, 2) = 1.29::numeric;

SELECT 1/COUNT(*) FROM unit_cost
WHERE name = 'Test Straight White'
  AND round(cost, 2) = round(1.289::numeric, 2);

ROLLBACK;
