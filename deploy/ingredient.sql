-- Deploy bakehouse:ingredient to pg
-- requires: appschema

BEGIN;

SET search_path = bakehouse, pg_catalog;

CREATE TABLE ingredient (
  ingredient text not null,
  type text,
  pack_size numeric,
  unit text,
  price numeric,
  datestamp date DEFAULT '1970-01-01'::date,
  CONSTRAINT ingredient_pack_quanity_check CHECK (pack_size > 0::numeric)
);

ALTER TABLE ONLY ingredient ADD CONSTRAINT ingredient_pkey  PRIMARY KEY(ingredient, datestamp);

COMMIT;
