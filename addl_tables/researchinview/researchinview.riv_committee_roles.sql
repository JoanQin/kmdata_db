-- Table: researchinview.riv_committee_roles

-- DROP TABLE researchinview.riv_committee_roles;

CREATE TABLE researchinview.riv_committee_roles
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_committee_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_committee_roles
  OWNER TO kmdata;
