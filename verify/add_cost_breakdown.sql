-- Verify bakehouse:add_cost_breakdown on pg

BEGIN;

SELECT product, materials, labour, transport, wholesale, "margin (%age)",
       retail, profit, retail_margin, "Materials %age of wholesale",
       "Materials %age of retail"
  FROM bakehouse.cost_breakdown;

-- XXX Add verifications here.

ROLLBACK;
