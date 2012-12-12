-- Table: researchinview.riv_academic_calendar_types

-- DROP TABLE researchinview.riv_academic_calendar_types;

CREATE TABLE researchinview.riv_academic_calendar_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_academic_calendar_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_academic_calendar_types
  OWNER TO kmdata;
