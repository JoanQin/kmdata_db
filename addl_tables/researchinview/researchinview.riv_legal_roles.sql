-- Table: researchinview.riv_legal_roles

-- DROP TABLE researchinview.riv_legal_roles;

CREATE TABLE researchinview.riv_legal_roles
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_legal_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_legal_roles
  OWNER TO kmdata;
