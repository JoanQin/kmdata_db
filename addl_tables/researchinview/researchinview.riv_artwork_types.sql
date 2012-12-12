-- Table: researchinview.riv_artwork_types

-- DROP TABLE researchinview.riv_artwork_types;

CREATE TABLE researchinview.riv_artwork_types
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_artwork_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_artwork_types
  OWNER TO kmdata;
