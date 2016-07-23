-- Verify bakehouse:ingredient on pg

BEGIN;

SELECT ingredient, type, pack_size, unit, price, datestamp FROM bakehouse.ingredient;


ROLLBACK;
