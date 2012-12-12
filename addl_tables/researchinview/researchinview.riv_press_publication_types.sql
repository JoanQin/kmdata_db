-- Table: researchinview.riv_press_publication_types

-- DROP TABLE researchinview.riv_press_publication_types;

CREATE TABLE researchinview.riv_press_publication_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_press_publication_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_press_publication_types
  OWNER TO kmdata;
