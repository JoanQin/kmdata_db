-- Table: researchinview.riv_conference_reach_types

-- DROP TABLE researchinview.riv_conference_reach_types;

CREATE TABLE researchinview.riv_conference_reach_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_conference_reach_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_conference_reach_types
  OWNER TO kmdata;
