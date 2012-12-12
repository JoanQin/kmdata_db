-- Table: researchinview.riv_unpublish_review_types

-- DROP TABLE researchinview.riv_unpublish_review_types;

CREATE TABLE researchinview.riv_unpublish_review_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_unpublish_review_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_unpublish_review_types
  OWNER TO kmdata;
