-- Verify bakehouse:bake-days on pg

BEGIN;
SET search_path = bakehouse, public, pg_catalog;


-- XXX Add verifications here.

DELETE FROM bake_day;

INSERT INTO bake_day VALUES (2), (5);

SELECT no_plan();

SELECT is( first_bake_date_after(date('2018-08-16')), '2018-08-17', 'Thursday->Friday');
SELECT is( first_bake_date_after(date('2018-08-17')), '2018-08-21', 'Friday->Tuesday -- Always the next bakeday, even on bakedays');
SELECT is( first_bake_date_after(date('2018-08-18')), '2018-08-21', 'Saturday->Tuesday');
SELECT is( first_bake_date_after(date('2018-08-19')), '2018-08-21', 'Sunday->Tuesday');
SELECT is( first_bake_date_after(date('2018-08-20')), '2018-08-21', 'Monday->Tuesday');
SELECT is( first_bake_date_after(date('2018-08-21')), '2018-08-24', 'Tuesday->Friday');

SELECT * from finish();

ROLLBACK;
