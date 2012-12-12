-- Table: researchinview.riv_regulatory_approva

-- DROP TABLE researchinview.riv_regulatory_approva;

CREATE TABLE researchinview.riv_regulatory_approva
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_regulatory_approva_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_regulatory_approva
  OWNER TO kmdata;
