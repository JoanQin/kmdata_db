-- Table: researchinview.riv_clinical_hours_freq

-- DROP TABLE researchinview.riv_clinical_hours_freq;

CREATE TABLE researchinview.riv_clinical_hours_freq
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_clinical_hours_freq_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_clinical_hours_freq
  OWNER TO kmdata;
