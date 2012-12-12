-- Table: researchinview.riv_presentation_roles

-- DROP TABLE researchinview.riv_presentation_roles;

CREATE TABLE researchinview.riv_presentation_roles
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_presentation_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_presentation_roles
  OWNER TO kmdata;
