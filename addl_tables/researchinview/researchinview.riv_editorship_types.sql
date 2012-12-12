-- Table: researchinview.riv_editorship_types

-- DROP TABLE researchinview.riv_editorship_types;

CREATE TABLE researchinview.riv_editorship_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_editorship_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_editorship_types
  OWNER TO kmdata;
