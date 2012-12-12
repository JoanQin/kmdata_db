-- Table: researchinview.riv_advising_accomplishments

-- DROP TABLE researchinview.riv_advising_accomplishments;

CREATE TABLE researchinview.riv_advising_accomplishments
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_advising_accomplishments_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_advising_accomplishments
  OWNER TO kmdata;
