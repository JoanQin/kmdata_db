-- Table: researchinview.riv_grant_funding_agency_types

-- DROP TABLE researchinview.riv_grant_funding_agency_types;

CREATE TABLE researchinview.riv_grant_funding_agency_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_grant_funding_agency_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_grant_funding_agency_types
  OWNER TO kmdata;
