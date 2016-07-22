-- Deploy bakehouse:initial to pg
-- requires: appschema

BEGIN;


--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = bakehouse, pg_catalog;

--
-- Name: hourly_rate(); Type: FUNCTION; Schema: bakehouse; Owner: pdcawley
--

CREATE FUNCTION hourly_rate() RETURNS money
    LANGUAGE sql
    AS $$	SELECT money(10) AS result
$$;


ALTER FUNCTION bakehouse.hourly_rate() OWNER TO pdcawley;

--
-- Name: transport_allowance_rate(); Type: FUNCTION; Schema: bakehouse; Owner: pdcawley
--

CREATE FUNCTION transport_allowance_rate() RETURNS numeric
    LANGUAGE sql
    AS $$	SELECT 0.1 AS result
$$;


ALTER FUNCTION bakehouse.transport_allowance_rate() OWNER TO pdcawley;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ingredient; Type: TABLE; Schema: bakehouse; Owner: pdcawley
--

CREATE TABLE ingredient (
    name character varying(255) NOT NULL,
    type text,
    pack_quantity numeric(6,3),
    unit text,
    price money,
    datestamp date DEFAULT '1970-01-01'::date,
    CONSTRAINT ingredient_pack_quantity_check CHECK ((pack_quantity > (0)::numeric))
);


ALTER TABLE ingredient OWNER TO pdcawley;

--
-- Name: recipe_item; Type: TABLE; Schema: bakehouse; Owner: pdcawley
--

CREATE TABLE recipe_item (
    name character varying(255) NOT NULL,
    ingredient character varying(255) NOT NULL,
    amount numeric(6,3)
);


ALTER TABLE recipe_item OWNER TO pdcawley;

--
-- Name: per_unit; Type: MATERIALIZED VIEW; Schema: bakehouse; Owner: pdcawley
--

CREATE MATERIALIZED VIEW per_unit AS
 WITH pu0 AS (
         SELECT ingredient.name,
            (ingredient.price / (ingredient.pack_quantity)::double precision) AS cost
           FROM ingredient
        ), pu1 AS (
         SELECT per_unit_0.name,
            per_unit_0.cost
           FROM pu0 per_unit_0
        UNION
         SELECT r.name,
            (sum((per_unit.cost * (r.amount)::double precision)) / (sum(r.amount))::double precision) AS cost
           FROM (recipe_item r
             JOIN pu0 per_unit ON (((r.ingredient)::text = (per_unit.name)::text)))
          WHERE (NOT ((r.name)::text IN ( SELECT pu0.name
                   FROM pu0)))
          GROUP BY r.name
         HAVING bool_and((per_unit.name IS NOT NULL))
        ), per_unit_2 AS (
         SELECT per_unit_1.name,
            per_unit_1.cost
           FROM pu1 per_unit_1
        UNION ALL
         SELECT r.name,
            (sum((per_unit.cost * (r.amount)::double precision)) / (sum(r.amount))::double precision) AS cost
           FROM (recipe_item r
             JOIN pu1 per_unit ON (((r.ingredient)::text = (per_unit.name)::text)))
          WHERE (NOT ((r.name)::text IN ( SELECT pu1.name
                   FROM pu1)))
          GROUP BY r.name
         HAVING bool_and((per_unit.name IS NOT NULL))
        ), per_unit_3 AS (
         SELECT per_unit_2.name,
            per_unit_2.cost
           FROM per_unit_2
        UNION ALL
         SELECT r.name,
            (sum((per_unit.cost * (r.amount)::double precision)) / (sum(r.amount))::double precision) AS cost
           FROM (recipe_item r
             JOIN per_unit_2 per_unit ON (((r.ingredient)::text = (per_unit.name)::text)))
          WHERE (NOT ((r.name)::text IN ( SELECT per_unit_2.name
                   FROM per_unit_2)))
          GROUP BY r.name
         HAVING bool_and((per_unit.name IS NOT NULL))
        ), per_unit_4 AS (
         SELECT per_unit_3.name,
            per_unit_3.cost
           FROM per_unit_3
        UNION ALL
         SELECT r.name,
            (sum((per_unit.cost * (r.amount)::double precision)) / (sum(r.amount))::double precision) AS cost
           FROM (recipe_item r
             JOIN per_unit_3 per_unit ON (((r.ingredient)::text = (per_unit.name)::text)))
          WHERE (NOT ((r.name)::text IN ( SELECT per_unit_3.name
                   FROM per_unit_3)))
          GROUP BY r.name
         HAVING bool_and((per_unit.name IS NOT NULL))
        )
 SELECT per_unit_4.name,
    per_unit_4.cost
   FROM per_unit_4
UNION ALL
 SELECT r.name,
    (sum((per_unit.cost * (r.amount)::double precision)) / (sum(r.amount))::double precision) AS cost
   FROM (recipe_item r
     JOIN per_unit_4 per_unit ON (((r.ingredient)::text = (per_unit.name)::text)))
  WHERE (NOT ((r.name)::text IN ( SELECT per_unit_4.name
           FROM per_unit_4)))
  GROUP BY r.name
 HAVING bool_and((per_unit.name IS NOT NULL))
  WITH NO DATA;


ALTER TABLE per_unit OWNER TO pdcawley;

--
-- Name: product; Type: TABLE; Schema: bakehouse; Owner: pdcawley
--

CREATE TABLE product (
    product character varying NOT NULL,
    packaging money,
    labour money,
    delivery money,
    gross_margin integer DEFAULT 25,
    per_hour integer
);


ALTER TABLE product OWNER TO pdcawley;

--
-- Name: recipe; Type: TABLE; Schema: bakehouse; Owner: pdcawley
--

CREATE TABLE recipe (
    name character varying(255) NOT NULL,
    type character varying(30),
    pieces integer,
    scale_weight numeric(5,3)
);


ALTER TABLE recipe OWNER TO pdcawley;

--
-- Name: cost_breakdown; Type: VIEW; Schema: bakehouse; Owner: pdcawley
--

CREATE VIEW cost_breakdown AS
 WITH basic_cost AS (
         SELECT (product.product)::text AS product,
            (pu.cost * (r.scale_weight)::double precision) AS ingredient,
            COALESCE(product.packaging, money(0)) AS packaging,
            COALESCE(product.labour, (hourly_rate() / (product.per_hour)::double precision)) AS labour,
            COALESCE(((product.gross_margin)::numeric / 100.0), 0.25) AS margin
           FROM ((product
             JOIN per_unit pu ON (((pu.name)::text = (product.product)::text)))
             JOIN recipe r ON (((pu.name)::text = (r.name)::text)))
        ), wholesale AS (
         SELECT bc_1.product,
            (((bc_1.ingredient + bc_1.packaging) + bc_1.labour) / ((((1)::numeric - transport_allowance_rate()) - bc_1.margin))::double precision) AS price
           FROM basic_cost bc_1
        ), price AS (
         SELECT bc_1.product,
            (bc_1.ingredient + bc_1.packaging) AS materials,
            (((bc_1.ingredient + bc_1.packaging) + bc_1.labour) + (wholesale.price * (transport_allowance_rate())::double precision)) AS cost,
            (wholesale.price * (transport_allowance_rate())::double precision) AS transport,
            wholesale.price AS wholesale,
            ((1.33)::double precision * wholesale.price) AS retail
           FROM (basic_cost bc_1
             JOIN wholesale ON ((wholesale.product = bc_1.product)))
        )
 SELECT price.product,
    price.materials,
    bc.labour,
    price.transport,
    price.wholesale,
    (bc.margin * (100)::numeric) AS "margin (%age)",
    price.retail,
    (price.wholesale - price.cost) AS profit,
    ((((100.0)::double precision * (price.retail - price.wholesale)) / price.retail))::numeric(6,2) AS retail_margin,
    ((((100.0)::double precision * price.materials) / price.wholesale))::numeric(6,2) AS "Materials %age of wholesale",
    ((((100.0)::double precision * price.materials) / price.retail))::numeric(6,2) AS "Materials %age of retail"
   FROM (price
     JOIN basic_cost bc ON ((price.product = bc.product)));


ALTER TABLE cost_breakdown OWNER TO pdcawley;

--
-- Name: production_order; Type: TABLE; Schema: bakehouse; Owner: pdcawley
--

CREATE TABLE production_order (
    product character varying(255),
    quantity integer
);


ALTER TABLE production_order OWNER TO pdcawley;

--
-- Name: recipe_weight; Type: VIEW; Schema: bakehouse; Owner: pdcawley
--

CREATE VIEW recipe_weight AS
 SELECT recipe_item.name,
    sum(recipe_item.amount) AS total
   FROM recipe_item
  GROUP BY recipe_item.name;


ALTER TABLE recipe_weight OWNER TO pdcawley;

--
-- Name: production_list; Type: VIEW; Schema: bakehouse; Owner: pdcawley
--

CREATE VIEW production_list AS
 WITH RECURSIVE job(rank, name, ingredient, quantity) AS (
         SELECT ''::text AS text,
            r.name,
            ri.ingredient,
            (((po.quantity / r.pieces))::numeric * ri.amount)
           FROM ((recipe r
             JOIN recipe_item ri ON (((r.name)::text = (ri.name)::text)))
             JOIN production_order po ON (((r.name)::text = (po.product)::text)))
          WHERE (((r.type)::text = 'product'::text) AND (po.quantity > 0))
        UNION
         SELECT job_1.name,
            job_1.ingredient,
            ri.ingredient,
            ((job_1.quantity / rw.total) * ri.amount)
           FROM ((job job_1
             JOIN recipe_item ri ON (((job_1.ingredient)::text = (ri.name)::text)))
             JOIN recipe_weight rw ON (((job_1.ingredient)::text = (rw.name)::text)))
        )
 SELECT job.name,
    job.ingredient,
    (sum(job.quantity))::numeric(6,3) AS quantity,
    sum((per_unit.cost * (job.quantity)::double precision)) AS cost
   FROM (job
     JOIN per_unit ON (((job.ingredient)::text = (per_unit.name)::text)))
  GROUP BY job.name, job.ingredient;


ALTER TABLE production_list OWNER TO pdcawley;

--
-- Name: ingredient_pkey; Type: CONSTRAINT; Schema: bakehouse; Owner: pdcawley
--

ALTER TABLE ONLY ingredient
    ADD CONSTRAINT ingredient_pkey PRIMARY KEY (name);


--
-- Name: product_pkey; Type: CONSTRAINT; Schema: bakehouse; Owner: pdcawley
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product);


--
-- Name: recipe_item_pkey; Type: CONSTRAINT; Schema: bakehouse; Owner: pdcawley
--

ALTER TABLE ONLY recipe_item
    ADD CONSTRAINT recipe_item_pkey PRIMARY KEY (name, ingredient);


--
-- Name: recipe_pkey; Type: CONSTRAINT; Schema: bakehouse; Owner: pdcawley
--

ALTER TABLE ONLY recipe
    ADD CONSTRAINT recipe_pkey PRIMARY KEY (name);


--
-- Name: ingredient_date; Type: INDEX; Schema: bakehouse; Owner: pdcawley
--

CREATE UNIQUE INDEX ingredient_date ON ingredient USING btree (name, datestamp);


--
-- Name: product_product_fkey; Type: FK CONSTRAINT; Schema: bakehouse; Owner: pdcawley
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_product_fkey FOREIGN KEY (product) REFERENCES recipe(name) ON UPDATE CASCADE;


--
-- Name: production_order_product_fkey; Type: FK CONSTRAINT; Schema: bakehouse; Owner: pdcawley
--

ALTER TABLE ONLY production_order
    ADD CONSTRAINT production_order_product_fkey FOREIGN KEY (product) REFERENCES recipe(name);


--
-- Name: recipe_item_name_fkey; Type: FK CONSTRAINT; Schema: bakehouse; Owner: pdcawley
--

ALTER TABLE ONLY recipe_item
    ADD CONSTRAINT recipe_item_name_fkey FOREIGN KEY (name) REFERENCES recipe(name);


--
-- PostgreSQL database dump complete
--

COMMIT;
