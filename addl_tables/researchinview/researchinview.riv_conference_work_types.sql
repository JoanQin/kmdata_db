-- Table: researchinview.riv_conference_work_types

-- DROP TABLE researchinview.riv_conference_work_types;

CREATE TABLE researchinview.riv_conference_work_types
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_conference_work_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_conference_work_types
  OWNER TO kmdata;
