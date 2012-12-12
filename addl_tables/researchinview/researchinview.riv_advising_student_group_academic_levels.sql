-- Table: researchinview.riv_advising_student_group_academic_levels

-- DROP TABLE researchinview.riv_advising_student_group_academic_levels;

CREATE TABLE researchinview.riv_advising_student_group_academic_levels
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_advising_student_group_academic_levels_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_advising_student_group_academic_levels
  OWNER TO kmdata;
