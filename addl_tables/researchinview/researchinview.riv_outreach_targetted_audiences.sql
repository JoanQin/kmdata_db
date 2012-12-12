-- Table: researchinview.riv_outreach_targetted_audiences

-- DROP TABLE researchinview.riv_outreach_targetted_audiences;

CREATE TABLE researchinview.riv_outreach_targetted_audiences
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_outreach_targetted_audiences_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_outreach_targetted_audiences
  OWNER TO kmdata;
