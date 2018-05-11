-- Revert bakehouse:production-list from pg

BEGIN;

DROP VIEW IF EXISTS production_list;

COMMIT;
