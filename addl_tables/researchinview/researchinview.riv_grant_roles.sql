-- Table: researchinview.riv_grant_roles

-- DROP TABLE researchinview.riv_grant_roles;

CREATE TABLE researchinview.riv_grant_roles
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_grant_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_grant_roles
  OWNER TO kmdata;
