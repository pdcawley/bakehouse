-- Verify bakehouse:appschema on pg

BEGIN;

-- XXX Add verifications here.
SELECT pg_catalog.has_schema_privilege('bakehouse', 'usage');

ROLLBACK;
