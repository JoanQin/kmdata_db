-- Table: researchinview.riv_clinical_roles

-- DROP TABLE researchinview.riv_clinical_roles;

CREATE TABLE researchinview.riv_clinical_roles
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_clinical_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_clinical_roles
  OWNER TO kmdata;
