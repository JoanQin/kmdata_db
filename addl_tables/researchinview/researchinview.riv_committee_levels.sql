-- Table: researchinview.riv_committee_levels

-- DROP TABLE researchinview.riv_committee_levels;

CREATE TABLE researchinview.riv_committee_levels
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_committee_levels_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_committee_levels
  OWNER TO kmdata;
