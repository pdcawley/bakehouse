-- Verify bakehouse:ingredient on pg

BEGIN;

SELECT name, type, pack_size, unit, price, datestamp FROM bakehouse.ingredient;


ROLLBACK;
