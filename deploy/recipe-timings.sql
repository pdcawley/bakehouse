-- Deploy bakehouse:recipe-timings to pg

BEGIN;

DROP TYPE IF EXISTS bakehouse.rest;
CREATE TYPE bakehouse.rest
    AS RANGE ( subtype = interval );

ALTER TABLE IF EXISTS bakehouse.recipe
  ADD COLUMN IF NOT EXISTS rest bakehouse.rest DEFAULT '[01:0:0,1:30:0]' NOT NULL;

COMMIT;
