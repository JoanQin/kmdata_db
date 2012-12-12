-- Table: researchinview.riv_consultant_activity_types

-- DROP TABLE researchinview.riv_consultant_activity_types;

CREATE TABLE researchinview.riv_consultant_activity_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_consultant_activity_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_consultant_activity_types
  OWNER TO kmdata;
