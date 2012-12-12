-- Table: researchinview.riv_currency_types

-- DROP TABLE researchinview.riv_currency_types;

CREATE TABLE researchinview.riv_currency_types
(
  id bigserial NOT NULL,
  name character varying(50),
  value character varying(50),
  CONSTRAINT riv_currency_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_currency_types
  OWNER TO kmdata;
