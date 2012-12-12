-- Table: researchinview.riv_countries

-- DROP TABLE researchinview.riv_countries;

CREATE TABLE researchinview.riv_countries
(
  id bigserial NOT NULL,
  name character varying(100),
  value character varying(50),
  CONSTRAINT riv_countries_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_countries
  OWNER TO kmdata;
