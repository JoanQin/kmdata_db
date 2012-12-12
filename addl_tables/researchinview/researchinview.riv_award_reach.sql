-- Table: researchinview.riv_award_reach

-- DROP TABLE researchinview.riv_award_reach;

CREATE TABLE researchinview.riv_award_reach
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_award_reach_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_award_reach
  OWNER TO kmdata;
