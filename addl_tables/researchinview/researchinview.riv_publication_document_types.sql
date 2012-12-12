-- Table: researchinview.riv_publication_document_types

-- DROP TABLE researchinview.riv_publication_document_types;

CREATE TABLE researchinview.riv_publication_document_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_publication_document_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_publication_document_types
  OWNER TO kmdata;
