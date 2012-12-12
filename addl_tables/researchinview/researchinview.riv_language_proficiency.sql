-- Table: researchinview.riv_language_proficiency

-- DROP TABLE researchinview.riv_language_proficiency;

CREATE TABLE researchinview.riv_language_proficiency
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_language_proficiency_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_language_proficiency
  OWNER TO kmdata;
