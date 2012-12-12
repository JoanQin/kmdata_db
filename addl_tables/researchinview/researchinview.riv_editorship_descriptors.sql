-- Table: researchinview.riv_editorship_descriptors

-- DROP TABLE researchinview.riv_editorship_descriptors;

CREATE TABLE researchinview.riv_editorship_descriptors
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_editorship_descriptors_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_editorship_descriptors
  OWNER TO kmdata;
