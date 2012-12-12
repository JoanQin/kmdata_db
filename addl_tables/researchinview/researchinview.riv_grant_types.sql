-- Table: researchinview.riv_grant_types

-- DROP TABLE researchinview.riv_grant_types;

CREATE TABLE researchinview.riv_grant_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_grant_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_grant_types
  OWNER TO kmdata;
