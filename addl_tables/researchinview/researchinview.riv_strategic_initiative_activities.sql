-- Table: researchinview.riv_strategic_initiative_activities

-- DROP TABLE researchinview.riv_strategic_initiative_activities;

CREATE TABLE researchinview.riv_strategic_initiative_activities
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_strategic_initiative_activities_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_strategic_initiative_activities
  OWNER TO kmdata;
