-- Revert bakehouse:add_cost_breakdown from pg

BEGIN;

DROP VIEW IF EXISTS bakehouse.cost_breakdown;
DROP FUNCTION IF EXISTS bakehouse.transport_allowance_rate();
DROP FUNCTION IF EXISTS bakehouse.hourly_rate();

COMMIT;
