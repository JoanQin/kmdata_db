-- Table: researchinview.riv_advising_academic_levels

-- DROP TABLE researchinview.riv_advising_academic_levels;

CREATE TABLE researchinview.riv_advising_academic_levels
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_advising_academic_levels_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_advising_academic_levels
  OWNER TO kmdata;
