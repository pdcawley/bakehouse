-- Revert bakehouse:bake-days from pg

BEGIN;

-- XXX Add DDLs here.

DROP FUNCTION IF EXISTS bakehouse.first_bake_date_after( DATE ), bakehouse.first_bake_date_after( TIMESTAMP ), bakehouse.next_bake_date() ;

DROP TABLE IF EXISTS bakehouse.bake_day;

COMMIT;
