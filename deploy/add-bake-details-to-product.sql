-- Deploy bakehouse:add-bake-details-to-product to pg

BEGIN;

ALTER TABLE bakehouse.product
    ADD COLUMN IF NOT EXISTS bake_time interval default '0:40:0',
    ADD COLUMN IF NOT EXISTS temperature integer default 450;


COMMIT;
