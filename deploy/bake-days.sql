-- Deploy bakehouse:bake-days to pg

BEGIN;

SET search_path = bakehouse, pg_catalog;

-- Our initial bake days are Tuesday and Friday.
CREATE TABLE IF NOT EXISTS bakehouse.bake_day ( dow integer not null primary key );
INSERT INTO bake_day(dow) values (2), (5) ON CONFLICT DO NOTHING;

CREATE OR REPLACE FUNCTION first_bake_date_after( a_date DATE ) RETURNS DATE AS $$
    WITH next_dow(dow) AS (SELECT coalesce( ( SELECT dow FROM bake_day WHERE dow > EXTRACT(dow FROM $1)
                                              ORDER BY dow LIMIT 1)
                                          , (SELECT MIN(dow) + 7 FROM bake_day)) AS dow)
    SELECT $1 + ((select dow from next_dow) - extract(dow from $1))::integer
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION first_bake_date_after(a_time TIMESTAMP) RETURNS DATE AS $$
    SELECT first_bake_date_after($1::date)
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION next_bake_date() RETURNS DATE AS $$
   SELECT first_bake_date_after(current_date)
$$
LANGUAGE SQL;

COMMIT;
