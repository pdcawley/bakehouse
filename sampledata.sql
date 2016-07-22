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

SET search_path = bakehouse, pg_catalog;

--
-- Data for Name: ingredient; Type: TABLE DATA; Schema: bakehouse; Owner: pdcawley
--

COPY ingredient (name, type, pack_quantity, unit, price, datestamp) FROM stdin;
Organic white flour	basic-ingredient	25.000	kg	£21.50	1970-01-01
Organic olive oil	basic-ingredient	5.000	L	£28.90	1970-01-01
Organic dried yeast	basic-ingredient	0.500	kg	£13.25	1970-01-01
Sea salt	basic-ingredient	25.000	kg	£7.15	1970-01-01
Water	basic-ingredient	1.000	kg	£0.00	1970-01-01
\.


--
-- Data for Name: recipe; Type: TABLE DATA; Schema: bakehouse; Owner: pdcawley
--

COPY recipe (name, type, pieces, scale_weight) FROM stdin;
100% Sponge	sponge	1	\N
Basic Loaf Dough	dough	1	\N
Large White	product	1	0.900
Scotch Rolls	product	12	0.080
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: bakehouse; Owner: pdcawley
--

COPY product (product, packaging, labour, delivery, gross_margin, per_hour) FROM stdin;
Large White	\N	\N	\N	25	16
Scotch Rolls	\N	\N	\N	25	72
\.


--
-- Data for Name: production_order; Type: TABLE DATA; Schema: bakehouse; Owner: pdcawley
--

COPY production_order (product, quantity) FROM stdin;
Large White	12
\.


--
-- Data for Name: recipe_item; Type: TABLE DATA; Schema: bakehouse; Owner: pdcawley
--

COPY recipe_item (name, ingredient, amount) FROM stdin;
100% Sponge	Organic white flour	0.225
100% Sponge	Water	0.225
100% Sponge	Organic dried yeast	0.003
Basic Loaf Dough	100% Sponge	0.225
Basic Loaf Dough	Organic white flour	0.225
Basic Loaf Dough	Water	0.105
Basic Loaf Dough	Organic olive oil	0.015
Basic Loaf Dough	Sea salt	0.004
Scotch Rolls	Basic Loaf Dough	1.035
Large White	Basic Loaf Dough	0.950
\.


--
-- PostgreSQL database dump complete
--

