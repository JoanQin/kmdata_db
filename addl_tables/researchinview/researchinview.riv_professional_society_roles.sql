-- Table: researchinview.riv_professional_society_roles

-- DROP TABLE researchinview.riv_professional_society_roles;

CREATE TABLE researchinview.riv_professional_society_roles
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_professional_society_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_professional_society_roles
  OWNER TO kmdata;
