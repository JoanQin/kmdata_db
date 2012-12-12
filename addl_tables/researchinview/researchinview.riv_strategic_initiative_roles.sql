-- Table: researchinview.riv_strategic_initiative_roles

-- DROP TABLE researchinview.riv_strategic_initiative_roles;

CREATE TABLE researchinview.riv_strategic_initiative_roles
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_strategic_initiative_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_strategic_initiative_roles
  OWNER TO kmdata;
