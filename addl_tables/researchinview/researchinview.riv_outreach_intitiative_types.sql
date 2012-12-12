-- Table: researchinview.riv_outreach_intitiative_types

-- DROP TABLE researchinview.riv_outreach_intitiative_types;

CREATE TABLE researchinview.riv_outreach_intitiative_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_outreach_intitiative_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_outreach_intitiative_types
  OWNER TO kmdata;
