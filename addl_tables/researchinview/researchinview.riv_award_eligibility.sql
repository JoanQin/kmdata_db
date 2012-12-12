-- Table: researchinview.riv_award_eligibility

-- DROP TABLE researchinview.riv_award_eligibility;

CREATE TABLE researchinview.riv_award_eligibility
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_award_eligibility_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_award_eligibility
  OWNER TO kmdata;
