-- Table: researchinview.riv_position_types

-- DROP TABLE researchinview.riv_position_types;

CREATE TABLE researchinview.riv_position_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_position_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_position_types
  OWNER TO kmdata;
