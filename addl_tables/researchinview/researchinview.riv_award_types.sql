-- Table: researchinview.riv_award_types

-- DROP TABLE researchinview.riv_award_types;

CREATE TABLE researchinview.riv_award_types
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_award_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_award_types
  OWNER TO kmdata;
