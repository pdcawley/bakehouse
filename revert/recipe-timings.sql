-- Revert bakehouse:recipe-timings from pg

BEGIN;

ALTER TABLE IF EXISTS bakehouse.recipe
 DROP COLUMN IF EXISTS rest;

DROP TYPE IF EXISTS bakehouse.rest;

COMMIT;
