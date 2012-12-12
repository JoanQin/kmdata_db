-- Table: researchinview.riv_academic_calendar_timeframes

-- DROP TABLE researchinview.riv_academic_calendar_timeframes;

CREATE TABLE researchinview.riv_academic_calendar_timeframes
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_academic_calendar_timeframes_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_academic_calendar_timeframes
  OWNER TO kmdata;
