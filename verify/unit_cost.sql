-- Verify bakehouse:unit_cost on pg

BEGIN;

SELECT name, cost FROM bakehouse.unit_cost WHERE FALSE;

-- XXX Add verifications here.

ROLLBACK;
