-- Revert bakehouse:appschema from pg

BEGIN;

-- XXX Add DDLs here.
DROP SCHEMA bakehouse;

COMMIT;
