-- Table: researchinview.riv_course_types

-- DROP TABLE researchinview.riv_course_types;

CREATE TABLE researchinview.riv_course_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_course_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_course_types
  OWNER TO kmdata;
