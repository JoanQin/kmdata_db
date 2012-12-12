-- Table: researchinview.riv_presentation_audience

-- DROP TABLE researchinview.riv_presentation_audience;

CREATE TABLE researchinview.riv_presentation_audience
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_presentation_audience_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_presentation_audience
  OWNER TO kmdata;
