-- Revert bakehouse:production-list from pg

BEGIN;

DROP VIEW IF EXISTS bakehouse.production_list;

COMMIT;
