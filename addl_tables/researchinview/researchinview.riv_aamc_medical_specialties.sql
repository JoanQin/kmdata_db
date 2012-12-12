-- Table: researchinview.riv_aamc_medical_specialties

-- DROP TABLE researchinview.riv_aamc_medical_specialties;

CREATE TABLE researchinview.riv_aamc_medical_specialties
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_aamc_medical_specialties_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_aamc_medical_specialties
  OWNER TO kmdata;
