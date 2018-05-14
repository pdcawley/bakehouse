-- Revert bakehouse:add-bake-details-to-product from pg
-- requires: basic-data-tables
BEGIN;

ALTER TABLE IF EXISTS bakehouse.product
    DROP COLUMN IF EXISTS bake_time,
    DROP COLUMN IF EXISTS temperature;

COMMIT;
