-- Table: researchinview.riv_clinical_service_types

-- DROP TABLE researchinview.riv_clinical_service_types;

CREATE TABLE researchinview.riv_clinical_service_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_clinical_service_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_clinical_service_types
  OWNER TO kmdata;
