-- Table: researchinview.riv_outreach_activities

-- DROP TABLE researchinview.riv_outreach_activities;

CREATE TABLE researchinview.riv_outreach_activities
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_outreach_activities_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_outreach_activities
  OWNER TO kmdata;
