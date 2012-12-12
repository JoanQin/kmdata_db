-- Table: researchinview.riv_edited_book_types

-- DROP TABLE researchinview.riv_edited_book_types;

CREATE TABLE researchinview.riv_edited_book_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_edited_book_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_edited_book_types
  OWNER TO kmdata;
