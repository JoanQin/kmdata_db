-- Table: researchinview.riv_degree_types

-- DROP TABLE researchinview.riv_degree_types;

CREATE TABLE researchinview.riv_degree_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_degree_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_degree_types
  OWNER TO kmdata;
