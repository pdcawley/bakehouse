-- Verify bakehouse:sampledata on pg

BEGIN;

SET search_path = bakehouse, pg_catalog;

SELECT 1/COUNT(*) from ingredient;
SELECT 1/COUNT(*) from recipe;
SELECT 1/COUNT(*) from cost_breakdown where product = 'Large White' AND retail = 2.68::money;


ROLLBACK;
