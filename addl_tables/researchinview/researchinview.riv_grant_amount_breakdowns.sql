-- Table: researchinview.riv_grant_amount_breakdowns

-- DROP TABLE researchinview.riv_grant_amount_breakdowns;

CREATE TABLE researchinview.riv_grant_amount_breakdowns
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_grant_amount_breakdowns_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_grant_amount_breakdowns
  OWNER TO kmdata;
