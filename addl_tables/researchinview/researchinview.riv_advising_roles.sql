﻿-- Table: researchinview.riv_advising_roles

-- DROP TABLE researchinview.riv_advising_roles;

CREATE TABLE researchinview.riv_advising_roles
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_advising_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_advising_roles
  OWNER TO kmdata;
