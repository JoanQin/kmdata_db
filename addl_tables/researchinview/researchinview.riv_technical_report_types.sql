-- Table: researchinview.riv_technical_report_types

-- DROP TABLE researchinview.riv_technical_report_types;

CREATE TABLE researchinview.riv_technical_report_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_technical_report_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_technical_report_types
  OWNER TO kmdata;
