-- Table: researchinview.riv_advising_student_group_type

-- DROP TABLE researchinview.riv_advising_student_group_type;

CREATE TABLE researchinview.riv_advising_student_group_type
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_advising_student_group_type_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_advising_student_group_type
  OWNER TO kmdata;
