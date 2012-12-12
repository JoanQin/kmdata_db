-- Table: researchinview.riv_cip_lookup

-- DROP TABLE researchinview.riv_cip_lookup;

CREATE TABLE researchinview.riv_cip_lookup
(
  id bigserial NOT NULL,
  name character varying(1000),
  value character varying(50),
  CONSTRAINT riv_cip_lookup_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_cip_lookup
  OWNER TO kmdata;
