-- Verify bakehouse:recipe-weight on pg

BEGIN;

select recipe, total from bakehouse.recipe_weight;

-- XXX Add verifications here.

ROLLBACK;
