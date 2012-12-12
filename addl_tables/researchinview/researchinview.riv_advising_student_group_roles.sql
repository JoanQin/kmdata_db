-- Table: researchinview.riv_advising_student_group_roles

-- DROP TABLE researchinview.riv_advising_student_group_roles;

CREATE TABLE researchinview.riv_advising_student_group_roles
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_advising_student_group_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_advising_student_group_roles
  OWNER TO kmdata;
