-- Revert bakehouse:production-order from pg

BEGIN;

DROP TABLE IF EXISTS bakehouse.production_order;

COMMIT;
