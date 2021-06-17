SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE TABLE IF NOT EXISTS public.credentials_entity
(
    id SERIAL,
    name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    data text COLLATE pg_catalog."default" NOT NULL,
    type character varying(32) COLLATE pg_catalog."default" NOT NULL,
    "nodesAccess" json NOT NULL,
    "createdAt" timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    "updatedAt" timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    CONSTRAINT pk_814c3d3c36e8a27fa8edb761b0e PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.credentials_entity
    OWNER to n8n;

COPY public.credentials_entity (id, name, data, type, "nodesAccess", "createdAt", "updatedAt") FROM stdin;
1	rabbitcredentials	U2FsdGVkX1+zK7oKmO9aS8bdWmQ8yaXWZyGj7O5tkStSlu0KFeyaT+RdPkJ+8UIupz9qtrSurk4SyEHfJ8yAauoen7Jvc3ZJlOBglVIzWM0=	rabbitmq	[{"nodeType":"n8n-nodes-base.rabbitmq","date":"2021-06-01T09:59:39.341Z"}]	2021-06-01 09:34:39.09	2021-06-17 13:40:26.426
\.


SELECT pg_catalog.setval('public.credentials_entity_id_seq', 1, true);

